+++
title = "3.7.4 Under the hood: Process review"
weight = 403
+++

The following is a representation of the pipeline that will run.

{{<mermaid align="left">}}
graph TB;

A(Launch EC2 instance from Parent Image.) --> B(Download Build Components)
B --> C(run build phase)
subgraph Build Component
C --> D(run validate phase)
end
D --> X(Create AMI)
X --> Y(launch EC2 instance from newly created AMI)
Y --> E(test phase)
subgraph Test Component
E
end
E -->F{Success?}
F -->|Yes| G[Image distribution]
F -->|No| H[stop]
{{< /mermaid >}}
