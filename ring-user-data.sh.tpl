#!/bin/bash

cat << EOF > /home/ec2-user/ring.sh
#!/bin/bash

# DOWNLOAD THE RING-FILE
aws s3 cp s3://${bucket_name}/ring-file /home/ec2-user/tmp-file

# INCREMENT THE VALUE INSIDE THE FILE
## EXPORT VARIABLE FROM THE FILE
source /home/ec2-user/tmp-file
echo "The current ring value is \$RING_VALUE"

if [ \$POSITION == ${server_position} ]; then
    # CREATE NEW VAR TO INCREMENT THE VALUE
    NEW_VALUE=\$((RING_VALUE+1))

    # PUT THE NEW VALUE BACK INSIDE THE RING-FILE
    cat << EOT > /home/ec2-user/ring-file
POSITION=%{if server_position == max_position}1%{else}${server_position +1}%{ endif }
RING_VALUE=\$NEW_VALUE
EOT

    # UPLOAD THE RING-FILE BACK TO S3
    aws s3 cp /home/ec2-user/ring-file s3://${bucket_name}/ring-file
fi
EOF

# CREATE THE CRON JOB
chmod +x /home/ec2-user/ring.sh
(crontab -l ; echo "*/1 * * * * /home/ec2-user/ring.sh") | sort - | uniq - | crontab -