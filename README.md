# jrio-docker
# JasperReports IO Dockerfile

# TIBCO  JasperReports&reg; IO for Docker

# Table of contents

1. [Introduction](#introduction)
1. [Prerequisites](#prerequisites)
  1. [Downloading JasperReports IO](
#downloading-jasperreports-io)
  1. [Cloning the repository](#cloning-the-repository)
  1. [Repository structure](#repository-structure)
1. [Build and run](#build-and-run)
  1. [Building and running]
  1. [Building and running](
#building-and-running-with-a-pre-existing-postgresql-instance)
  1. [Creating a new PostgreSQL instance during build](
#creating-a-new-postgresql-instance-during-build)
1. [Additional configurations](#additional-configurations)

1. [Customizing JasperReports Server at runtime](
#customizing-jasperreports-server-at-runtime)
  1. [Applying customizations](#applying-customizations)
  1. [Applying customizations manually](
#applying-customizations-manually)
  1. [Applying customizations with Docker Compose](
#applying-customizations-with-docker-compose)
  1. [Restarting JasperReports Server](
#restarting-jasperreports-server)
1. [Logging in](#logging-in)


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
- (*optional*) TIBCO  Jaspersoft&reg; commercial license.
- Contact your sales
representative for information about licensing. If you do not specify a
TIBCO Jaspersoft license, the evaluation license is used.


## Downloading JasperReports IO

Download the JasperReports IO commercial zip archive from the Community website
and unpack it.

## Cloning the repository(optional)

Cloning this JasperReports IO Docker repository is not required as the Dockerfile and all the supported files in this repo are packed inside the JasperReports IO distribution. 

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
docker run --name my-jrio -it -d -p 5080:8080 -v /opt/jrio-repository:/mnt/jrio-repository jrio:1.0.0
```
Where:

- `my-jrio` is the name of the new JasperReports IO container
- `/reports/jrio-repository` is a local repository mounted as a data volume (make sure that this shared path is configured in your environment rom Docker -> Preferences... -> File Sharing)
- `jrio:1.0.0` - is an image name and version tag that is used
as a base for the new container
- `/mnt/jrio-repository` is default container repository that is being overrriden


# Customizing JasperReports IO at runtime

The default JRIO configuration can be overridden or altered at runtime with the help of startup script that copies content of /mnt/jrio-verlay. The files inside the Docker instance can be modified or altered with an overlay script.

Customizations can be added to JasperReports IO container at runtime
via the `/path/jrio-overlay` directory created in local environment. All zip files in this directory are applied to
`/usr/local/tomcat/webapps/jasperserver-pro` in sorted order (natural sort).

## Applying customizations

The JRIO Docker image has a startup script in which it copies the content of the internal folder /mnt/jrio-overlay on top of the /jrio/base folder. (in JRIO standalone edition equivalent path is jrio-1.0.0/jrio)
This allows overriding default configuration of the JRIO application by mounting /mnt/jrio-overlay folder to an external folder or Docker volume at image startup, which contains the custom configuration files.

For example, the /mnt/jrio-overlay folder can be mounted to a host machine volume using a command like the following:

>docker run -it -p 5080:8080 -v /opt/jrio-overlay:/mnt/jrio-overlay jrio-standalone

In this example, in order to override the applicationContext-repository.xml file of the JRIO web application, the modified configuration file needs to be placed at:

/opt/jrio-overlay/webapps/jrio/WEB-INF/applicationContext-repository.xml

For example:
```console
mkdir /reports/jrio-overlay 
cp -f applicationContext-repository.xml
/reports/jrio-overlay/webapps/jrio/WEB-INF/applicationContext-repository.xml


docker run -it -p 5080:8080 -v /opt/jrio-repository:/mnt/jrio-repository jrio-standalone
docker volume create --name jrio-repository
sudo cp repository.zip \
/var/lib/docker/volumes/jrio-repository/_data
docker run --name my-jrio -it -d -p 5080:8080 -v jrio-volume:/opt/jrio-repository:/mnt/jrio-repository jrio:1.0.0
```
Where:

- `my-jrio` is the name of the new JasperReports IO container
- `jrio-repository` is the name of the repository data volume
- `repository.zip` is an archive containing repository resources
- `/var/lib/docker/volumes/jrio-repository/_data` is an example path. Use `docker volume inspect`
to get the local path to the volume for your system.
- `jrio:1.0.0` - is an image name and version tag that is used
as a base for the new container
- `/mnt/jrio-repository` is default container repository

See `scripts/entrypoint.sh` for implementation details and
`docker-compose.yml` for a sample setup of a customization volume via Compose.





## Docker documentation
For additional questions regarding docker and docker-compose usage see:
- [docker-engine](https://docs.docker.com/engine/installation) documentation
- [docker-compose](https://docs.docker.com/compose/overview/) documentation

# Copyright
&copy; Copyright 2018. TIBCO Software Inc.
Licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.  

___

Software Version: 1.0.0-&nbsp;
Document version number: 1016-JSP63-01

TIBCO, Jaspersoft, and JasperReports are trademarks or
registered trademarks of TIBCO Software Inc.
in the United States and/or other countries.

Docker is a trademark or registered trademark of Docker, Inc.
in the United States and/or other countries.


