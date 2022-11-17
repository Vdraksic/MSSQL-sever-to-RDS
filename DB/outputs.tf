output "VPC_ID" {
  value = module.VPC.vpc_id

}

output "SUBNETS" {
  value = module.VPC.subnets_public[*]

}

output "Database_endpoint" {
  value = module.RDS.Instance_connstring

}