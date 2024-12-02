variable "aws_region" {
    description = "AWS region"
    default     = "us-east-1"
}

variable "ami_id" {
    description = "AMI ID"
    default = "ami-0866a3c8686eaeeba"
}

variable "instance_type" {
    description = "Instance type for EC2"
    default     = "t2.large"
}
