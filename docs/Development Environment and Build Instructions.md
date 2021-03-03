---
title: Development Environment and Build Instructions
nav_order: 2
parent: Docs
---

## Development Environment and Build Instructions

#### Server
To install and run a prebuilt release, ensure docker is installed, and `cd` to the directory where you downloaded the image.
Then, run `docker load -i [name of image]` to load it, and `docker run --rm --name detective-server -p 5584:5584 detective-server` to start the server.

If you want to build an image from source, ensure your active directory is `FRCDetective/Server`, and run `./dockerbuild.sh`. The image file will be saved as `detectiveserver-latest.tar` in your home directory.