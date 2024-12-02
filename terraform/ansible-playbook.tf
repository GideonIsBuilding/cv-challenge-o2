resource "null_resource" "ansible" {
    provisioner "local-exec" {
        command = <<EOT
        ansible-playbook -i ../ansible/inventory ../ansible/playbook.yml --extra-vars "@../ansible/vars/docker_hub.yml"
        EOT
    }

    depends_on = [ aws_instance.app ]
}