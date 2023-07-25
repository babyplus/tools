docker run --rm -it -v $HOME/.ssh:/root/.ssh -v /etc/hosts:/etc/hosts -v `pwd`/etc/ansible:/etc/ansible -w /etc/ansible/yml my_ansible:b2211236e356 ansible-playbook main.yml $1
