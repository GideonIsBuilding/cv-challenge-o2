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
