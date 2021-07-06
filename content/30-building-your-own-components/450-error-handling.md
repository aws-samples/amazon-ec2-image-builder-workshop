+++
title = "4.3 Understanding error handling"
weight = 450
+++

To better understand why our pipeline didn't fail, we need to understand [terminating and non-terminating](https://devblogs.microsoft.com/scripting/understanding-non-terminating-errors-in-powershell/) errors in PowerShell.

**By default** `ls` which, in Windows PowerShell is an Alias for `Get-ChildItem`, **does NOT throw a terminating error**. This is true for many Powershell commands.

To signal `awstoe` that the command has failed, we need to make PowerShell throw terminating errors. We can enforce that using `-ErrorAction` or via `$ErrorActionPreference`.

## Let's explain that with an example.

`awstoe` under the hood creates a PowerShell script and executes it on your behalf. Let's try to replicate that.

1. **Open** a new **PowerShell prompt**.
2. **Create a sample file** as follows:

```powershell
"ls c:\missingFolder" > nonterminating.ps1
```

3. **Create a second file** as follows:

```powershell
"ls c:\missingFolder -ErrorAction stop" > terminating.ps1
```

**We have now created two scripts**: One with a terminating error, the other with a non-terminating error.

4. **Execute** those scripts **using** `powershell.exe` and the `-file` parameter **and get the exitcode**.

```powershell
powershell -file nonterminating.ps1; $LASTEXITCODE
powershell -file terminating.ps1; $LASTEXITCODE
```

5. Notice how the first returns `0`
6. The second returns `1`, **yet both return an error** to `stderr` (as visible by the red text in your console).

{{% notice warning %}}
If the exitcode is `0` the ImageBuilder pipeline will continue execution.
{{% /notice %}}

## Fixing the problem

If you want to stop your pipeline on any error, you can set `$ErrorActionPreference = 'Stop'` in all your `ExecutePowerShell` actions. This will apply to all commands in the step action **but not to all steps!**

7. **Update the content** from `my-first-doc.yml` as follows:

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
            - $ErrorActionPreference = 'Stop'
            - ls 'c:\missingFolder'
```

Now if we test it again, it should terminate as expected!

```PowerShell
& .\awstoe.exe run -d .\my-first-doc.yml
```

```json
{
  "executionId": "dcfb75ab-d32a-11ea-a952-0a43324a43da",
  "status": "failed",
  "failedStepCount": 1,
  "executedStepCount": 1,
  "failureMessage": "Document .\\my-first-doc.yml failed!",
  "logUrl": "C:\\Users\\admin\\Documents\\ibworkshop\\TOE_2020-07-31_12-39-23_UTC-0_dcfb75ab-d32a-11ea-a952-0a43324a43da"
}
```

**And the log:**

```log
2020-07-31 12:39:24.207 Info Stderr: ls : Cannot find path 'C:\missingFolder' because it does not exist.
At C:\Users\admin\AppData\Local\Temp\AWSTOE048856311\script-028222954.ps1:2 char:1
+ ls 'c:\missingFolder'
+ ~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\missingFolder:String) [Get-ChildItem], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand


2020-07-31 12:39:24.207 Info ExitCode 1
2020-07-31 12:39:25.214 Info TOE has completed execution with failure - Execution failed!
```
