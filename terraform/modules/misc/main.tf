variable "secret_json" {
  default = {
    "aws_access_key": "aa"
    "aws_secret_key": "bb"
  }
  type = map(string)
}

resource "aws_secretsmanager_secret" "tf_secrets_store" {
  name = "terraform-secrets-store"
}

resource "aws_secretsmanager_secret_version" "tf-secrets" {
  secret_id = aws_secretsmanager_secret.tf_secrets_store.id
  secret_string = jsonencode({
    "aws_access_key": var.aws_access_key
    "aws_secret_key": var.aws_secret_key
  })
}