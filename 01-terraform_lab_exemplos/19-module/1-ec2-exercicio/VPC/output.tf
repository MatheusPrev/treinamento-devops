output "outvpc_id" {
  value = aws_vpc.moduleVPC.id
}

#output "subnet_id" {
  #value = "${data.aws_subnet.test_subnet.*.id}"
#}
