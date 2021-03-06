################################################################
# Provider Configuration
################################################################

provider "aws"  {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

################################################################
# vpc variable declaration
################################################################

variable "vpc" {
        type = map
        default = {
        "name1" = "vpc_blue"
	"name2" = "vpc_green"
        "cidr1" = "10.0.0.0/16"
	"cidr2" = "172.20.0.0/16"
        }
}

################################################################
# vpc1 creation
################################################################

resource "aws_vpc" "vpc1" {
  cidr_block       = var.vpc.cidr1
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc.name1
  }
}

################################################################
# vpc2 creation
################################################################


resource "aws_vpc" "vpc2" {
  cidr_block       = var.vpc.cidr2
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc.name2
  }
}

################################################################
# subnet variable declaration
################################################################

variable "subnet" {
        type = map
        default = {
        "name1" = "blue-public1"
	"name2" = "blue-public2"
	"name3" = "green-public1"
	"name4" = "green-public2"
	"name5" = "blue-private1"
       	"name6" = "blue-private2"
	"name7" = "green-private1"
       	"name8" = "green-private2"
        "cidr1" = "10.0.0.0/18"
	"cidr2" = "10.0.64.0/18"
	"cidr3" = "172.20.0.0/18"
	"cidr4" = "172.20.64.0/18"
	"cidr5" = "10.0.128.0/18"
	"cidr6" = "10.0.192.0/18"
	"cidr7" = "172.20.128.0/18"
	"cidr8" = "172.20.192.0/18"
        "zone1" = "us-east-2a"
	"zone2" = "us-east-2b"
	"zone3" = "us-east-2c"
	}
}


################################################################
# blue public subnet - 1 and 2  creation
################################################################

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet.cidr1
  availability_zone = var.subnet.zone1
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet.name1
  }
}


resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet.cidr2
  availability_zone = var.subnet.zone2
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet.name2
  }
}


################################################################
# green public subnet - 1 and 2  creation
################################################################


resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.subnet.cidr3
  availability_zone = var.subnet.zone2
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet.name3
  }
}


resource "aws_subnet" "public4" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.subnet.cidr4
  availability_zone = var.subnet.zone3
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet.name4
  }
}

################################################################
# blue private subnet - 1 and 2  creation
################################################################


resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet.cidr5
  availability_zone = var.subnet.zone3
  tags = {
    Name = var.subnet.name5
  }
}



resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet.cidr6
  availability_zone = var.subnet.zone1
  tags = {
    Name = var.subnet.name6
  }
}


################################################################
# green private subnet - 1 and 2  creation
################################################################


resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.subnet.cidr7
  availability_zone = var.subnet.zone1
  tags = {
    Name = var.subnet.name7
  }
}


resource "aws_subnet" "private4" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.subnet.cidr8
  availability_zone = var.subnet.zone2
  tags = {
    Name = var.subnet.name8
  }
}


################################################################
#blue internet gateway  creation
################################################################

variable "igw" {
	type = map
	default = {
	"name1" = "blue-igw"
	"name2" = "green-igw"
}
}

################################################################
#blue internet gateway  creation
################################################################

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = var.igw.name1
        }
}

################################################################
#green internet gateway  creation
################################################################


resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = var.igw.name2
        }
}


################################################################
# route table variable declaration
################################################################

variable "RT" {
        type = map
        default = {
        "cidr" = "0.0.0.0/0"
        "name1" = "blue-public-RT"
	"name2" = "green-public-RT"
        }
}


################################################################
#blue public route table  creation
################################################################

resource "aws_route_table" "publicRT1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = var.RT.cidr
    gateway_id = aws_internet_gateway.igw1.id
        }
   tags = {
        Name = var.RT.name1
        }
}


################################################################
#green public route table  creation
################################################################


resource "aws_route_table" "publicRT2" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = var.RT.cidr
    gateway_id = aws_internet_gateway.igw2.id
        }
   tags = {
        Name = var.RT.name2
        }
}


################################################################
#blue public 1 & 2  route table  association
################################################################

resource "aws_route_table_association" "blueRT" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.publicRT1.id
}

resource "aws_route_table_association" "blueRT2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.publicRT1.id
}

