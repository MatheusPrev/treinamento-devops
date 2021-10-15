variable "subnet_id" {
  description = "Digite a Subnet onde deseja criar a máquina: "
  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "O valor da subnet_id não é válido, tem que começar com \"subnet-\"."
  }
}

variable "ami" {
  description = "Digite a AMI que iremos utilizar: "
  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
}

variable "tamanho" {
  description = "Digite qual é o tamanho da máquina (large, micro...): "
  validation {
    condition     = length(var.tamanho) > 3 && substr(var.tamanho, 0, 3) == "t2."
    error_message = "O valor do tamanho não é válido, tem que começar com \"t2.\"."
  }
}

variable "quantidade" {
  description = "Digite a quantidade de máquinas que deseja: "
}

variable "nome" {
  description = "Digite o nome das máquinas: "
}
