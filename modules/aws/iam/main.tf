variable "role_name" {
	description = "Role Name"
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = var.role_name
}