#!/bin/bash
echo "Install pip" 
apt-get update
apt-get install -y python-pip

echo "Install awscli"
pip install awscli

echo "Install kops" 
wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

echo "Install kubectl"
wget -O kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


echo "Deploy KOPS"
sudo -u ubuntu -i -E bash -i << EOF
echo "Configure aws" > ${user_home}/out.log
aws configure set aws_access_key_id ${aws_key_id}
aws configure set aws_secret_access_key ${aws_secret}
aws configure set default.region ${region_default}

echo "Export AWS\n" >> ${user_home}/out.log
echo 'export AWS_ACCESS_KEY_ID=${aws_key_id}' >> ${user_home}/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY=${aws_secret}' >> ${user_home}/.bashrc

echo "Prepare kops\n" >> ${user_home}/out.log
echo 'export NAME=${cluster_name}' >> ${user_home}/.bashrc
echo 'export KOPS_STATE_STORE=s3://${kops_s3_store}' >> ${user_home}/.bashrc

echo "Create ssh key\n" >> ${user_home}/out.log
ssh-keygen -t rsa -f ${user_home}/.ssh/id_rsa -q -P ""

echo "Get zones\n" >> ${user_home}/out.log
echo 'export ZONES=${zones}' >> ${user_home}/.bashrc

echo "Creating Cluster"
kops create cluster $NAME \
  --zones $ZONES \
  --authorization RBAC \
  --master-size ${master_size} \
  --master-volume-size ${master_volume} \
  --node-size ${node_size} \
  --node-volume-size ${node_volume} \
  --node-count ${node_count}
  --yes
EOF