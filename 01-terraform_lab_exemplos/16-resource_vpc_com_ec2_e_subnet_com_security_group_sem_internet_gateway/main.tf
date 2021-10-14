provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "key_matheus_dev_ubunto" # key chave publica cadastrada na AWS 
  subnet_id               =  aws_subnet.my_subnet.id # vincula a subnet direto e gera o IP automático
  private_ip              = "172.16.10.101"
  # vpc_security_group_ids  = ["${aws_security_group.allow_ssh1.id}"]

  tags = {
    Name = "Maquina para testar VPC"
  }
}

resource "aws_instance" "web2" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "Itau_treinamento" # key chave publica cadastrada na AWS 
  subnet_id               =  aws_subnet.my_subnet_b.id # vincula a subnet direto e gera o IP automático
  private_ip              = "172.16.20.100"
  # vpc_security_group_ids  = ["${aws_security_group.allow_ssh1.id}"]

  tags = {
    Name = "Maquina2 para testar VPC"
  }
}
