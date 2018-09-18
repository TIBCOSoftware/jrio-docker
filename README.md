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

## Building and running with a repository inside a container

To build and run a JasperReports IO container with internal repo, execute these commands in your repository:

```console
$ docker build -f docker/Dockerfile -t jrio:1.0.0 .
$ docker run --name my-jrio -p 8080:8080 jrio:1.0.0
```

Where:

- `jrio:1.0.0` is the image name and version tag
for your build. This image will be used to create containers.
- `my-jrio` is the name of the new JasperReports IO container.

## Mount an external repository folder as a  volume
## Using data volumes

Docker recommends the use of [data volumes](
https://docs.docker.com/engine/tutorials/dockervolumes/) for managing
persistent data and configurations. The type and setup of data volumes depend
on your infrastructure. We provide sensible defaults for a basic
docker installation.

Note that the data in data volumes is not removed with the container and needs
to be removed separately. Changing or sharing data in  the default
data volume while the container is running is not recommended. To share a
volume, use [volume plugins](
https://docs.docker.com/engine/extend/plugins/). See the Docker
[documentation](https://docs.docker.com/engine/tutorials/dockervolumes/#/
important-tips-on-using-shared-volumes) for more information.

### Paths to data volumes on Mac and Windows
On Mac and Windows, you must mount a volume as a directory and reference the
local path. For example, to access a license on a local directory on Mac:

```console
docker run --name new-jrs
-v /<path>/resources/license:/usr/local/share/jasperreports-pro/license 
-p 8080:8080 -e DB_HOST=172.17.10.182 -e DB_USER=postgres -e 
DB_PASSWORD=postgres -d jasperserver-pro:6.3.0
```

## Web application

By default, the JasperReports Server Docker container stores the web
application data in `/usr/local/tomcat/webapps/jasperserver-pro`. To create a
locally-accessible named volume, run the following commands at container
generation time:
```console
$ docker volume create --name some-jasperserver-data
$ docker run --name some-jasperserver \
-v some-jasperserver-data:/usr/local/tomcat/webapps/jasperserver-pro \
-p 8080:8080 -e DB_HOST=172.17.10.182 -e DB_USER=postgres \
-e DB_PASSWORD=postgres -d jasperserver-pro:6.3.0
```
Where:

- `some-jasperserver-data` is the name of the new data volume.
- `some-jasperserver` is the name of the new JasperReports Server container.
- `jasperserver-pro:6.3.0`  is the image name and version tag
for your build. This image will be used to create containers.
- Database settings should be modified for your setup.

Now you can access the JasperReports Server web application
locally. Run `docker volume inspect jasperserver-data` to determine the storage
path and additional details about the new volume.

If you want to define the local volume path manually, you cannot use named
volumes. Instead, modify `docker run` like this:
```console
$ docker run --name some-jasperserver -v \
/some-path/some-jasperserver-data:/usr/local/tomcat/webapps/jasperserver-pro \
-d jasperserver-pro:6.3.0
```
Where:
- `/some-path/some-jasperserver-data` is a local path that will be mounted.

## License

By default, the JasperReports Server Docker container expects to find the
license in the
`/usr/local/share/jasperreports-pro/license` directory on your system.
If a license file
is not present at this location, then the 60-day evaluation license is used.

On Linux systems, you can add a license volume and store your commercial
license there, for example:

```console
$ docker volume create --name some-jasperserver-license
$ sudo cp jasperserver.license \
/var/lib/docker/volumes/some-jasperserver-license/_data
$ docker run --name some-jasperserver \
-v some-jasperserver-license:/usr/local/share/jasperreports-pro/license \
-p 8080:8080 -e DB_HOST=172.17.10.182 -e DB_USER=postgres \
-e DB_PASSWORD=postgres -d jasperserver-pro:6.3.0

```
Where:

- `some-jasperserver-license` is the name of the new data volume.
- `/var/lib/docker/volumes/some-jasperserver-license/_data` is an example path.
It may differ on your system, use `docker volume inspect` to get
local path to volume.
- `some-jasperserver` is the name of the new JasperReports Server container
- `jasperserver-pro:6.3.0`  is the image name and version tag
for your build. This image will be used to create containers.
- Database settings should be modified for your setup.

See `Dockerfile` and `scripts/entrypoint.sh` for details.

On Windows and Macintosh, you can mount a directory 
with the license resource. 
See the Docker documentation for more information. 
See also 
[Paths to data volumes on Mac and Windows](#paths-to-data-volumes-on-mac-and-windows).
For additional information about paths on Mac, see
 [`docker volume inspect` returns incorrect paths on MacOS X](#-docker-volume-inspect-returns-incorrect-paths-on-macos-x).


To update your license without data volumes on an existing container:

```console
$ docker cp jasperserver.license \
some-jasperserver:/usr/local/share/jasperreports-pro/license/
$ docker restart some-jasperserver
```
Where:

- `some-jasperserver` is the name of the new JasperReports Server container.

Note that you need to stop the JasperReports Server container
prior to license update and restart it after.




# Customizing JasperReports IO at runtime

Customizations can be added to JasperReports IO container at runtime
via the `/usr/local/share/jasperreports-pro/customization` directory in the
container. All zip files in this directory are applied to
`/usr/local/tomcat/webapps/jasperserver-pro` in sorted order (natural sort).

## Applying customizations

For example:
```console
$ docker volume create --name some-jasperserver-customization
$ sudo cp custom.zip \
/var/lib/docker/volumes/some-jasperserver-customization/_data
$ docker run --name some-jasperserver -v \
some-jasperserver-customization:\
/usr/local/share/jasperreports-pro/customization \
-p 8080:8080 -e DB_HOST=172.17.10.182 -e DB_USER=postgres \
-e DB_PASSWORD=postgres -d jasperserver-pro:6.3.0
```
Where:

- `some-jasperserver-customization` is the name of the customization
data volume.
- `custom.zip` is an archive containing customizations, for example:
`WEB-INF/log4j.properties`. The archive will be unpacked as-is to the path
`/usr/local/tomcat/webapps/jasperserver-pro`
- `/var/lib/docker/volumes/some-jasperserver-customization/_data` is an
example path. Use `docker volume inspect`
to get the local path to the volume for your system.
- `some-jasperserver` is the name of the JasperReports Server
container.
- `jasperserver-pro:6.3.0` is an image name and version tag that is used
as a base for the new container.
- Database settings should be modified for your setup.

See `scripts/entrypoint.sh` for implementation details and
`docker-compose.yml` for a sample setup of a customization volume via Compose.

This directory can be also mounted as a [Data Volume](
https://docs.docker.com/engine/tutorials/dockervolumes/).
You must mount the directory on Windows and Macintosh. 
See also 
[Paths to data volumes on Mac and Windows](#paths-to-data-volumes-on-Mac-and-Windows).
For additional information about paths on Mac, see
 [`docker volume inspect` returns incorrect paths on MacOS X](#-docker-volume-inspect-returns-incorrect-paths-on-macos-x).

## Applying customizations with Docker Compose

To use customizations with `docker-compose`, run `docker volume inspect` 
to determine the path of the volume you want and add the license. To reference an 
existing volume, modify the YAML file appropriately.


## Applying customizations manually

You can also apply customizations manually, either via the `docker cp` command
or by modifying files in the [web application](#web-application) data volume.
For example:
```console
$ docker cp log4j.properties some-jasperserver:\
/usr/local/tomcat/webapps/jasperserver-pro/WEB-INF/
$ docker restart some-jasperserver
```
Where:

- `some-jasperserver` is the name of the JasperReports Server
container.

## Restarting the container

Note that independent of method, you need to restart the
JasperReports Server container (`docker restart some-jasperserver`)
if customizations are applied to a running container.

Logging in

To log into JasperReports IO on any operating system:

1. Start JasperReports Server.
2. Open a supported browser: Firefox, Internet Explorer, Chrome, or Safari.
3. Log into JasperReports Server by entering the startup URL in your
browser's address field.
The URL depends upon your installation. The default configuration uses:

```
http://localhost:8080/jrio-docs
```

Where:

- localhost is the name or IP address of the computer hosting JasperReports Server.
- 8080 is the port number for the Apache Tomcat application server. 
If you used a different port when installing your application server, 
specify its port number instead of 8080.

JasperReports Server ships with the following default credentials:

- superuser/superuser - System-wide administrator
- jasperadmin/jasperadmin - Administrator for the default organization



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


