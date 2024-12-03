resource "null_resource" "ansible" {
    provisioner "local-exec" {
        command = "ansible-playbook -vvv -T 180 -i /home/gideon/cv-challenge-o2/ansible/inventory /home/gideon/cv-challenge-o2/ansible/playbook.yml --extra-vars '@/home/gideon/cv-challenge-o2/ansible/vars/docker_hub.yml'"
    }

    depends_on = [ aws_instance.app ]
}

# command = "ansible-playbook -i ${path.module}/../ansible/inventory ${path.module}/../ansible/playbook.yml --extra-vars '@${path.module}/../ansible/vars/docker_hub.yml'"

# ansible-playbook -i inventory playbook.yml --extra-vars @vars/docker_hub.yml