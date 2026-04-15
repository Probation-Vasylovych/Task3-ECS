module "vpc" {
  source      = "./modules/vpc"
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

  repositories       = local.ecr_repositories
  push_principal_arn = module.github_oidc_ecr.role_arn
  common_tags        = local.common_tags
}

module "github_oidc_ecr" {
  source = "./modules/github-oidc-ecr"

  github_org           = var.github_org
  github_repo          = var.github_repo
  github_branch        = var.github_branch
  aws_region           = var.region
  aws_account_id       = var.aws_account_id
  ecr_repository_names = local.ecr_repositories
  common_tags          = local.common_tags
}

module "github_oidc_terraform" {
  source = "./modules/github-oidc-terraform"

  github_org               = var.github_org
  github_repo              = var.github_repo
  github_branch            = var.github_branch
  github_oidc_provider_arn = module.github_oidc_ecr.github_oidc_provider_arn
  common_tags              = local.common_tags
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

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc_config.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  acm_certificate_arn   = module.dns.certificate_arn
  domain_name           = var.domain_name
  common_tags           = local.common_tags
}

module "ecs_iam_role" {
  source = "./modules/ecs-iam-role"

  project = var.project
  env     = var.env

  openwebui_database_url_secret_arn = module.openwebui_database_url_secret.secret_arn

  common_tags = local.common_tags
}

module "ecs_task_web" {
  source = "./modules/ecs-task-web"

  project = var.project
  env     = var.env

  aws_region              = var.region
  execution_role_arn      = module.ecs_iam_role.execution_role_arn
  alloy_image             = "${module.ecr.repository_urls["alloy"]}:latest"
  web_image               = "${module.ecr.repository_urls["openwebui"]}:latest"
  database_url_secret_arn = module.openwebui_database_url_secret.secret_arn
  task_role_arn           = module.ecs_exec_iam.task_role_arn
  common_tags             = local.common_tags
}

module "ecs_task_ollama" {
  source = "./modules/ecs-task-ollama"

  project = var.project
  env     = var.env

  aws_region         = var.region
  execution_role_arn = module.ecs_iam_role.execution_role_arn
  ollama_image       = "${module.ecr.repository_urls["ollama"]}:latest"

  common_tags = local.common_tags
}

module "ecs_service_ollama" {
  source = "./modules/ecs-service-ollama"

  project = var.project
  env     = var.env

  cluster_arn                   = module.ecs_cluster.cluster_arn
  task_definition_arn           = module.ecs_task_ollama.task_definition_arn
  private_subnet_ids            = module.vpc_config.private_fargate_subnet_ids
  ollama_security_group_id      = module.security_groups.ollama_service_security_group_id
  service_discovery_service_arn = module.ollama_discovery_service.service_arn
  common_tags                   = local.common_tags
}

module "ecs_service_web" {
  source = "./modules/ecs-service-web"

  project = var.project
  env     = var.env

  cluster_arn                   = module.ecs_cluster.cluster_arn
  task_definition_arn           = module.ecs_task_web.task_definition_arn
  private_subnet_ids            = module.vpc_config.private_fargate_subnet_ids
  web_security_group_id         = module.security_groups.web_service_security_group_id
  web_target_group_arn          = module.alb.web_target_group_arn
  service_discovery_service_arn = module.web_discovery_service.service_arn
  common_tags                   = local.common_tags

  depends_on = [module.alb]
}

module "prometheus_task" {
  source = "./modules/ecs-task-prometheus"

  project = var.project
  env     = var.env

  aws_region = var.region

  execution_role_arn = module.ecs_iam_role.execution_role_arn
  prometheus_image   = "${module.ecr.repository_urls["prometheus"]}:latest"

  common_tags = local.common_tags
}

module "prometheus_service" {
  source = "./modules/ecs-service-prometheus"

  project = var.project
  env     = var.env

  cluster_arn                   = module.ecs_cluster.cluster_arn
  task_definition_arn           = module.prometheus_task.task_definition_arn
  target_group_arn              = module.alb.prometheus_target_group_arn
  private_subnet_ids            = module.vpc_config.private_fargate_subnet_ids
  security_group_id             = module.security_groups.prometheus_service_security_group_id
  service_discovery_service_arn = module.prometheus_discovery_service.service_arn
  common_tags                   = local.common_tags
}

module "grafana_task" {
  source = "./modules/ecs-task-grafana"

  project = var.project
  env     = var.env

  aws_region = var.region

  execution_role_arn = module.ecs_iam_role.execution_role_arn
  grafana_image      = "${module.ecr.repository_urls["grafana"]}:latest"

  common_tags = local.common_tags
}

module "grafana_service" {
  source = "./modules/ecs-service-grafana"

  project = var.project
  env     = var.env

  cluster_arn                   = module.ecs_cluster.cluster_arn
  task_definition_arn           = module.grafana_task.task_definition_arn
  target_group_arn              = module.alb.grafana_target_group_arn
  private_subnet_ids            = module.vpc_config.private_fargate_subnet_ids
  security_group_id             = module.security_groups.grafana_service_security_group_id
  service_discovery_service_arn = module.grafana_discovery_service.service_arn
  common_tags                   = local.common_tags
}

module "service_discovery_namespace" {
  source = "./modules/service-discovery-namespace"

  project = var.project
  env     = var.env

  namespace_name = "internal.local"
  vpc_id         = module.vpc.vpc_id

  common_tags = local.common_tags
}

module "web_discovery_service" {
  source = "./modules/service-discovery-service"

  project = var.project
  env     = var.env

  service_name = "openwebui"
  namespace_id = module.service_discovery_namespace.namespace_id

  common_tags = local.common_tags
}

module "ollama_discovery_service" {
  source = "./modules/service-discovery-service"

  project = var.project
  env     = var.env

  service_name = "ollama"
  namespace_id = module.service_discovery_namespace.namespace_id

  common_tags = local.common_tags
}

module "prometheus_discovery_service" {
  source = "./modules/service-discovery-service"

  project = var.project
  env     = var.env

  service_name = "prometheus"
  namespace_id = module.service_discovery_namespace.namespace_id

  common_tags = local.common_tags
}

module "grafana_discovery_service" {
  source = "./modules/service-discovery-service"

  project = var.project
  env     = var.env

  service_name = "grafana"
  namespace_id = module.service_discovery_namespace.namespace_id

  common_tags = local.common_tags
}

module "rds_postgres" {
  source = "./modules/rds"

  project = var.project
  env     = var.env

  private_rds_subnet_ids = module.vpc_config.private_rds_subnet_ids
  rds_security_group_id  = module.security_groups.rds_security_group_id

  db_name     = "openwebui"
  db_username = "openwebui"

  common_tags = local.common_tags
}

module "openwebui_database_url_secret" {
  source = "./modules/openwebui-database-url-secret"

  project = var.project
  env     = var.env

  rds_master_secret_arn = module.rds_postgres.master_user_secret_arn
  db_host               = module.rds_postgres.db_instance_endpoint
  db_port               = module.rds_postgres.db_instance_port
  db_name               = module.rds_postgres.db_name

  common_tags = local.common_tags
}

module "ecs_exec_iam" {
  source = "./modules/ecs-exec-iam"

  project     = var.project
  env         = var.env
  common_tags = local.common_tags
}