#!/usr/bin/env bash
docker-compose up -d
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --vault-password-file passwd.txt
docker-compose stop
