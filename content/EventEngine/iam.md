## IAM Policy Statements

```json
[
  {
    "Sid": "TeamPolicy",
    "Effect": "Allow",
    "Action": ["iam:PassRole", "iam:GetInstanceProfile", "s3:getObject"],
    "Resource": "*"
  }
]
```

## IAM Managed Policy ARNs

```
arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
arn:aws:iam::aws:policy/AWSImageBuilderFullAccess
arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess
arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess
arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder
arn:aws:iam::aws:policy/AmazonEC2FullAccess
```

## IAM Trusted Services

```
ec2.amazonaws.com
```

## IAM Service Linked Roles

```
ssm.amazonaws.com
imagebuilder.amazonaws.com
```
