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

module "github_oidc_terraform" {
  source = "./modules/github-oidc-terraform"

  github_org    = var.github_org
  github_repo   = var.github_repo
  github_branch = var.github_branch
  common_tags   = local.common_tags
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  env         = var.env
  common_tags = local.common_tags
}

module "security_groups" {
  source = "./modules/security-groups"

  project = var.project
  env     = var.env
  vpc_id  = module.vpc.vpc_id

  common_tags = local.common_tags
}

module "dns" {
  source = "./modules/dns"

  env         = var.env
  domain_name = var.domain_name
  common_tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project = var.project
  env     = var.env

  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc_config.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  acm_certificate_arn  = module.dns.certificate_arn

  common_tags = local.common_tags
}

module "ecs_iam_role" {
  source = "./modules/ecs-iam_role"

  project = var.project
  env     = var.env

  common_tags = local.common_tags
}

module "ecs_task_web" {
  source = "./modules/ecs-task-web"

  project = var.project
  env     = var.env

  aws_region         = var.region
  execution_role_arn = module.ecs_iam.execution_role_arn
  web_image          = "${module.ecr.repository_urls["openwebui"]}:latest"

  common_tags = local.common_tags
}

module "ecs_task_ollama" {
  source = "./modules/ecs-task-ollama"

  project = var.project
  env     = var.env

  aws_region         = var.region
  execution_role_arn = module.ecs_iam.execution_role_arn
  ollama_image       = "${module.ecr.repository_urls["ollama"]}:latest"

  common_tags = local.common_tags
}
