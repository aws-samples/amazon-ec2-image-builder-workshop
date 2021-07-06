# Introduction to the EC2 Image Builder Workshop

The workshop is available at https://ec2-image-builder.workshop.aws/. It's a static website
hosted on S3 and served through CloudFront.

## Developer Guide

This workshop is built with markdown as a static HTML site using [hugo](http://gohugo.io).

```bash
$ brew install hugo
```

You'll find the content of the workshop in the [`content/`](content/) directory.

You can start up a local development server by running:

```bash
$ hugo server -D
$ open http://localhost:1313/
```

## License Summary

The documentation is made available under the Creative Commons Attribution-ShareAlike 4.0 International License. See the LICENSE file.

The sample code within this documentation is made available under the MIT-0 license. See the LICENSE-SAMPLECODE file.