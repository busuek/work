#!/bin/bash

host1='ubuntu'
host2='centos7'
host3='fedora'


for i in ${!host*}; do
  sudo docker run --rm --name ${!i} -d pycontribs/${!i} sleep 3600
done        
        
sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
        
for i in ${!host*}; do
  sudo docker stop ${!i}
done 
