region         = "us-east-1"
vpc_name       = "LLM"
project        = "llm"
env            = "dev-01"
domain_name    = "birdswatching.pp.ua"
github_org     = "Probation-Vasylovych"
github_repo    = "Task3-ECS"
github_branch  = "main"
aws_account_id = "514632107726"
subnets = {

  public_a = {
    cidr_block        = "10.0.0.0/27"
    availability_zone = "us-east-1a"
    public            = true
    type              = "public"
  }

  public_b = {
    cidr_block        = "10.0.0.32/27"
    availability_zone = "us-east-1b"
    public            = true
    type              = "public"
  }

  private_fargate_a = {
    cidr_block        = "10.0.0.64/27"
    availability_zone = "us-east-1a"
    public            = false
    type              = "private-fargate"
  }

  private_fargate_b = {
    cidr_block        = "10.0.0.96/27"
    availability_zone = "us-east-1b"
    public            = false
    type              = "private-fargate"
  }

  private_rds_a = {
    cidr_block        = "10.0.0.128/27"
    availability_zone = "us-east-1a"
    public            = false
    type              = "private-rds"
  }

  private_rds_b = {
    cidr_block        = "10.0.0.160/27"
    availability_zone = "us-east-1b"
    public            = false
    type              = "private-rds"
  }

}
