+++
title = "4.5 Bonus: Build your own pipeline and components!"
weight = 550
+++

**Now you are ready to build your own!**

Our goal is to create a fully patch Windows EC2 instance, that hosts a static page in IIS showing the image below:

![unicorn](unicorn.png)

The s3 location for this image is:

```
s3://ee-assets-prod-us-east-1/modules/fdbebd0c9c3c488cbe1c60adcdc48655/v1/unicorn.png
```

The standard webroot location for IIS is `C:\inetpub\wwwroot`

{{% notice tip %}}
This workshop is not about learning to write code! **Required code can be found in the hints section below the graph!**
{{% /notice %}}

## Go ahead and build the pipeline shown below

{{<mermaid align="left">}}
graph TB;

A(Parent Image - Latest Server 2019 AMI) --> B(Download Build Components)
B --> C(Patch OS)
subgraph Build Phase
C --> D(Install Web-Server: IIS)
D --> E(Download a Unicorn Image from s3 and add it to index.html)
E --> F(Reboot)
end
subgraph Validate Phase
F --> G(Validate IIS is installed)
end
G --> X(Test whether IIS returns HTTP 200 OK with Photo of Unicorn)
subgraph Test Component
X
end
X -->Y{Success?}
Y -->|Yes| Z[set image 'available']
{{< /mermaid >}}

## Hints

