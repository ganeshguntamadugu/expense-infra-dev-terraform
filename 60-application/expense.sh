#!/bin/bash
dnf install ansible -y
cd /tmp
git clone https://github.com/ganeshguntamadugu/expense-project-ansible.git
cd expense-project-ansible
ansible-playbook -i inventory.ini mysql.yaml
ansible-playbook -i inventory.ini backend.yaml
ansible-playbook -i inventory.ini frontend.yaml