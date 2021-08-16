provider "aws" {
  profile = var.profile_type
  region  = var.region
}

#State locking
terraform {
  backend "s3" {
    bucket = "iactools"
    key    = "terraform_state/var.state_file"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}

#VPC

resource "aws_vpc" "ust_Katharine" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }

}

#Subnet

resource "aws_subnet" "ust_subnet" {
  vpc_id            = aws_vpc.ust_Katharine.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.aws_az

  tags = {
    Name = var.subnet_name
  }

}

#gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ust_Katharine.id

  tags = {
    Name = var.gw_name
  }
}

#route table

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.ust_Katharine.id

  route {
      cidr_block = var.rt_cidr
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = var.rt_name
  }
}

#Route table association

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.ust_subnet.id
  route_table_id = aws_route_table.rt.id
}

#Elastic IP

resource "aws_eip" "ust_eip" {
  instance = aws_instance.ustInstance.id
  vpc      = true
  associate_with_private_ip = var.private_ip

  tags = {
    Name = var.eip_name
  }

}

#security groups

resource "aws_security_group" "ust_sg" {
  name   = "HTTP, HTTPS and  SSH"
  vpc_id = aws_vpc.ust_Katharine.id

  ingress {
    from_port   = var.ingress_1
    to_port     = var.ingress_1
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  ingress {
    from_port   = var.ingress_2
    to_port     = var.ingress_2
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  ingress {
    from_port   = var.ingress_3
    to_port     = var.ingress_3
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  ingress {
    from_port   = var.ingress_4
    to_port     = var.ingress_4
    protocol    = "tcp"
    cidr_blocks = var.cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.cidr
  }
}

# Network interface

resource "aws_network_interface" "ani" {
  subnet_id       = aws_subnet.ust_subnet.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.ust_sg.id]

  tags = {
    Name = var.ani_name
  }

}


#resource "aws_ebs_volume" "ebs" {
#  availability_zone = var.aws_az
#  size              = var.ebs_volume

#  tags = {
#    Name = "ust_volume_1"
#  }
#}

#Instance

resource "aws_instance" "ustInstance" {
  ami           = var.aws_ami
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  network_interface {
     network_interface_id = aws_network_interface.ani.id
     device_index = 0
  }
   tags = {
     Name = "Linux-VM"
  }
}

#ebs_block_size

#root_block_device {
#  volume_type = "gp2"
#  volume_size = 10
#  delete_on_termination = true
  
#  tags = {
#     Name = "vm-dev01"
#      }
#    }




