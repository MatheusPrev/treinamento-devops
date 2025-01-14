provider "aws" {
  region = "sa-east-1"
}

#data "http" "myip" {
  #url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
#}

data "aws_ami" "ubuntu" {
	  most_recent = true
	  owners      = ["099720109477"]
	  filter {
	    name   = "name"
	    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
	  }
	}

resource "aws_instance" "maquina_master" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name      = "key_matheus_dev_ubunto"
  subnet_id     = "subnet-009732771798c000e"
  associate_public_ip_address = true
  tags = {
    Name = "matheus-cluster-kubernetes-master"
  }
  root_block_device {
    volume_size = 8
    encrypted = true
  }
  vpc_security_group_ids = ["${aws_security_group.acessos_master.id}"]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "key_matheus_dev_ubunto"
  subnet_id     = "subnet-009732771798c000e"
  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
    encrypted = true
  }
  tags = {
    Name = "matheus-cluster-kubernetes-${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.acessos_workers.id}"]
  count         = 2
}


resource "aws_security_group" "acessos_master" {
  name        = "acessos_master_matheus"
  description = "acessos_workers inbound traffic"
  vpc_id      = "vpc-0b85884576e0bb066"
  
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "Libera porta kubernetes"
      from_port        = 6443
      to_port          = 6443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      #security_groups  = ["sg-002a97fcc1b52b800"]
      security_groups  = ["sg-0e04d843c1167fa99"]
      self             = false
      to_port          = 0
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master"
  }
}


resource "aws_security_group" "acessos_workers" {
  name        = "acessos_workers_matheus"
  description = "acessos_workers inbound traffic"
  vpc_id      = "vpc-0b85884576e0bb066"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      #security_groups  = ["sg-0e04d843c1167fa99"]
      security_groups  = ["sg-002a97fcc1b52b800"]
      self             = false
      to_port          = 0
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_workers"
  }
}


# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip} - ssh -i ~/ssh/id_rsa ubuntu@${aws_instance.maquina_master.private_dns}"
  ]
}

# terraform refresh para mostrar o ssh
output "aws_instance_e_ssh" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip} - ssh -i ~/.ssh/id_rsa ubuntu@${item.private_dns}"
  ]
}