################################################################
#green public 1 & 2  route table  association
################################################################

resource "aws_route_table_association" "greenRT" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.publicRT2.id
}

resource "aws_route_table_association" "greenRT2" {
  subnet_id      = aws_subnet.public4.id
  route_table_id = aws_route_table.publicRT2.id
}

################################################################
# eip variable declaration
################################################################

variable "nat_name" {
	type = map 
        default = {
	"name1" = "blue-eip"
	"name2" = "green-eip"
}
}

################################################################
#blue eip creation
################################################################

resource "aws_eip" "nat" {
  vpc      = true
  tags = {
    Name = var.nat_name.name1
  }
}


################################################################
#green eip creation
################################################################

resource "aws_eip" "nat2" {
  vpc      = true
  tags = {
    Name = var.nat_name.name2
  }
}

################################################################
#blue nat gateway creation
################################################################

variable "nat_gw1" {
        default = "blue-NAT"
}

resource "aws_nat_gateway" "blue-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = var.nat_gw1
  }
}

################################################################
#green nat gateway creation
################################################################

variable "nat_gw2" {
        default = "green-NAT"
}

resource "aws_nat_gateway" "green-nat" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public4.id

  tags = {
    Name = var.nat_gw1
  }
}

################################################################
#blue private route table  creation
################################################################

variable "RT2" {
	type = map
        default = {
	"name1"  = "blue-private-RT"
	"name2"  = "green-private-RT"
}
}

resource "aws_route_table" "privateRT1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = var.RT.cidr
    nat_gateway_id = aws_nat_gateway.blue-nat.id
  }

  tags = {
    Name = var.RT2.name1
         }
}

################################################################
#green private route table  creation
################################################################

variable "privateRT2" {
        default = "green-private-RT"
}

resource "aws_route_table" "privateRT2" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = var.RT.cidr
    nat_gateway_id = aws_nat_gateway.green-nat.id
  }

  tags = {
    Name = var.RT2.name2
         }
}

###############################################################
#private subnet 1 to route table  association
################################################################

resource "aws_route_table_association" "private1-RT1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privateRT1.id
}


resource "aws_route_table_association" "private2-RT1" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.privateRT1.id
}

###############################################################
#green subnet 1 to route table  association
################################################################

resource "aws_route_table_association" "private3-RT1" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.privateRT2.id
}


resource "aws_route_table_association" "private4-RT1" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.privateRT2.id
}

################################################################
#security group for blue
################################################################

variable "sg1" {
        default = "blue-sg"
}


resource "aws_security_group" "sg1" {
  name        = var.sg1
  description = "Allow from all"
  vpc_id      = aws_vpc.vpc1.id


ingress {
    description = "allow from all"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.RT.cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.RT.cidr]
  }

  tags = {
    Name = var.sg1
  }
}

################################################################
#security group for green
################################################################

variable "sg2" {
        default = "green-sg"
}


resource "aws_security_group" "sg2" {
  name        = var.sg2
  description = "Allow from all"
  vpc_id      = aws_vpc.vpc2.id


ingress {
    description = "allow from all"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.RT.cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.RT.cidr]
  }

  tags = {
    Name = var.sg2
  }
}

################################################################
#keypair
################################################################

variable "key" {
}

resource "aws_key_pair" "key" {
  key_name   = "ohio-server"
  public_key = var.key
}


#################################################################
# LC variable declaration
##################################################################

variable "lc" {
        type = map
        default = {
        image = "ami-09558250a3419e7d0"
        type = "t2.micro"

}
}

#################################################################
# Blue Launch Configuration
##################################################################

resource "aws_launch_configuration" "lc1" {

  image_id = var.lc.image
  instance_type = var.lc.type
  key_name = aws_key_pair.key.id
  security_groups = [ aws_security_group.sg1.id ]
  user_data = file("setup.sh")

  lifecycle {
    create_before_destroy = true
  }

}

#################################################################
# Green Launch Configuration
##################################################################


resource "aws_launch_configuration" "lc2" {

  image_id = var.lc.image
  instance_type = var.lc.type
  key_name = aws_key_pair.key.id
  security_groups = [ aws_security_group.sg2.id ]
  user_data = file("setup.sh")

  lifecycle {
    create_before_destroy = true
  }

}

