terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

module "ebs" {
  source="git@github.com:satishkumarkrishnan/terraform-aws-asg.git?ref=main"  
}


#Resource  code for creating EBS volume
resource "aws_ebs_volume" "tokyo_ebs_volume" {
  availability_zone = "ap-northeast-1a"
  size              = 40
  
  tags = {
    Name = "Tokyo_EBS"
  }
}

resource "aws_ebs_default_kms_key" "tokyo_ebs_kms" {
  key_arn = module.cloudwatch.kms_arn      
  depends_on = [module.cloudwatch]
  }

  resource "aws_ebs_snapshot" "tokyo_ebs_snapshot" {
  volume_id = aws_ebs_volume.tokyo_ebs_volume.id

  tags = {
    Name = "Tokyo_snapshot"
  }
}

resource "aws_volume_attachment" "tokyo_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.tokyo_ebs_volume.id
  instance_id = aws_instance.web.id
}