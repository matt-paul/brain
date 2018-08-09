provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "brain-api" {
  ami           = "ami-52d12435"
  instance_type = "t2.micro"
}

terraform {
  backend "s3" {
    bucket = "tf-brain-state"
    key = "brain-app-state"
    region = "eu-west-2"
  }
}