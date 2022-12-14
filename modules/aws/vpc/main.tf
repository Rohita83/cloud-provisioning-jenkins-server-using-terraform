variable "vpc_cidr_block" {
	description = "CIDR block of the VPC"
}

variable "project_name" {
   description = "Project Name"
}

variable "jenkins_subnet_cidr_block" {
	description = "CIDR block of the public subnet"
}

variable "management_name" {
}

data "aws_availability_zones" "available" {
	state = "available"
}

resource "aws_vpc" "jenkins_vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		Name = "${var.management_name}-jenkins_vpc"
		Project = "${var.project_name}"
	}
}

resource "aws_subnet" "jenkins_public_subnet" {
	vpc_id = aws_vpc.jenkins_vpc.id
	cidr_block = var.jenkins_subnet_cidr_block
	availability_zone = data.aws_availability_zones.available.names[0]

	tags = {
		Name = "${var.management_name}-jenkins_subnet"
		Project = "${var.project_name}"
	}
}

resource "aws_internet_gateway" "jenkins_igw" {
	vpc_id = aws_vpc.jenkins_vpc.id

	tags = {
		Name = "${var.management_name}-jenkins_igw"
		Project = "${var.project_name}"
	}
}

resource "aws_route_table" "jenkins_public_rt" {
	vpc_id = aws_vpc.jenkins_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.jenkins_igw.id
	}
}

resource "aws_route_table_association" "public" {
	route_table_id = aws_route_table.jenkins_public_rt.id
	subnet_id = aws_subnet.jenkins_public_subnet.id
}
