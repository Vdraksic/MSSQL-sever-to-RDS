# Enable this if you want to save .tfvars to a bucket

/* terraform {
  backend "s3" {
    bucket = "name"
    key    = "paht/to/tfvars"
    region = "region"
  }
} */


module "RDS" {
  source                  = "./RDS"
  identifier              = "kortest" # name of the database
  port                    = 1433
  RDSallocatedstorage     = 20                # RDS total storage in GB
  engine_ver              = "15.00.4236.7.v1" # SQL srv version
  engine                  = "sqlserver-ex"    # SQL srv class ex = express
  instance_class          = "db.t3.small"
  backup_retention_period = 10            # how many days the backup will be kept
  backup_window           = "03:00-03:30" # when will the daily backup be made
  max_allocated_storage   = 50            # Dynamic storage maximum value in GB
  option_group_ver        = "15.00"       # Only change on big versions - Option group used to enable restoring a database from an S3 bucket


}