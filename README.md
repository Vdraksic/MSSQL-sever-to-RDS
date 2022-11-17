# This is a terraform file that creates a VPC, RDS and S3 bucket on AWS for testing KOR databases


## The project is seperated into two parts: DB and global

The separation is used so terrafrom has a persistent part: 

* Global:
* S3 bucket
* IAM roles and policies

And so we can freely destroy/reuse the variable part:

* DB:
* RDS module 
* SSM parameters
* VPC module 
* Security groups

The parameters of the VPC/RDS are configured in ./DB/main.tf, then the VPC and RDS instance can be created with terraform plan/apply

## Connstring

Terrafom apply will output the RDS endpoint ( Connect with SSMS )

## DB setup/restore

The RDS instance restores databases from backups uploaded to the S3 bucket, either manually or with terrafrom apply:
( resource "aws_s3_object" "DBrestore" in ./DB/main.tf )

Once the RDS instance is up, and the backups are in the bucket, restore with:

    exec msdb.dbo.rds_restore_database
    @restore_db_name='name',
    @s3_arn_to_restore_from='arn:aws:s3:::bucketname/name.bak';

This will display the task_id in results and you can check the progress with:

    exec msdb.dbo.rds_task_status @task_id=id;

## Limitations

Currently AWS does not allow you to change default server collation if the SQL Server version is Express.

## Bugs

If the restore job returns an error: Database backup/restore option is not enabled yet or is in the process of being enabled.
On AWS in the RDS dashboard go to option groups -> sqlserverrestore -> modify option -> apply immediately


