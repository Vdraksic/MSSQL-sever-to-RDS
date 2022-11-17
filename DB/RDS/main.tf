resource "aws_db_subnet_group" "subnetlist" {
  subnet_ids = [var.subnet1, var.subnet2]
}

resource "aws_db_instance" "RDSDB" {
  allocated_storage                     = var.RDSallocatedstorage
  db_name                               = ""
  engine                                = var.engine
  character_set_name                    = "SQL_Latin1_General_CP1_CI_AS" # For SQL express it cannot be set and must be changed after creation
  timezone                              = "Central European Standard Time"
  engine_version                        = var.engine_ver
  instance_class                        = var.instance_class
  username                              = var.DB_username
  password                              = var.DB_password
  identifier                            = var.identifier
  skip_final_snapshot                   = true
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  copy_tags_to_snapshot                 = true
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_interval                   = var.monitoring_interval
  iam_database_authentication_enabled   = "false"
  db_subnet_group_name                  = aws_db_subnet_group.subnetlist.id
  port                                  = var.port
  monitoring_role_arn                   = data.aws_iam_role.RDSmonitoringRole.arn
  storage_encrypted                     = "false"
  deletion_protection                   = "true"
  option_group_name                     = aws_db_option_group.RestoreBackup.name
  customer_owned_ip_enabled             = "false"
  performance_insights_enabled          = "true"
  performance_insights_retention_period = 7 # Free tier last 7 days of logs
  publicly_accessible                   = "true"
  storage_type                          = var.storage_type
  enabled_cloudwatch_logs_exports = [
    "error"
  ]
  tags = {

  }

  vpc_security_group_ids = [
    var.security_group
  ]

  timeouts {

  }
}




# This option group enables restoring the database from an s3 bucket backup

resource "aws_db_option_group" "RestoreBackup" {
  engine_name              = var.engine
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
      value = data.aws_iam_role.server-backup-and-restore.arn
    }
  }
  timeouts {}
}




