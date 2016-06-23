##### EC2

resource "aws_security_group" "sg-lynx" {
  name = "lynx"
  vpc_id = "${var.vpc}"
  description = "Lynx security group"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Lynx-security-group"
  }
}

resource "aws_instance" "lynx-ec2" {
  ami = "ami-f0c1ce9a"
  instance_type = "m3.medium"
  subnet_id = "${var.subnet_public_c}"
  iam_instance_profile = "Lynx"
  key_name = "launcher"
  ebs_optimized = false
  vpc_security_group_ids = ["${aws_security_group.sg-lynx.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "standard"
    volume_size = "8"
  }
  tags {
      Name = "Lynx-ec2"
      environment = "hackday"
  }
}

#### Dynamo DB

# key store
resource "aws_dynamodb_table" "lynx-kms-store" {
	name = "lynx-kms"
	read_capacity = 10
	write_capacity = 10
	hash_key = "id"
	attribute = {
		name = "id"
		type = "N"
	}
	/*attribute = {
		name = "user"
		type = "S"
	}
	attribute = {
		name = "password"
		type = "S"
	}
	attribute = {
		name = "keyid"
		type = "S"
	}*/
}

#### KMS
resource "aws_kms_key" "lynx" {
    description = "LYNX KMS Key"
    deletion_window_in_days = 10
}

resource "aws_kms_alias" "lynx" {
    name = "alias/LYNX"
    target_key_id = "${aws_kms_key.lynx.key_id}"
}
