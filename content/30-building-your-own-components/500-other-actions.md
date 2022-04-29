+++
title = "4.4 Using other action modules"
weight = 500
+++

**ImageBuilder takes away the heavy lifting with** other **action modules** and managed components. Take for example, updating your operating system. You don't have to write PowerShell commands for this yourself as this is build into the product.

**Action Modules**

- [ExecuteBinary](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-executebinary)
- [ExecuteBash](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-executebash)
- [ExecutePowerShell](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-executepowershell)
- [Reboot](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-reboot)
- [SetRegistry](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-setregistry)
- [UpdateOS](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-updateos)
- [S3Upload](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-s3upload)
- [S3Download](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-action-modules.html#action-modules-s3download)


For an updated list **navigate to** the {{% button href="https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-action-modules.html" %}}Action Modules documentation{{% /button %}}

## Using the UpdateOS action module

1. Update `my-first-doc.yml` as follows:

```yaml
name: Hello World
description: This is hello world testing document for Windows.
schemaVersion: 1.0
phases:
  - name: build
    steps:
      - name: UpdateStep
        action: UpdateOS
```

2. Execute the document `./awstoe.exe run -d .\my-first-doc.yml`
3. After a couple of minutes, your system should automatically reboot if updates are found.
4. After the system comes back online, review the log file.

**Note the reboot signal in the log.** In the example below it can be found at `12:31:32.541`. **EC2 Image Builder** automatically **handles the reboot** for you, and **afterwards the document continues with the execution**. No extra code needed on your end! This is also true for the other Action Modules.

```log
2020-08-06 12:30:40.535 Info Document .\my-first-doc.yml
2020-08-06 12:30:40.536 Info Phase build
2020-08-06 12:30:40.536 Info Step UpdateStep
2020-08-06 12:30:40.547 Info UpdateOS (Windows): Starting windows update process at 2020-08-06 12:30:40.5474777 +0000 GMT m=+0.062622801
2020-08-06 12:30:40.872 Info Stdout: Starting the Windows Update process.
2020-08-06 12:30:40.941 Info Stdout: Searching for updates.
2020-08-06 12:30:54.574 Info Stdout: Updates to process: 2
2020-08-06 12:30:54.574 Info Stdout: The following updates were found:
2020-08-06 12:30:54.594 Info Stdout: - 2020-07 Cumulative Update Preview for .NET Framework 3.5, 4.7.2 and 4.8 for Windows Server 2019 for x64 (KB4567327)
2020-08-06 12:30:54.595 Info Stdout: - Security Intelligence Update for Microsoft Defender Antivirus - KB2267602 (Version 1.321.762.0)
2020-08-06 12:30:54.595 Info Stdout: The following updates will be installed:
2020-08-06 12:30:54.598 Info Stdout: - 2020-07 Cumulative Update Preview for .NET Framework 3.5, 4.7.2 and 4.8 for Windows Server 2019 for x64 (KB4567327)
2020-08-06 12:30:54.599 Info Stdout: - Security Intelligence Update for Microsoft Defender Antivirus - KB2267602 (Version 1.321.762.0)
2020-08-06 12:30:54.600 Info Stdout: Updates to download: 2
2020-08-06 12:30:54.620 Info Stdout: Downloading '2020-07 Cumulative Update Preview for .NET Framework 3.5, 4.7.2 and 4.8 for Windows Server 2019 for x64 (KB4567327)'
2020-08-06 12:30:58.939 Info Stdout: Downloading 'Security Intelligence Update for Microsoft Defender Antivirus - KB2267602 (Version 1.321.762.0)'
2020-08-06 12:30:59.182 Info Stdout: Updates to install: 2
2020-08-06 12:30:59.197 Info Stdout: Installing '2020-07 Cumulative Update Preview for .NET Framework 3.5, 4.7.2 and 4.8 for Windows Server 2019 for x64 (KB4567327)'
2020-08-06 12:31:24.627 Info Stdout: Installing 'Security Intelligence Update for Microsoft Defender Antivirus - KB2267602 (Version 1.321.762.0)'
2020-08-06 12:31:32.515 Info Stdout: A restart is required to complete the installations. Restarting now.
2020-08-06 12:31:32.541 Info Getting reboot signal
2020-08-06 12:31:32.541 Info Stderr:
2020-08-06 12:31:32.541 Info ExitCode 3010
2020-08-06 12:31:32.541 Info UpdateOS (Windows): Windows update process completed at 2020-08-06 12:31:32.5410607 +0000 GMT m=+52.048543901 with the exitcode 3010
2020-08-06 12:31:35.159 Info Rebooting the system now
2020-08-06 12:33:17.047 Info Recovery completed for detailed output.
2020-08-06 12:33:17.060 Info Document .\my-first-doc.yml
2020-08-06 12:33:17.060 Info Phase build
2020-08-06 12:33:20.603 Info Executor: System has rebooted successfully
2020-08-06 12:33:20.603 Info Step UpdateStep
2020-08-06 12:33:20.651 Info UpdateOS (Windows): Starting windows update process at 2020-08-06 12:33:20.6514381 +0000 GMT m=+79.429533301
2020-08-06 12:33:23.987 Info Stdout: Starting the Windows Update process.
2020-08-06 12:33:24.273 Info Stdout: Searching for updates.
2020-08-06 12:33:29.617 Info Stdout: Updates to process: 0
2020-08-06 12:33:29.618 Info Stdout: Updates to download: 0
2020-08-06 12:33:29.620 Info Stdout: Updates to install: 0
2020-08-06 12:33:29.667 Info Stdout: The Windows Update process has completed with success.
2020-08-06 12:33:29.746 Info Command execution completed successfully
2020-08-06 12:33:29.746 Info Stderr:
2020-08-06 12:33:29.746 Info ExitCode 0
2020-08-06 12:33:29.746 Info UpdateOS (Windows): Windows update process completed at 2020-08-06 12:33:29.7461035 +0000 GMT m=+88.524198701 with the exitcode 0
2020-08-06 12:33:29.748 Info TOE has completed execution successfully
```
