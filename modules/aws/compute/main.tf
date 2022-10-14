variable "security_group" {
   description = "The security groups assigned to the Jenkins server"
}

variable "public_subnet" {
   description = "The public subnet IDs assigned to the Jenkins server"
}

variable "management_name" {
}

variable "jenkins_size" {
}

variable "key_name" {
}

variable "jenkins_ami_id" {
}

variable "vpc_id" {
   description = "ID of the VPC"
   type        = string
}


variable "project_name" {
   description = "Project Name"
}


variable "my_ip" {
   description = "My IP address"
   type = string
}

# variable "role_name" {
# 	description = "Role Name"
# }

# resource "aws_iam_instance_profile" "jenkins_instance_profile" {
#   name = "jenkins-instance-profile"
#   role = var.role_name
# }

resource "aws_instance" "jenkins_server" {
   ami = "${var.jenkins_ami_id}"
   subnet_id = var.public_subnet
   instance_type = "${var.jenkins_size}"
   vpc_security_group_ids = [var.security_group]
   # key_name = var.key_name
   # Setting the key pair name to the key pair we created
   key_name = aws_key_pair.wo_kp.key_name
   # iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name
   # Setting the user data to the bash file called install_jenkins.sh
   user_data = "${file("${path.module}/install_jenkins.sh")}"
   tags = {
      Name = "${var.management_name}-jenkins-instance"
      Project = "${var.project_name}"     
   }
}

# Creating a key pair in AWS called tutorial_kp
resource "aws_key_pair" "wo_kp" {
   # Naming the key tutorial_kp
   key_name   = "wo_kp"

   # Passing the public key of the key pair we created
   public_key = file("${path.module}/wo_kp.pub")
}

resource "aws_eip" "jenkins_eip" {
   instance = aws_instance.jenkins_server.id
   vpc      = true

   tags = {
      Name = "${var.management_name}-jenkins-instance"
      Project = "${var.project_name}"     
   }
}