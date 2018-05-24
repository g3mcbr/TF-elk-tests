#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# install awscli for remainder of script to run
yum install -y aws-cli

mkdir -p /wazuh/master/etc
mkdir -p /wazuh/slave/etc

aws s3 cp s3://elk-test-running-state/dev/elktest/config/master/ossec.conf /wazuh/master/etc
aws s3 cp s3://elk-test-running-state/dev/elktest/config/slave/ossec.conf /wazuh/slave/etc
