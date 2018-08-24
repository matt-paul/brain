# Define a vpc
resource "aws_vpc" "brainVPC" {
  cidr_block = "200.0.0.0/16"
  tags {
    Name = "ecsBrainVPC"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "brainIG" {
  vpc_id = "${aws_vpc.brainVPC.id}"
  tags {
    Name = "ecsBrainIG"
  }
}

#Public subnet
resource "aws_subnet" "brainPubSN0-0" {
  vpc_id = "${aws_vpc.brainVPC.id}"
  cidr_block = "200.0.0.0/24"
  availability_zone = "eu-west-2a"
  tags {
    Name = "ecsBrainPubSN0-0-0"
  }
}

# Routing table for the Public Subnet
resource "aws_route_table" "brainPubSN0-0RT" {
  vpc_id = "${aws_vpc.brainVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.brainIG.id}"
  }
  tags {
    Name = "brainPubSN0-0RT"
  }
}

#Associate the routing table to public subnet
resource "aws_route_table_association" "brainPubSN0-0RTAssn" {
  subnet_id = "${aws_subnet.brainPubSN0-0.id}"
  route_table_id = "${aws_route_table.brainPubSN0-0RT.id}"
}

# ECS Instance Security group

resource "aws_security_group" "test_public_sg" {
    name = "test_public_sg"
    description = "Test public access security group"
    vpc_id = "${aws_vpc.brainVPC.id}"

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

  #  ingress {
  #     from_port = 0
  #     to_port = 0
  #     protocol = "tcp"
  #     cidr_blocks = [
  #        "${var.test_public_01_cidr}",
  #        "${var.test_public_02_cidr}"]
  #   }

    egress {
        # allow all traffic to private SN
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }

    tags { 
       Name = "test_public_sg"
     }
}