resource "aws_iam_role" "rds-monitoring-role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })


}

resource "aws_iam_role" "sql-server-backup-restore" {
  name = "sql-server-backup-restore"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })


}

resource "aws_iam_policy" "rds-monitoring-role-policy" {
  name        = "AmazonRDSEnhancedMonitoringRole"
  description = "Provides access to Cloudwatch for RDS Enhanced Monitoring"
  path        = "/service-role/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "EnableCreationAndManagementOfRDSCloudwatchLogGroups"
        Action = [
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:log-group:RDS*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:log-group:RDS*:log-stream:*",
        ]
        Sid = "EnableCreationAndManagementOfRDSCloudwatchLogStreams"
      },
    ]
  })
}

resource "aws_iam_policy" "sql-server-backup-restore-policy" {
  name        = "sqlNativeBackup-2022-11-14-13.57.35.025"
  path        = "/service-role/"
  description = "RDS SQL Server Native Backup Without Encryption"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",

        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::KorRestoreBucket",
        ]

      },
      {
        Action = [
          "s3:GetObjectMetaData",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::KorRestoreBucket/*",
        ]
      },
    ]
  })
}

# Attaching the RDS monitoring policy to the role

resource "aws_iam_role_policy_attachment" "RDS-monitoring-attach" {
  role       = aws_iam_role.rds-monitoring-role.name
  policy_arn = aws_iam_policy.rds-monitoring-role-policy.arn
}

# Attaching the SQL server backup policy to the role

resource "aws_iam_role_policy_attachment" "RDS-restore-attach" {
  role       = aws_iam_role.sql-server-backup-restore.name
  policy_arn = aws_iam_policy.sql-server-backup-restore-policy.arn
}
