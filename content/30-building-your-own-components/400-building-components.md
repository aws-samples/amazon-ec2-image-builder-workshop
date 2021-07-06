+++
title = "4.2 The ExecutePowerShell action."
weight = 400
+++

The component management (**awstoe**) application is a **standalone application that EC2 Image Builder uses to execute Image Builder components** during the image build workflow. **You can use this application to develop new component definitions or to troubleshoot existing component definitions by running them locally**.

Image Builder Components are written in YAML and consist of Phases, which in turn consist of one or more steps.

{{% notice tip %}}
For the next section we are going to need a Windows Server 2019 EC2 Instance. If you are in an AWS hosted workshop, an EC2 instance will already be provisioned for you.
{{% /notice %}}

## Building your first 'ExecutePowerShell' component.

We are going to create document that uses the `ExecutePowerShell` action module to write 'HelloWorld' to the output. Next we will list the contents of `c:\missingFolder` to show how error handling works.

**To do this:**

1. Navigate to your `$home\Documents\` folder.
2. Create a new folder called `ibworkshop`
3. Enter this folder and download `awstoe` from [this page](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager.html).
4. Print the version of `awstoe.exe`
5. In the same folder, create a new file called `my-first-doc.yml`.
6. Populate it with the following content:

```yaml
name: Hello World
description: This is hello world testing document for Windows.
schemaVersion: 1.0
phases:
  - name: build
    steps:
      - name: HelloWorldStep
        action: ExecutePowerShell
        inputs:
          commands:
            - Write-Host 'Hello World from the build phase.'
            - Get-ChildItem 'c:\missingFolder'
```

**Solution:**
{{%expand "Click me to show solution." %}}

Use the below command in a PowerShell prompt.

```Powershell
cd $home\Documents\
mkdir ibworkshop
cd .\ibworkshop\
Invoke-WebRequest 'https://awstoe-us-east-1.s3.us-east-1.amazonaws.com/latest/windows/amd64/awstoe.exe' -OutFile awstoe.exe
./awstoe.exe -v
new-item my-first-doc.yml -Type File
notepad my-first-doc.yml
#Copy paste the yaml above
```

{{% /expand%}}

## Validate Image Builder component

Now we will use [awstoe](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager-local.html) to validate and execute the document.

7. Let's first **validate the document** we've just created.

```powershell
& .\awstoe.exe validate -d .\my-first-doc.yml
```

This should **confirm that our document is valid** and will show:

```json
{
  "validationStatus": "success",
  "message": "Document(s) [.\\my-first-doc.yml] is/are valid."
}
```

## Execute Image Builder component

Now that we've confirmed the document is valid, let's continue executing it locally.

8. We can **execute the document** by running `./awstoe.exe run -d .\my-first-doc.yml`

{{% notice warning %}}
If you get an `"failureMessage": "Access is denied."` response, restart your PowerShell prompt as administrator.
{{% /notice %}}

**This will show the following output:**

```json
{
  "executionId": "f707fdba-d324-11ea-9775-0a43324a43da",
  "status": "success",
  "failedStepCount": 0,
  "executedStepCount": 1,
  "failureMessage": "",
  "logUrl": "C:\\Users\\admin\\Documents\\ibworkshop\\TOE_2020-07-31_11-57-10_UTC-0_f707fdba-d324-11ea-9775-0a43324a43da"
}
```

9. Now **open the log** file `console.log`, you will find it in the `logUrl` folder from the output above.

**In the logs we see the following:**

```log
2020-07-31 11:57:10.575 Info Document .\my-first-doc.yml
2020-07-31 11:57:10.576 Info Phase build
2020-07-31 11:57:10.577 Info Step HelloWorldStep
2020-07-31 11:57:10.848 Info Stdout: Hello World from the build phase.
2020-07-31 11:57:11.014 Info Command execution completed successfully
2020-07-31 11:57:11.014 Info Stderr: ls : Cannot find path 'C:\missingFolder' because it does not exist.
At C:\Users\admin\AppData\Local\Temp\AWSTOE396346255\script-186539938.ps1:2 char:1
+ ls 'c:\missingFolder'
+ ~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\missingFolder:String) [Get-ChildItem], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand


2020-07-31 11:57:11.014 Info ExitCode 0
2020-07-31 11:57:11.622 Info TOE has completed execution successfully
```

10. **Notice** that there was an **error as noted by the** `Stderr` output **on line 6**.
    Yet, awstoe did run successfully as shown by the last line `2020-07-31 11:57:11.622 Info TOE has completed execution successfully`.

**Why would that happen? Shouldn't the pipeline fail?**
