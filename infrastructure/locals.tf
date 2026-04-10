locals {
  project     = "llm"
  environment = "dev"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "terraform"
  }

  ecr_repositories = {
    openwebui  = "openwebui"
    ollama     = "ollama"
    prometheus = "prometheus"
    grafana    = "grafana"
    alloy      = "alloy"
  }

}