#!/bin/bash

# Set output directory and timestamp
OUTPUT_DIR="/home/ubuntu/aws_resource_data"
mkdir -p $OUTPUT_DIR  # Ensure directory exists
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Initialize log file
LOG_FILE="$OUTPUT_DIR/aws_resource_log.txt"
echo "AWS Resource Data Collected at $TIMESTAMP" > $LOG_FILE

# EC2 Instances
EC2_INSTANCES=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text)
if [ $? -ne 0 ]; then
    echo "Error occurred while fetching EC2 instances" >> $LOG_FILE
else
    if [ -z "$EC2_INSTANCES" ]; then
        echo "No EC2 instances found at $TIMESTAMP" >> $LOG_FILE
    else
        echo "EC2 Instances found: $EC2_INSTANCES" >> $LOG_FILE
        echo "$EC2_INSTANCES" > "$OUTPUT_DIR/ec2_instances_$TIMESTAMP.txt"
    fi
fi

# S3 Buckets
S3_BUCKETS=$(aws s3api list-buckets --query 'Buckets[].Name' --output text)
if [ $? -ne 0 ]; then
    echo "Error occurred while fetching S3 buckets" >> $LOG_FILE
else
    if [ -z "$S3_BUCKETS" ]; then
        echo "No S3 buckets available at $TIMESTAMP" >> $LOG_FILE
    else
        echo "S3 Buckets found: $S3_BUCKETS" >> $LOG_FILE
        echo "$S3_BUCKETS" > "$OUTPUT_DIR/s3_buckets_$TIMESTAMP.txt"
    fi
fi

# Lambda Functions
LAMBDA_FUNCTIONS=$(aws lambda list-functions --query 'Functions[].FunctionName' --output text)
if [ $? -ne 0 ]; then
    echo "Error occurred while fetching Lambda functions" >> $LOG_FILE
else
    if [ -z "$LAMBDA_FUNCTIONS" ]; then
        echo "No Lambda functions available at $TIMESTAMP" >> $LOG_FILE
    else
        echo "Lambda Functions found: $LAMBDA_FUNCTIONS" >> $LOG_FILE
        echo "$LAMBDA_FUNCTIONS" > "$OUTPUT_DIR/lambda_functions_$TIMESTAMP.txt"
    fi
fi

# IAM Users
IAM_USERS=$(aws iam list-users --query 'Users[].UserName' --output text)
if [ $? -ne 0 ]; then
    echo "Error occurred while fetching IAM users" >> $LOG_FILE
else
    if [ -z "$IAM_USERS" ]; then
        echo "No IAM users found at $TIMESTAMP" >> $LOG_FILE
    else
        echo "IAM Users found: $IAM_USERS" >> $LOG_FILE
        echo "$IAM_USERS" > "$OUTPUT_DIR/iam_users_$TIMESTAMP.txt"
    fi
fi

# Debug: List files before compression
echo "Files to be compressed: $(ls $OUTPUT_DIR/*.txt)" >> $LOG_FILE

# Compress files
echo "Starting compression at $TIMESTAMP" >> $LOG_FILE
tar -czf "$OUTPUT_DIR/aws_data_$TIMESTAMP.tar.gz" "$OUTPUT_DIR"/*.txt

# Check if the compression succeeded
if [ $? -ne 0 ]; then
    echo "Error occurred during compression" >> $LOG_FILE
else
    echo "Compression successful" >> $LOG_FILE
fi

# Final log entry
echo "AWS Resource Data collected and compressed at $TIMESTAMP" >> $LOG_FILE
