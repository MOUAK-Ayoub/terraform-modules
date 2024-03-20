#!/bin/bash
echo '*********************************************** Script begin*****************************************'
sudo -u ec2-user -i <<'EOF'

yum install -y python3
yum install -y python3-pip
pip3 install --user ansible

# work after reboot, maybe because I installed ansible with yum before
ansible --version

# For ec2 dynamic inventory install
pip3 install boto3 botocore

pip3 install "pywinrm>=0.3.0"

EOF

echo '*********************************************** Script end*****************************************'
