Here’s the updated `README.md` file, which now includes details about setting up a cron job to schedule the script execution:

---

# AWS Resource Collector

## Description

The **AWS Resource Collector** is a shell script designed to automate the process of collecting data about AWS resources such as EC2 instances, S3 buckets, Lambda functions, and IAM users. It collects this information, stores it in separate files, compresses the data into a `.tar.gz` archive, and logs all actions for debugging and auditing purposes. This can be used to regularly gather resource information, backup configurations, or monitor changes in your AWS environment.

## Features

- **EC2 Instances**: Collects and saves the list of EC2 instances in your AWS account.
- **S3 Buckets**: Collects and saves the list of S3 buckets available in your account.
- **Lambda Functions**: Collects and saves the list of Lambda functions.
- **IAM Users**: Collects and saves the list of IAM users in your account.
- **Logging**: Keeps a detailed log of the resource collection process, including any errors.
- **Data Compression**: Compresses all collected data into a `.tar.gz` archive for easy storage or transfer.
- **Scheduling**: Can be scheduled to run at regular intervals (e.g., using cron jobs).

## Prerequisites

- **AWS CLI**: Ensure that the AWS CLI is installed and configured with the necessary permissions to describe EC2 instances, list S3 buckets, Lambda functions, and IAM users.
- **jq**: The script uses `jq` to process JSON output from the AWS CLI commands.
- **Linux/Unix Environment**: The script is designed to run on Linux or Unix-based systems (e.g., Ubuntu, Amazon Linux).

## Setup

1. **Clone the Repository**:

   First, clone the repository to your local machine or EC2 instance.

   ```bash
   git clone https://github.com/yourusername/aws-resource-collector.git
   cd aws-resource-collector
   ```

2. **Install Dependencies**:

   Ensure that you have the required dependencies installed on your system.

   - Install AWS CLI:
     ```bash
     sudo apt-get install awscli   # Ubuntu/Debian-based systems
     ```
     or follow the installation guide from the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   
   - Install jq:
     ```bash
     sudo apt-get install jq  # Ubuntu/Debian-based systems
     ```
     or from the [jq website](https://stedolan.github.io/jq/download/).

3. **Configure AWS CLI**:

   Ensure that the AWS CLI is configured with the necessary access and permissions for your AWS account.

   ```bash
   aws configure
   ```

   You'll need to provide your AWS Access Key, Secret Key, region, and output format.

4. **Make the Script Executable**:

   Change the permissions of the script to make it executable.

   ```bash
   chmod +x aws_resources.sh
   ```

## Usage

1. **Run the Script**:

   To manually run the script and collect AWS resource data:

   ```bash
   ./aws_resources.sh
   ```

   The script will generate resource data files (e.g., `ec2_instances_<timestamp>.txt`, `s3_buckets_<timestamp>.txt`, etc.), log the process to `aws_resource_log.txt`, and compress all data into a `.tar.gz` archive.

2. **Scheduled Execution (Cron Job)**:

   To automate the process, you can schedule the script to run at regular intervals using cron.

   - Open the crontab editor:

     ```bash
     crontab -e
     ```

   - Add a cron job to run the script every hour:

     ```bash
     0 * * * * /path/to/aws_resources.sh
     ```

     This will schedule the script to run on the hour, every hour. Replace `/path/to/aws_resources.sh` with the actual path to your script.

   - Save and exit the editor. The script will now run automatically every hour.

   - **Explanation**: The cron expression `0 * * * *` means:
     - `0`: Minute (run at minute 0)
     - `*`: Hour (every hour)
     - `*`: Day of the month (every day)
     - `*`: Month (every month)
     - `*`: Day of the week (every day of the week)

     You can adjust this schedule as needed. For example:
     - To run it every 30 minutes: `*/30 * * * *`
     - To run it at midnight every day: `0 0 * * *`

## Output Files

- **Log File**: `aws_resource_log.txt` - Logs the execution details, including resource data collection status and any errors encountered.
- **Resource Data Files**:
  - `ec2_instances_<timestamp>.txt` - Lists the EC2 instance IDs.
  - `s3_buckets_<timestamp>.txt` - Lists the S3 bucket names.
  - `lambda_functions_<timestamp>.txt` - Lists the Lambda function names.
  - `iam_users_<timestamp>.txt` - Lists the IAM usernames.
- **Compressed Archive**: `aws_data_<timestamp>.tar.gz` - A tarball containing all the resource data files, compressed for easy storage or transfer.

## Example Output in Log File

```
AWS Resource Data Collected at 2025-03-24_18-55-27
EC2 Instances found: i-0c5c8cd1c4799c55c
No S3 buckets available at 2025-03-24_18-55-27
No Lambda functions available at 2025-03-24_18-55-27
IAM Users found: Maharshi
```

## Troubleshooting

- **Permission Issues**: Make sure that the AWS CLI user has the necessary permissions to describe EC2 instances, list S3 buckets, list Lambda functions, and list IAM users.
- **Missing Dependencies**: Ensure that `jq` and AWS CLI are correctly installed and configured.
- **Cron Job Not Running**: Verify that the cron job is set up correctly and that the script path is correct.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### How to Customize

- **Region**: You can specify the AWS region for each AWS CLI command using the `--region` option (e.g., `aws ec2 describe-instances --region us-west-2`).
- **Additional Resources**: You can easily extend the script to collect other AWS resources by adding additional `aws` CLI commands and saving their output in similar `.txt` files.

---
