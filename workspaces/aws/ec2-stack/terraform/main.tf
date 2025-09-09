locals {
  tags = merge(
    var.default_tags,
    {
      Environment = var.environment
    }
  )
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidr_a     = var.public_subnet_cidr_a
  public_subnet_cidr_b     = var.public_subnet_cidr_b
  private_subnet_cidr_a    = var.private_subnet_cidr_a
  private_subnet_cidr_b    = var.private_subnet_cidr_b
  aws_region               = var.aws_region
  allowed_ssh_bastion_cidr = var.allowed_ssh_bastion_cidr
  environment              = var.environment
  tags                     = local.tags
}

module "ec2" {
  depends_on = [module.vpc]

  source = "./modules/ec2"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.ec2_security_group_id, module.vpc.web_ssh_security_group_id]
  instance_name      = "web-server"
  environment        = var.environment
  tags               = local.tags
  key_name           = module.bastion.key_name
}

module "alb" {
  depends_on = [module.vpc, module.ec2]

  source = "./modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
  instance_ids          = module.ec2.instance_ids
  environment           = var.environment
  tags                  = local.tags
}

module "bastion" {
  depends_on = [module.vpc]

  source = "./modules/bastion"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.vpc.bastion_security_group_id]
  instance_name      = "bastion-host"
  environment        = var.environment
  tags               = local.tags
}
