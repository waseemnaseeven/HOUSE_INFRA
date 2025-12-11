module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "snak-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway     = false
  enable_vpn_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  map_public_ip_on_launch = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
}

module "sg_common" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "snak-sg"
  description = "HTTP/HTTPS ingress, all egress"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags = {
    Project     = "snak"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "ec2_edge" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.1"

  name                   = "snak-spot-edge"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.sg_common.security_group_id]

  # ARM64 AL2023 pour t4g.*
  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
  instance_type     = "t4g.large"

  # Spot simple et prévisible
  create_spot_instance      = true
  spot_type                 = "one-time"
  spot_wait_for_fulfillment = true

  # >>> Laisser le module créer le rôle + instance profile
  create_iam_instance_profile = true
  iam_role_name               = "snak-ec2-role"

  # EIP géré par le module
  create_eip = true

  # Disque OS
  root_block_device = {
    type                  = "gp3"
    size                  = 20
    delete_on_termination = true
  }

  # Disque data (Postgres, Grafana, Prometheus, ACME, etc.)
  ebs_volumes = {
    "/dev/sdb" = {
      type           = "gp3"
      size           = 200
      final_snapshot = false
      skip_destroy   = false
      tags = {
        Project     = "snak"
        Environment = var.environment
        Role        = "data"
      }
    }
  }

  metadata_options = { http_tokens = "required" }
  cpu_credits      = "standard"

  tags = {
    Project     = "snak"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

