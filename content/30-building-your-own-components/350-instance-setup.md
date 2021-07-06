+++
title = "4.1 Setting up your EC2 instance."
weight = 350
+++

For the next section we are going to need:

1. Windows Server 2019 EC2 Instance with RDP access.
2. An IDE or text-editor such as Notepad++, SublimeText or VSCode (you choose).
3. Administrator access.
4. AWS CLI.

{{% notice tip %}}
If you are in an AWS hosted workshop, an EC2 instance will already be provisioned for you. You just have to reset the password!
{{% /notice %}}

## Optional: Change the Administrator password via EC2 Session Manager.

1. Navigate to the EC2 console {{% button href="https://console.aws.amazon.com/ec2/v2/" %}}EC2 Console{{% /button %}}
2. **Right Click the ec2 instance**, click **connect**.
3. Select '**Session Manager**'
4. Click **Connect**.
5. **Run** the following **command** (you can use your own password):

```PowerShell
net user administrator 'P@ssw0rd!'
```

6. Done, **you should now be able to RDP** to the instance.