##################################################################
# Blue Load balancer
##################################################################

variable "lb1" {
        type = map
        default = {
        "port" = "80"
        "protocol" = "http"
        "name" = "blue-lb"
}
}

resource "aws_elb" "lb1" {
  name               = var.lb1.name
  security_groups = [aws_security_group.sg1.id]
  listener {
    instance_port     = var.lb1.port
    instance_protocol = var.lb1.protocol
    lb_port           = var.lb1.port
    lb_protocol       = var.lb1.protocol
  }

 subnets = [aws_subnet.public1.id, aws_subnet.public2.id]

  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.php"
    interval            = 15
  }
   tags = {
    Name = var.lb1.name
  }
}

##################################################################
# Green Load balancer
##################################################################

variable "lb2" {
        default = "green-lb"
}

resource "aws_elb" "lb2" {
  name               = var.lb2
  security_groups = [aws_security_group.sg2.id]
  listener {
    instance_port     = var.lb1.port
    instance_protocol = var.lb1.protocol
    lb_port           = var.lb1.port
    lb_protocol       = var.lb1.protocol
  }

 subnets = [aws_subnet.public3.id, aws_subnet.public4.id]

  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.php"
    interval            = 15
  }
   tags = {
    Name = var.lb2
  }
}

##################################################################
# Autoscaling
##################################################################

variable "asg" {
        type = map
        default = {
        "name" = "blue-ASG"
        "min"     = "2"
        "desired" = "2"
        "max"     = "3"
        "period"  = "120"
        "type"    = "EC2"
        "value1"   = "blue-webserver"
        "value2"   = "green-webserver"
        "name2"   = "Green-ASG"
}
}


  resource "aws_autoscaling_group" "asg1" {
  name                 = var.asg.name
  launch_configuration = aws_launch_configuration.lc1.name
  min_size             = var.asg.min
  desired_capacity     = var.asg.desired
  max_size             = var.asg.max
  health_check_grace_period = var.asg.period
  health_check_type         = var.asg.type
  load_balancers        = [aws_elb.lb1.id]
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id]
  tag {
    key = "Name"
    propagate_at_launch = true
    value = var.asg.value1
  }
  lifecycle {
   create_before_destroy = true
  }
}

##################################################################
# Autoscaling - Green
##################################################################


 resource "aws_autoscaling_group" "asg2" {
  name                 = var.asg.name2
  launch_configuration = aws_launch_configuration.lc2.name
  min_size             = var.asg.min
  desired_capacity     = var.asg.desired
  max_size             = var.asg.max
  health_check_grace_period = var.asg.period
  health_check_type         = var.asg.type
  load_balancers        = [aws_elb.lb2.id]
  vpc_zone_identifier = [aws_subnet.public3.id, aws_subnet.public4.id]
  tag {
    key = "Name"
    propagate_at_launch = true
    value = var.asg.value2
  }
  lifecycle {
   create_before_destroy = true
  }
}


##################################################################
# Route 53
##################################################################

resource "aws_route53_zone" "website1" {
  name = "shanimakthahir.xyz"
}

##################################################################
# zone variables
##################################################################

variable "zone" {
        type = map
        default = {
        "name"    = "www"
        "type"    = "CNAME"
        "ttl"     = "10"
        "weight1" = "100"
        "weight2" = "0"
        "identifier" = "www."
        "type" = "CNAME"
        }
}

##################################################################
# zone record for blue
##################################################################

resource "aws_route53_record" "www1" {
  zone_id = aws_route53_zone.website1.zone_id
  name    = var.zone.name
  type    = var.zone.type
  ttl     = var.zone.ttl

  weighted_routing_policy {
    weight = var.zone.weight1
  }

  set_identifier = "www."
  records        = [aws_elb.lb1.dns_name]
}

##################################################################
# zone record for green
##################################################################

resource "aws_route53_record" "www2" {
  zone_id = aws_route53_zone.website1.zone_id
  name    = var.zone.name
  type    = var.zone.type
  ttl     = var.zone.ttl

  weighted_routing_policy {
    weight = var.zone.weight2
  }

  set_identifier = "www2"
  records        = [aws_elb.lb2.dns_name]
}


