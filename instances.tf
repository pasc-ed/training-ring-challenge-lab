resource "aws_instance" "web_server" {
  count                  = var.max_instances

  ami                    = data.aws_ami.aws_basic_linux.id
  instance_type          = var.ec2_type
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ring_challenge_profile.id
  key_name               = var.my_keypair
  user_data              = templatefile("ring-user-data.sh.tpl", {
    bucket_name = var.bucket_name
    server_position = count.index + 1
    max_position = var.max_instances
  })

  tags = {
    Name = "ring_server_${count.index + 1}"
  }
}