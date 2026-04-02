output "repository_urls" {
  description = "Repository URLs"
  value = {
    for key, repo in aws_ecr_repository.this :
    key => repo.repository_url
  }
}

output "repository_names" {
  description = "Repository names"
  value = {
    for key, repo in aws_ecr_repository.this :
    key => repo.name
  }
}