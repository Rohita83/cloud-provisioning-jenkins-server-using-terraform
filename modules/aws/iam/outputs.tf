output "jenkins_instance_profile" {
   description = "NAME of the jenkins_instance_profile"
   value = aws_iam_instance_profile.jenkins_instance_profile.name
}