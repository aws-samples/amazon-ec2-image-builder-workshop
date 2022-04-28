+++
title = "4. Locally developing components"
weight = 30
+++

Components are the **building blocks** that are consumed by an image recipe, for example, packages **for installation, security hardening steps, and tests**. You **define one or more component(s)**, that describe how to `build`, `validate`, and `test` your image.

{{<mermaid align="left">}}
graph LR;
subgraph Build Component
A(build phase) --> B(validate phase)
end
B --> X(Create AMI)
X --> Y(launch EC2 instance from AMI)
Y --> C(test phase)
subgraph Test Component
C
end
C -->D{Success?}
D -->|Yes| E[set image 'available']
D -->|No| F[stop]
{{< /mermaid >}}

## Application

Image Builder uses a [component management application (**awstoe**)](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager.html) to orchestrate complex workflows. This application uses a declarative document schema. Because it is a standalone application, it does not require additional server setup. It can run on any cloud infrastructure and on premises. 

## Document Schema

Components are defined in a `yaml` document that follows the following schema:

```yaml
name: (optional)
description: (optional)
schemaVersion: "string"

phases:
  - name: "string"
    steps:
        - name: "string"
          action: "string"
          timeoutSeconds: integer
          onFailure: "Abort|Continue|Ignore"
          maxAttempts: integer
          inputs:
```

## For this part of the workshop you need:

- A Windows 2019 EC2 instance.
- An IDE. You can use the bundled Powershell ISE or any other text editor.
- `awstoe` [which you can download here](https://docs.aws.amazon.com/imagebuilder/latest/userguide/toe-component-manager.html#toe-downloads).
- An RDP client on your local machine.
