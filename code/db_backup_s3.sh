#!/bin/bash

# Variables
DB_HOST="your-rds-endpoint"
DB_USER="your-db-user"
DB_PASS="your-db-password"
DB_NAME="myapp"
TABLE_NAME="users"
S3_BUCKET="my-app-db-backups"
TIMESTAMP=$(date +%F-%H-%M)
OUTPUT="/tmp/${TABLE_NAME}-${TIMESTAMP}.csv"

# Export table to CSV
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e \
"SELECT * FROM $TABLE_NAME INTO OUTFILE '$OUTPUT'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"'
LINES TERMINATED BY '\n';" $DB_NAME

# Move file to EC2 since MySQL writes to its local file system (we simulate that)
# Use mysqldump instead if needed (see below)

# Upload to S3
aws s3 cp $OUTPUT s3://$S3_BUCKET/

# Clean up
rm -f $OUTPUT




#!/bin/bash

# Variables
DB_HOST="your-rds-endpoint"
DB_USER="your-db-user"
DB_PASS="your-db-password"
DB_NAME="myapp"
S3_BUCKET="my-app-db-backups"
TIMESTAMP=$(date +%F-%H-%M)
DUMP_FILE="/tmp/user_data_$TIMESTAMP.sql"

# Dump user data
mysqldump -h $DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME users > $DUMP_FILE

# Upload to S3
aws s3 cp $DUMP_FILE s3://$S3_BUCKET/

# Clean up
rm -f $DUMP_FILE



chmod +x /usr/local/bin/db_backup.sh

# Schedule backup every day at 2AM
echo "0 2 * * * root /usr/local/bin/db_backup.sh" >> /etc/crontab

aws s3 ls s3://my-app-db-backups/




sudo yum install -y awscli
aws --version
aws s3 ls


