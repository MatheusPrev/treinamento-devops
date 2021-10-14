output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

#output "subnet_id" {
  #value = "${data.aws_subnet.test_subnet.*.id}"
#}
