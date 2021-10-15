output "ssh_connect" {
  value = [
    for key, item in aws_instance.web :
      "ec2 ${key+1} - ${item.private_ip} - ssh -i ~/.ssh/id_rsa ubuntu@${item.private_ip}"
  ]
}
