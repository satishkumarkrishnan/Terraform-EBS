terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

module "cloudwatch" {
  source ="git@github.com:satishkumarkrishnan/Terraform-KMS.git?ref=main"  
}

#Resource  code for creating EBS volume
resource "aws_ebs_volume" "tokyo_ebs_volume" {
  availability_zone = var.region
  size              = 40
  
  tags = {
    Name = "Tokyo_EBS"
  }
}

resource "aws_ebs_default_kms_key" "tokyo_ebs_kms" {
  key_arn = module.cloudwatch.kms_arn      
  }

  resource "aws_ebs_snapshot" "tokyo_ebs_snapshot" {
  volume_id = aws_ebs_volume.tokyo_ebs_volume.id

  tags = {
    Name = "Tokyo_snapshot"
  }
}
