output "instance_ami" {
  value = aws_instance.web_vlg.ami
}

output "instance_arn" {
  value = aws_instance.web_vlg.arn
}
