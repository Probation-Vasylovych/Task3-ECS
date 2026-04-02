module "vpc" {
    source = "./modules/vpc"
    common_tags = local.common_tags
}

module "vpc_config" {
  source = "./modules/vpc-config"

  vpc_id      = module.vpc.vpc_id
  env         = var.env
  common_tags = local.common_tags
  subnets     = var.subnets
}

module "ecr" {
  source = "./modules/ecr"

  repositories = local.ecr_repositories
  push_principal_arn = module.github_oidc_ecr.role_arn
  common_tags = local.common_tags
}

module "github_oidc_ecr" {
  source = "./modules/github-oidc-ecr"

  github_org          = var.github_org
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  aws_region          = var.region
  aws_account_id      = var.aws_account_id
  ecr_repository_names = local.ecr_repositories
  common_tags         = local.common_tags
}
