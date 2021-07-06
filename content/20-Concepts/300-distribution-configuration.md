+++
title = "2.4 Distribution Configuration"
weight = 300
+++

A distribution configuration can be used to share an AMI. You distribute your image to selected AWS Regions and give `LaunchPermission` to AWS Accounts after it passes tests in the image pipeline.

{{% notice tip %}}
A Distribution Configuration **is optional**! It's mutable, and **NOT** versioned.
{{% /notice %}}
