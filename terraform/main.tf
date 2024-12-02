provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "dojo-vpc" {
    cidr_block           = "10.0.0.0/16"  # Address space for the VPC
    enable_dns_support   = true           # Enable DNS support
    enable_dns_hostnames = true           # Enable DNS hostnames
    tags = {
        Name = "dojo-vpc"
    }
}

resource "aws_subnet" "dojo-subnet" {
    vpc_id                  = aws_vpc.dojo-vpc.id
    cidr_block              = "10.0.1.0/24"  # Subnet address range
    map_public_ip_on_launch = false           # Automatically assign public IPs to instances in this subnet
    availability_zone       = "us-east-1a"   # Replace with your preferred AZ
    tags = {
        Name = "dojo-subnet"
    }
}

resource "aws_internet_gateway" "dojo-iGW" {
    vpc_id = aws_vpc.dojo-vpc.id
    tags = {
        Name = "dojo-iGW"
    }
}

resource "aws_route_table" "dojo-route-table" {
    vpc_id = aws_vpc.dojo-vpc.id

    route {
        cidr_block = "0.0.0.0/0"                     # Route all traffic
        gateway_id = aws_internet_gateway.dojo-iGW.id  # To the internet gateway
    }

    tags = {
        Name = "dojo-route-table"
    }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "dojo-route-table-assoc" {
    subnet_id      = aws_subnet.dojo-subnet.id
    route_table_id = aws_route_table.dojo-route-table.id
}

# resource "aws_eip" "dojo-eip" {
#     associate_with_private_ip = true
#     tags = {
#         Name = "Dojo-EIP"
#     }
# }

data "aws_eip" "dojo-eip" {
    filter {
        name   = "tag:Name"
        values = ["devops-dojo"]
    }
}

resource "aws_instance" "app" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.dojo-subnet.id
    vpc_security_group_ids = [aws_security_group.app_security.id]
    key_name = "nginix"
    
    root_block_device {
        volume_type = "gp3"
        volume_size = 16
    }
    tags = {
        Name = "CV-Challenge-Instance"
        }
        
    provisioner "local-exec" {
    command = "echo ${aws_instance.app.public_ip} ansible_user=ubuntu > ../ansible/inventory"
    }
}

resource "aws_eip_association" "dojo-eip-assoc" {
    instance_id   = aws_instance.app.id
    allocation_id = data.aws_eip.dojo-eip.id
}

resource "aws_security_group" "app_security" {
    vpc_id      = aws_vpc.dojo-vpc.id
    name        = "devops-dojo_security"
    description = "Allow necessary ports for containers"

    # Allow traffic for Prometheus
    ingress {
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for Grafana
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for Loki
    ingress {
        from_port   = 3100
        to_port     = 3100
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow backend traffic
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for HTTP
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow frontend traffic
    ingress {
        from_port   = 5173
        to_port     = 5173
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for cAdvisor
    ingress {
        from_port   = 8083
        to_port     = 8083
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for SSH
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for HTTPS
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow Adminer traffic
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow traffic for Nginx Proxy Manager
    ingress {
        from_port   = 81
        to_port     = 81
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "template_file" "ansible_inventory" {
    template = file("../terraform/inventory.tpl")
    vars = {
        public_ip = aws_instance.app.public_ip
    }
}

resource "local_file" "ansible_inventory" {
    content  = data.template_file.ansible_inventory.rendered
    filename = "../ansible/inventory"
}