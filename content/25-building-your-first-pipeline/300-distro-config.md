+++
title = "3.5 Distribution Configuration"
weight = 300
+++

Distribution settings include specific Region settings for encryption, launch permissions, accounts that can launch the output AMI, the output AMI name, and license configurations.

We will **keep the image private** to our account, hence no need to change any settings.

1. Now click **Next**, and click **Create** on the following screen.

## Review

Now our pipeline will look like this:

{{<mermaid align="left">}}
graph TB;

A(Launch EC2 instance from Parent Image.) --> B(Download Build Components)
B --> C(run build phase)
subgraph Build Component
C --> D(run validate phase)
end
D --> X(Create AMI)
X --> Y(launch EC2 instance from AMI)
Y --> E(test phase)
subgraph Test Component
E
end
E -->F{Success?}
F -->|Yes| G[set image 'available']
F -->|No| H[stop]
{{< /mermaid >}}
