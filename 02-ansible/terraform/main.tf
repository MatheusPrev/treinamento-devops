provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.tamanho
  subnet_id     = var.subnet_id
  #security_groups = ["sg-0575cac87aa810abf"]
  vpc_security_group_ids = ["${aws_security_group.permitir_ssh.id}"]
  count         = var.quantidade
  key_name      = "key_matheus_dev_ubunto"
  
  associate_public_ip_address = true
  
  root_block_device {
    volume_size = 8
    encrypted = true
    #kms_key_id = "7f780024-d5c0-4c59-a9b7-99d5b16578ca"
  }
    
  tags = {
    Name = "ec2-matheus-${var.nome}-${count.index}"
  }
}
