terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}
provider "aws" {
  region     = "ap-northeast-2"
  access_key =  var.access_key
  secret_key = var.secret_key
}
resource "aws_vpc" "myvpc" {
   cidr_block = "10.0.0.0/16"
   tags = {
     Name = "customvpc"
   }
  
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-igw"
  }
}
resource "aws_subnet" "websubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
availability_zone = "ap-northeast-2a"
  tags = {
    Name = "websubnet"
  }
}
resource "aws_subnet" "appsubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "appsubnet"
  }
}
resource "aws_subnet" "dbsubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2d"
  tags = {
    Name = "dbsubnet"
  }
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/24"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags =  {
        Name = "public_rt"
    }
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.myvpc.id
     tags =  {
        Name = "private_rt"
    }
}
resource "aws_route_table_association" "web-association" {
  subnet_id = aws_subnet.websubnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "app-association" {
  subnet_id = aws_subnet.appsubnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "db-association" {
  subnet_id = aws_subnet.dbsubnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_security_group" "web-sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.myvpc.id

  egress   {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"

}
 ingress {
  cidr_blocks         = ["0.0.0.0/0"]
  from_port           = 22
  protocol            = "tcp"
  to_port             = 22
}
 ingress {
  cidr_blocks         = ["0.0.0.0/0"]
  from_port           = 80
  protocol            = "tcp"
  to_port             = 80
}
}
resource "aws_security_group" "app-sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.myvpc.id
 ingress {
  cidr_blocks         = ["10.0.0.0/24"]
  from_port           = 22
  protocol            = "tcp"
  to_port             = 22
}
 ingress {
  cidr_blocks         = ["0.0.0.0/0"]
  from_port           = 9000
  protocol            = "tcp"
  to_port             = 9000
}
}
resource "aws_security_group" "db-sg" {
  name   = "db-sg"
  vpc_id = aws_vpc.myvpc.id

 ingress {
  cidr_blocks         = ["10.0.1.0/24"]
  from_port           = 22
  protocol            = "tcp"
  to_port             = 22
}
 ingress {
  cidr_blocks         = ["0.0.0.0/0"]
  from_port           = 3306
  protocol            = "tcp"
  to_port             = 3306
}
}
resource "aws_instance" "webec2" {
  subnet_id = aws_subnet.websubnet.id
  ami           = var.my_ami
  instance_type = var.ins_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    Name = "WebInstance"
  }

  key_name= "tf-key-pair"
}
resource "aws_instance" "appec2" {
  subnet_id = aws_subnet.appsubnet.id
  ami           = var.my_ami
  instance_type = var.ins_type
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  tags = {
    Name = "AppInstance"
  }
  key_name= "tf-key-pair"
}
resource "aws_db_instance" "db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Pass1234"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysubnetgp.name
}
resource "aws_db_subnet_group" "mysubnetgp" {
  name       = "mysubnetgp"
  subnet_ids = [aws_subnet.appsubnet.id, aws_subnet.dbsubnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}