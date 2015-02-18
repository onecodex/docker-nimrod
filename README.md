# refgenomics/docker-nimrod

[![Docker Repository on Quay.io](https://quay.io/repository/refgenomics/docker-nimrod/status?token=4f8dc19c-22b0-45c1-b2bd-b15eac01937c "Docker Repository on Quay.io")](https://quay.io/repository/refgenomics/docker-nimrod)

Ubuntu base image with security patches, git, [Bats](https://github.com/sstephenson/bats), and [Nim](https://github.com/Araq/Nimrod).

## Installation and Usage

    docker pull quay.io/refgenomics/docker-nimrod
    docker run -i -t quay.io/refgenomics/docker-nimrod

## Included Tools/Patches

* `bats`: The [Bats](https://github.com/sstephenson/bats) Bash Automated Testing System
* `git`: Git Version Control System.
* All Ubuntu LTS security updates (but not non-critical updates).
* Nim v0.10.2

## Tests

Tests are run as part of the `Dockerfile` build. To execute them separately within a container, run:

    bats test

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

Copyright (c) 2014 [Reference Genomics](https://www.refgenomics.com), [Nick Greenfield](https://github.com/boydgreenfield), and contributors.
