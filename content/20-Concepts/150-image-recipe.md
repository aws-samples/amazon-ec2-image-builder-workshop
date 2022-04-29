+++
title = "2.2 Image Recipe"
weight = 150
+++

The **Image Recipe** is a versioned resource that **contains a Parent Image** and **one or more Components** to build your image.

{{% button href="https://docs.aws.amazon.com/cli/latest/reference/imagebuilder/create-image-recipe.html" %}}Image Recipe CLI documentation{{% /button %}}

### Parent Image

The parent image of the image recipe. Can be the ARN of the parent image or an AMI ID. The ARN format follows the following pattern:

`arn:aws:imagebuilder:${AWS::Region}:aws:image/${ParentImageName}/${ImageVersion}`

An example could be:

`arn:aws:imagebuilder:eu-west-1:aws:image/windows-server-2019-english-full-base-x86/2020.x.x`

{{% notice tip %}}
Using `x.x.x` for the version **ensures** that your pipeline always **starts from the latest image** AWS has [released](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-ami-version-history.html).
{{% /notice %}}

**AWS provides updated, fully-patched Windows AMIs within five business days** of Microsoft's patch Tuesday.

### Components

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
