# Required parameter store data ( u/p sensitive info )

data "aws_ssm_parameter" "RDS_username" {
  name            = "KOR_RDS_DB_username"
  with_decryption = "true"
}

data "aws_ssm_parameter" "RDS_password" {
  name            = "KOR_RDS_DB_pass"
  with_decryption = "true"
}