resource "null_resource" "ansible" {
    provisioner "remote-exec" {
    connection {
        host = data.aws_eip.dojo-eip.public_ip
        user = "ubuntu"
        private_key = file("/home/gideon/Downloads/nginix.pem")
    }

    inline = ["echo 'connected!'"]
    }
    provisioner "local-exec" {
        command = "ansible-playbook -i /home/gideon/cv-challenge-o2/ansible/inventory /home/gideon/cv-challenge-o2/ansible/playbook.yml --extra-vars '@/home/gideon/cv-challenge-o2/ansible/vars/docker_hub.yml'"
    }

    depends_on = [ aws_instance.app ]
}
