#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# hide the evidence
clear

# Put your stuff here
pe "env"

pe "curl -sSL https://dl.signalfx.com/splunk-otel-collector.sh > /tmp/splunk-otel-collector.sh && \
sudo sh /tmp/splunk-otel-collector.sh --realm $REALM -- $ACCESS_TOKEN --mode agent --without-fluentd --with-instrumentation --deployment-environment $INSTANCE-petclinic --enable-profiler --enable-profiler-memory --enable-metrics --hec-token $HEC_TOKEN --hec-url $HEC_URL"

pe "sudo systemctl status splunk-otel-collector"

pe "sudo sed -i 's/gcp, ecs, ec2, azure, system/system, gcp, ecs, ec2, azure/g' /etc/otel/collector/agent_config.yaml"

pe "sudo systemctl restart splunk-otel-collector"

pe "sudo systemctl status splunk-otel-collector"

pe "git clone https://github.com/spring-projects/spring-petclinic"

pe "cd spring-petclinic && git checkout 276880e"

pe "sudo docker run -d -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 docker.io/biarms/mysql:5.7"

pe "sudo docker ps -a"

pe "sudo docker run --network="host" -d -p 8090:8090 -v ~/workshop/petclinic:/mnt/locust docker.io/locustio/locust -f /mnt/locust/locustfile.py --headless -u 1 -r 1 -H http://127.0.0.1:8083"

pe "sudo docker ps -a"

pe "./mvnw package -Dmaven.test.skip=true"

pe "curl ifconfig.me"

pe "echo $INSTANCE"
