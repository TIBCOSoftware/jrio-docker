# TIBCO  JasperReports&reg; IO for Docker

# Table of contents

1. [Introduction](#introduction)
1. [Prerequisites](#prerequisites)
  1. [Downloading JasperReports IO](
#downloading-jasperreports-io)
  1. [Cloning the repository](#cloning-the-repository)
  1. [Repository structure](#repository-structure)
1. [Build and run](#build-and-run)
  1. [Applying customizations](#applying-customizations)


# Introduction

This repository includes a sample `Dockerfile` and 
supporting files for
building, configuring, and running
TIBCO JasperReports&reg; IO
in a Docker container.  
The distribution can be downloaded from 
[https://github.com/TIBCOSoftware/jrio-docker](#https://github.com/TIBCOSoftware/js-docker).

This configuration has been certified using JasperReports IO Professional 1.0.0

For more information about JasperReports Server, see the
[Jaspersoft community](http://community.jaspersoft.com/).

# Prerequisites

The following software is required or recommended:

- [docker-engine](https://docs.docker.com/engine/installation) version 17.12 or
higher
- [git](https://git-scm.com/downloads)
- (*optional*) TIBCO  JasperReports&reg; IO commercial license.
- Contact your sales
representative for information about licensing. 

## Downloading JasperReports IO

Download the JasperReports IO zip archive from the Community website
and unpack it.

## Cloning the repository(optional)

Cloning this JasperReports IO Docker repository is not required as the Dockerfile and all the supported files in this repo are packed inside the JasperReports IO zip distribution. 

## Repository structure inside docker folder

When you unpack the JasperReports IO zip, the following files are placed under docker folder:

- `Dockerfile` - sample build commands
- `application-context.xml` - repository configuration file
- `jrio.sh`- overlay script

# Build and run

## Building and running with default repository

By default, the JRIO service started from the Docker image uses a repository found inside the Docker instance under the /mnt/jrio-repository folder.
To build and run a JasperReports IO container with internal repository, execute these commands in your repository:

```console
$ docker build -f docker/Dockerfile -t jrio:1.0.0 .
$ docker run --name my-jrio -p 5080:8080 jrio:1.0.0
```

Where:

- `jrio:1.0.0` is the image name and version tag
for your build. This image will be used to create containers.
- `my-jrio` is the name of the new JasperReports IO container.
- `-p 5080:8080` port mapping (jetty service is started by default on port 8080, so container port should be mapped to host port (for ex. to 5080 etc)

## Using data volumes
## Mount external repository folder as a volume

Docker recommends the use of [data volumes](
https://docs.docker.com/engine/tutorials/dockervolumes/) for managing
persistent data and configurations. 

If repository is mounted as a volume, then default container repository is overridden and replaced with the external one.

```console
docker run --name my-jrio -it -d -p 5080:8080 -v /jrio/jrio-repository:/mnt/jrio-repository jrio:1.0.0
```
Where:

- `my-jrio` is the name of the new JasperReports IO container
- `/reports/jrio-repository` is a local repository mounted as a data volume (make sure that this shared path is configured in your environment rom Docker -> Preferences... -> File Sharing)
- `jrio:1.0.0` - is an image name and version tag that is used
as a base for the new container
- `/mnt/jrio-repository` is default container repository that is being overrriden


# Customizing JasperReports IO at runtime

The default JRIO configuration can be overridden or altered at runtime with an overlay script. It copies the content of the /mnt/jrio-folder over /jrio/base. 

Customizations can be added to JasperReports IO container at runtime
via the `/path/jrio-overlay` directory created in local environment. The files in this directory are applied to
`/jrio/base` in sorted order.

## Applying customizations

```console
docker run --name my-jrio -it -d -p 5080:8080 -v /jrio/jrio-overlay:/mnt/jrio-overlay jrio:1.0.0
```
Where:

- `my-jrio` is the name of the new JasperReports IO container
- `/jrio/jrio-overlay` is a local repository mounted as a data volume where configuration files should be mimicking full path like 
/jrio/jrio-overlay/webapps/jrio/WEB-INF/applicationContext-repository.xml

See `docker/jrio.sh` for implementation details

## License

By default, the JasperReports Server IO zip distribution is packaged with a 60 day evaluation license. Once the production license is obtained, it can be replaced using overlay. 

```console

$ docker run --name my-jrio -it -d -p 5080:8080 -v /jrio/jrio-license:/mnt/jrio-overlay jrio:1.0.0

```
Where:
/jrio/jrio-license` is a local repository mounted as a data volume where the license file should be placed using a full path like 
/jrio/jrio-overlay/webapps/jrio/WEB-INF/classes/jasperserver.license


## Docker documentation
For additional questions regarding docker and docker-compose usage see:
- [docker-engine](https://docs.docker.com/engine/installation) documentation
- [docker-compose](https://docs.docker.com/compose/overview/) documentation

# Copyright
&copy; Copyright 2018. TIBCO Software Inc.
Licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.  
___

Software Version: 1.0.0-&nbsp;

TIBCO, Jaspersoft, and JasperReports are trademarks or
registered trademarks of TIBCO Software Inc.
in the United States and/or other countries.

Docker is a trademark or registered trademark of Docker, Inc.
in the United States and/or other countries.


