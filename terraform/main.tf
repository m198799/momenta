provider "aws" {
  region = "us-west-2"
  access_key = "xxxxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

data "template_file" "jenkins" {
  template = "${file("jenkins-data.tpl")}"
}

module "Jenkins" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "1.21.0"
  name                   = "Jenkins"
  instance_count         = 1
  ami                    = "ami-06d51e91cea0dac8d"
  associate_public_ip_address = true
  instance_type          = "c5.large"
  key_name               = "m"
  monitoring             = false
  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
  subnet_id              = "subnet-833345c8"
  user_data = "${data.template_file.jenkins.rendered}"
  root_block_device = [{
    volume_type = "gp2"
    volume_size = 20
  }]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

  #lifecycle {
  #  prevent_destroy = true
  #  ignore_changes = ["aws_instance"]
  #}


}

resource "aws_security_group" "jenkins" {
  name        = "Jenkins"
  description = "jenkins CI"
  vpc_id = "vpc-5d9a6225"
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "this" {
  count		= 1
  vpc      = true
  instance = "${module.Jenkins.id[count.index]}"
  
  tags = {
    Name = "Jenkins-${count.index}" 
  }
}

resource "aws_volume_attachment" "this_ec2" {
  count = 1

  device_name = "/dev/sdf"
  volume_id   = "${aws_ebs_volume.this.*.id[count.index]}"
  instance_id = "${module.Jenkins.id[count.index]}"
}

resource "aws_ebs_volume" "this" {
  count = 1

  availability_zone = "${module.Jenkins.availability_zone[count.index]}"
  size              = 10
}


data "template_file" "umsl_data" {
  template = "${file("umsl-data.tpl")}"
}

module "umsl" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "1.21.0"
  name                   = "umsl"
  instance_count         = 1
  ami                    = "ami-06d51e91cea0dac8d"
  associate_public_ip_address = true
  instance_type          = "t2.micro"
  key_name               = "m"
  monitoring             = false
  vpc_security_group_ids = ["${aws_security_group.umsl.id}"]
  subnet_id              = "subnet-833345c8"
  user_data = "${data.template_file.umsl_data.rendered}"
  root_block_device = [{
    volume_type = "gp2"
    volume_size = 20
  }]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "umsl" {
  name        = "umsl"
  description = "umsl node"
  vpc_id = "vpc-5d9a6225"
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # UMSL HTTP access from anywhere
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "usml" {
  count		= 1
  vpc      = true
  instance = "${module.umsl.id[count.index]}"

  tags = {
    Name = "umsl-${count.index}"
  }
}
