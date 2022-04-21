data "aws_iam_policy_document" "instance_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ring_challenge" {
  name               = "ring_challenge_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_policy.json
}

data "aws_iam_policy_document" "ring_challenge_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      aws_s3_bucket.ring_challenge.arn,
      "${aws_s3_bucket.ring_challenge.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ring_challenge_policy" {
  name        = "ring-challenge-policy"
  description = "ring-challenge s3 access"

  policy = data.aws_iam_policy_document.ring_challenge_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "list_instance_atch" {
  role       = aws_iam_role.ring_challenge.name
  policy_arn = aws_iam_policy.ring_challenge_policy.arn
}

resource "aws_iam_instance_profile" "ring_challenge_profile" {
  name = "ring_challenge_profile"
  role = aws_iam_role.ring_challenge.name
}