1. {{%expand "Click me for Patch OS hint." %}}
   Try the [UpdateOS](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-action-modules.html#image-builder-action-modules-updateos) action module.
   {{% /expand%}}
2. {{%expand "Click me for Install Web-Server IIS code." %}}

Remember we need to use `ErrorAction` to make sure we catch terminating errors!

```PowerShell
Install-WindowsFeature Web-Server -ErrorAction stop
```

{{% /expand%}}

3. {{%expand "Click me for 'Download a Unicorn Image' hint." %}}
   Try the [S3Download](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-action-modules.html#image-builder-action-modules-s3download) action module. **File source location:**

```
s3://ee-assets-prod-us-east-1/modules/fdbebd0c9c3c488cbe1c60adcdc48655/v1/unicorn.png
```

**File destination:**

```
C:\inetpub\wwwroot\unicorn.png
```

{{% /expand%}}

1. {{%expand "Click me for 'Create index.html' code." %}}

```PowerShell
@"
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello World!</h1>
    <img src="unicorn.png" />
  </body>
</html>
"@ | set-content c:\inetpub\wwwroot\index.html -force
```

{{% /expand%}}

5. {{%expand "Click me for 'Reboot' hint." %}}
   Try the [Reboot](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-action-modules.html#image-builder-action-modules-reboot) action module.
   {{% /expand%}}

6. {{%expand "Click me for 'Validate IIS is installed' code." %}}

```PowerShell
if (!(Get-WindowsFeature "web-server").installed) {throw "NOT INSTALLED"} else {"OK: web-server is installed"}
```

{{% /expand%}}

7. {{%expand "Click me for 'Test IIS result' code." %}}

```PowerShell
#Install Pester
$ErrorActionPreference = 'stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name Pester -Force -Scope CurrentUser -SkipPublisherCheck -AllowClobber

#Run validation tests with ExitCode
Import-module Pester
$PesterPreference = [PesterConfiguration]::Default
$PesterPreference.TestResult.Enabled = $true
$PesterPreference.Output.Verbosity = 'detailed'
$PesterPreference.Run.Exit = $true

Describe "IIS validation test" {
    BeforeAll {
        $httpResponse = Invoke-WebRequest localhost
    }
    It "HTTP Headers should have key: server, value: Microsoft-IIS" {
        $httpResponse.Headers['server'] | Should -Match 'Microsoft-IIS'
    }
    It "IIS should return HTTP 200 OK" {
        $httpResponse.StatusDescription | Should -BeExactly 'OK'
        $httpResponse.StatusCode | Should -BeExactly 200
    }
    It "IIS should return unicorn.png image" {
        $httpResponse.Images.src | Should -Match 'unicorn'
    }
}
```

{{% /expand%}}

## Full example solution

{{%expand "Click me for full solution." %}}

```yaml
name: ib-workshop-patch-windows
description: Install Patches
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: update
        action: UpdateOS
```

```yaml
name: ib-workshop-install-iis
description: Install IIS
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: install-iis
        action: ExecutePowerShell
        inputs:
          commands:
            - Install-WindowsFeature Web-Server -ErrorAction stop
```

```yaml
name: ib-workshop-download-unicorn
description: Download unicorn image
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: dlUnicorn
        action: S3Download
        inputs:
          - source: s3://ee-assets-prod-us-east-1/modules/fdbebd0c9c3c488cbe1c60adcdc48655/v1/unicorn.png
            destination: C:\inetpub\wwwroot\unicorn.png
```

```yaml
name: ib-workshop-set-web-content
description: Create index.html
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: create-index
        action: ExecutePowerShell
        inputs:
          commands:
            - |-
              @"
              <!DOCTYPE html>
              <html>
                  <body>
                  <h1>Hello World!</h1>
                  <img src="unicorn.png" />
                  </body>
              </html>
              "@ | Set-Content c:\inetpub\wwwroot\index.html -Force
```

```yaml
name: ib-workshop-reboot
description: reboot
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: reboot
        action: Reboot
```

```yaml
name: ib-workshop-validate-iis
description: validates iis install
schemaVersion: '1.0'
phases:
  - name: validate
    steps:
      - name: validate-iis
        action: ExecutePowerShell
        inputs:
          commands:
            - 'if (!(Get-WindowsFeature "web-server").installed) {throw "NOT INSTALLED"} else {"OK: web-server is installed"}'
```

```yaml
name: ib-workshop-run-pester-tests
description: Installs Pester and runs IIS tests
schemaVersion: '1.0'
phases:
  - name: build
    steps:
      - name: test
        action: ExecutePowerShell
        inputs:
          commands:
            - |-
              #Install Pester
              $ErrorActionPreference = 'stop'
              [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
              Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
              Install-Module -Name Pester -Force -Scope CurrentUser -SkipPublisherCheck -AllowClobber
  - name: test
    steps:
      - name: test
        action: ExecutePowerShell
        inputs:
          commands:
            - |-
              #Run validation tests with ExitCode
              Import-Module Pester -MinimumVersion 5.0.0
              $PesterPreference = [PesterConfiguration]::Default
              $PesterPreference.TestResult.Enabled = $true
              $PesterPreference.Output.Verbosity = 'detailed'
              $PesterPreference.Run.Exit = $true

              Describe "IIS validation test" {
                  BeforeAll {
                      $httpResponse = Invoke-WebRequest localhost
                  }
                  It "HTTP Headers should have key: server, value: Microsoft-IIS" {
                      $httpResponse.Headers['server'] | Should -Match 'Microsoft-IIS'
                  }
                  It "IIS should return HTTP 200 OK" {
                      $httpResponse.StatusDescription | Should -BeExactly 'OK'
                      $httpResponse.StatusCode | Should -BeExactly 200
                  }
                  It "IIS should return unicorn.png image" {
                      $httpResponse.Images.src | Should -Match 'unicorn'
                  }
              }
```

Don't forget to check the logs, they should look like:

```log
2020-08-10 19:10:12.715 Info Stdout: Describing IIS validation test
2020-08-10 19:10:13.475 Info Stdout:   [+] HTTP Headers should have key: server, value: Microsoft-IIS 234ms (167ms|67ms)
2020-08-10 19:10:13.551 Info Stdout:   [+] IIS should return HTTP 200 OK 69ms (65ms|3ms)
2020-08-10 19:10:13.713 Info Stdout:   [+] IIS should return unicorn.png image 160ms (157ms|2ms)
2020-08-10 19:10:14.156 Info Stdout: Tests completed in 1.91s
2020-08-10 19:10:14.218 Info Stdout: Tests Passed: 3, Failed: 0, Skipped: 0 NotRun: 0
```

{{% /expand%}}
