# Enable this if you want to save .tfvars to a bucket - terraform state colaboration

/* terraform {
  backend "s3" {
    bucket = "name"
    key    = "paht/to/tfvars"
    region = "region"
  }
} */

# Modify these values to change the DB parameters

module "RDS" {
  source                  = "./RDS"
  identifier              = "kortest" # name of the RDS instance
  port                    = 1433
  DB_username             = data.aws_ssm_parameter.RDS_username.value
  DB_password             = data.aws_ssm_parameter.RDS_password.value
  RDSallocatedstorage     = 20 # RDS total storage in GB ( 20 min )
  max_allocated_storage   = 50 # Dynamic storage maximum value in GB
  storage_type            = "gp2"
  engine_ver              = "15.00.4236.7.v1" # SQL srv version
  engine                  = "sqlserver-ex"    # SQL srv class ex = express
  instance_class          = "db.t3.small"
  backup_retention_period = 10            # how many days the backup will be kept
  backup_window           = "03:00-03:30" # when will the daily backup be made 
  option_group_ver        = "15.00"       # Only change on big versions - Option group used to enable restoring a database from an S3 bucket
  monitoring_interval     = 60            # Values in seconds (1,5,10,15,30,60) - Instance monitoring ( paid ), Performance insights logs are last 7 days ( free )
  subnet1                 = module.VPC.subnets_public[1]
  subnet2                 = module.VPC.subnets_public[2]
  security_group          = module.VPC.security_group
}

# These are the DB secrets, change the name value to target a diffrent AWS parameter store entry

data "aws_ssm_parameter" "RDS_username" {
  name            = "DB_username"
  with_decryption = "true"
}

data "aws_ssm_parameter" "RDS_password" {
  name            = "DB_password"
  with_decryption = "true"
}

/* This is used to automatically upload the databases in the specified path to a bucket via terraform

resource "aws_s3_object" "DBrestore" {
for_each = fileset("path/", "*")
bucket = "korrestorebucket"
key = each.value
source = "path/${each.value}"
etag = filemd5("path/${each.value}")
}
*/

module "VPC" {
  source     = "./VPC"
  port       = 1433 # Connections will be allowed on this port - put the same one as in the RDS
  cidr_block = "192.168.0.0/26"

}
