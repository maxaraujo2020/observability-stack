#!bin/bash
sudo mkdir /etc/ecs
echo ECS_CLUSTER=${tf_cluster_name} >> /etc/ecs/ecs.config;