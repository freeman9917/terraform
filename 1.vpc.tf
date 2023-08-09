resource "aws_vpc" "my-tr-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "my-tr-vpc-public1" {
  vpc_id     = aws_vpc.my-tr-vpc.id
  cidr_block = var.pub1_subnet_cidr_block
  availability_zone = var.avail_zone1
  tags = {
    Name: "${var.env_prefix}-subnet-${var.avail_zone1}-public"
  }
  }

resource "aws_subnet" "my-tr-vpc-public2" {
  vpc_id     = aws_vpc.my-tr-vpc.id
  cidr_block = var.pub2_subnet_cidr_block
  availability_zone = var.avail_zone2
  tags = {
    Name: "${var.env_prefix}-subnet-${var.avail_zone2}-public"
  }
  }


resource "aws_route_table" "my-pub-rtable" {
    vpc_id = aws_vpc.my-tr-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
        Name: "${var.env_prefix}-pub-rtable"
    }
    
}

resource "aws_internet_gateway" "myapp-igw" {

    vpc_id = aws_vpc.my-tr-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
  }

resource "aws_route_table_association" "pub-rtable-association1" {
    subnet_id = aws_subnet.my-tr-vpc-public1.id
    route_table_id = aws_route_table.my-pub-rtable.id
}

resource "aws_route_table_association" "pub-rtable-association2" {
    subnet_id = aws_subnet.my-tr-vpc-public2.id
    route_table_id = aws_route_table.my-pub-rtable.id
}

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.my-tr-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name:"${var.env_prefix}-sg"
    }
}
