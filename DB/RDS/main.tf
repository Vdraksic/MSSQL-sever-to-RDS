resource "aws_db_instance" "RDSDB" {
  allocated_storage                   = var.RDSallocatedstorage
  db_name                             = ""
  engine                              = var.engine
  character_set_name                  = "SQL_Latin1_General_CP1_CI_AS"
  engine_version                      = var.engine_ver
  instance_class                      = var.instance_class
  username                            = data.aws_ssm_parameter.RDS_username.value
  password                            = data.aws_ssm_parameter.RDS_password.value
  identifier                          = var.identifier
  skip_final_snapshot                 = true
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = true
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = 60
  iam_database_authentication_enabled = "false"
  db_subnet_group_name                = "default-vpc-003b119704663ddd1"
  port                                = var.port
  monitoring_role_arn                 = "arn:aws:iam::200289518616:role/rds-monitoring-role"
  storage_encrypted                   = "false"
  deletion_protection                 = "false"
  customer_owned_ip_enabled           = "false"
  performance_insights_enabled        = "true"
  publicly_accessible                 = "true"
  storage_type                        = "gp2"
  iops                                = 0
  enabled_cloudwatch_logs_exports = [
    "error"
  ]
  tags = {

  }

  vpc_security_group_ids = [
    "sg-0095cfb4ac235f415",
    "sg-0e2c234b58fb1e095"
  ]

  timeouts {

  }
}




# This option group enables restoring the database from an s3 bucket backup

resource "aws_db_option_group" "RestoreBackup" {
  engine_name              = "sqlserver-ex"
  major_engine_version     = var.option_group_ver
  name                     = "sqlserverrestore"
  option_group_description = "SQLServerrestore"

  option {
    db_security_group_memberships  = []
    option_name                    = "SQLSERVER_BACKUP_RESTORE"
    port                           = 0
    vpc_security_group_memberships = []

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = "arn:aws:iam::200289518616:role/service-role/sql-server-backup-restore"
    }
  }
  timeouts {}
}



