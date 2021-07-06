+++
title = "2.3 Infrastructure Configuration"
weight = 200
+++

Image Builder will use an EC2 instance to build your images. An infrastructure configuration defines the environment in which your image will be built and tested.

{{% notice tip %}}
Only required field is the `Name` and [`Instance Profile Name`](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html). The instance profile to associate with the instance used to build your Golden Image. For debugging purposes, you'll likely also want to configure `logging`.
{{% /notice %}}

Other configuration such as `securityGroupIds` and `subnetId` are optional.

```json
{
  "name": "MyExampleInfrastructure",
  "description": "An example that will retain instances of failed builds",
  "instanceTypes": [
    "m5.large", "m5.xlarge"
  ],
  "instanceProfileName": "myIAMInstanceProfileName",
  "securityGroupIds": [
    "sg-12345678"
  ],
  "subnetId": "sub-12345678",
  "logging": {
    "s3Logs": {
      "s3BucketName": "my-logging-bucket",
      "s3KeyPrefix": "my-path"
    }
  },
  "keyPair": "myKeyPairName",
  "terminateInstanceOnFailure": false,
  "snsTopicArn": "arn:aws:sns:us-west-2:123456789012:MyTopic"
}
```