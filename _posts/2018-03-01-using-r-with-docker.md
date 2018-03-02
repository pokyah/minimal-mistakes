---
title: "Using R with Docker"
header:
  overlay_image: /assets/images/r_docker.jpg
  og_image: /assets/images/r_docker.jpg
  caption: "Photo credit: [**pixabay**](https://pixabay.com)"
classes: "wide"
toc: false
toc_label: "Table des matières"
toc_icon: "cog"
categories:
  - howTo
tags:
  - R
  - Docker
  - tools
  - english
  - standard
---

Why should you do that ? There are two main reasons to use R in conjunction with Docker. First, it allows you to quickly and easily share your work wathever the OS and R configuration of your collaborators. Hassle free collaboration ! Second, it allows you to work in an isolated environment. This means that you will never pollute your OS and e.g. run in time-consuming re-installation procedures due to broken configuration. In case of OS crash, simply relaunch your *Docker R container* with a single command (more about containers below) and you are ready to work ! 

This tutorial is an introduction to R with Docker. It it not an extensive description of the [enormous amount of features](https://docs.docker.com/) and all the complexity of Docker. It's rather a good base to get started that I've written based on my own R development needs. 

## What is a Docker container ?

Docker is the piece of software that allows you to run __containers__.

From the [official Docker website](https://www.docker.com/what-container) : 

>A container image is a lightweight, stand-alone, executable package of a piece of software that includes everything needed to run it: code, runtime, system tools, system libraries, settings. Available for both Linux and Windows based apps, containerized software will always run the same, regardless of the environment. Containers isolate software from its surroundings, for example differences between development and staging environments and help reduce conflicts between teams running different software on the same infrastructure.

This container approach has many advantages compares to the use of virtual machines : lightweight, quick and modular. 

In the Docker terminology, a containers actually means a running instance of an __image__.  

Again, from the official Docker Website : 

>Docker images are the basis of containers. An Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime. An image typically contains a union of layered filesystems stacked on top of each other. An image does not have state and it never changes.

## How Docker will help you with your R related work ? 

Now that you understand what a container is, I'll tell you what you can do with Docker in the context of you R work. 

You can create and use a container that runs with the Linux distro *of your choice*, with a version of R *of your choice*, the packages and required OS dependencies *of your choices*, and all of this in a totally isolated environment that is setup in seconds. And of course, you can create multiple containers with various R configurations depending of your needs ! 

This means that you will never run anymore in compatibility problems. It will also make your work [reproductible](https://www.nature.com/articles/s41562-016-0021) as you can share your containers with colleagues. 

Docker also makes the use of the [Packrat](https://rstudio.github.io/packrat/) dependency management quite obsolete.

## Docker installation 

You know why you should use Docker in the context of your R work and you want to install it now ! Well, to do it, simply follow the [installation instructions](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1) on the Docker official website. 

Before we dive into the R part, you will need to understand some essential Docker concepts.

## Essential Docker concepts & commands 

Each __image__ has its own __name__ and __ID__. You can list all your available Docker images and get their name and ID using the `image` command :
  
```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
agrometeor          latest              fea4eeec5c2a        10 days ago         2.41GB
```
To __run an image as a container__,  simply use the `run` command with the image ID or name : 

```bash
$ docker run <IMAGE-NAME>
```
Note that this command can receive many optional parameters (we will see an example later). 

You can also run a container from an image which is hosted on [Docker Hub](https://hub.docker.com/r/pokyah/agrometeordocker/). Docker will automatically download it on your computer and run it as a container once it is downloaded (to use this feature, you will first need to create a Docker hub account). 

For geospatial R work you could for example run the image named [rocker/geospatial](https://hub.docker.com/r/rocker/geospatial/) which contains Linux, R, Rstudio and the most famous R spatial packages and their OS dependencies :

```bash
$ docker run rocker/geospatial
```
You can of course run multiple different images simultanesously but you can also run a single image simultaneously in multiple separate containers. To __list all your running Docker containers__ and get their name and ID, use the `ps` command. Note that the name is randomly generated by Docker.
  
```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                    NAMES
b18f77625a00        agrometeor          "/init"             About an hour ago   Up About an hour    0.0.0.0:8787->8787/tcp   silly_roentgen

```
Running containers use computing ressources. To __stop and remove__ a running container use the `rm` command :  

```bash
$ docker rm -f <CONTAINER-ID>
```

Pay attention that when you stop a container, all the work that has been done inside the container is lost ! This is on purpose and we will later see the proper and efficient way to save your R developments made inside a container. If you want to save modifications made inside a container (e.g. adding a R library and its OS dependencies) you have to `commit` your container. But this is out of the scope of this tutorial. If you are interested, you can read the corresponding [doc](https://docs.docker.com/engine/reference/commandline/commit/#commit-a-container-with-new-configurations).  

If you need it, you can explore the file system of the running container (similarly to what you do when you are connected to a server using ssh conection) :
  
```bash
$ docker exec -t -i <CONTAINER-ID> /bin/bash
```

Docker is not limited to images existing on Docker Hub. It allows you to create your images with the configuration of your own. Creativity is the limit. Creating a Docker image requires a __Dockfile__ which is simply a configuration file that tells Docker what to put in your image. For example, you can find  the Dockfile that was used to create the rocker/geospatial image that we mentioned earlier on [github](https://github.com/rocker-org/geospatial/blob/master/Dockerfile) .  To __build an image__ from a dockfile you simply open a terminal in the folder containing the dockfile and execute the `build` command with the name you want to attribute to your image (don't forget the "." at the end !) :   

```bash
$ docker build -t <IMAGE-NAME> .
```

There a lot of ressources on the web that explain how to create your own images. Check my selection in the further reading section at the end of the post. 

In case you are sure you will not anymore run an image as container(s), you can delete it to save some space on your computer : 

```bash
$ docker rmi >IMAGE_NAME:VERSION/IMAGE-ID>
```

And to delete all images (really ?!) :
  
```bash
$ docker rmi $(docker images -qf "dangling=true")
```

## Using RStudio inside a Docker container and saving your work

Let's dive in the latest part of this tutorial : running R inside a container. It's actually pretty simple. It involves 2 steps : 

1. Choosing the pre-build R oriented Docker image you want to use
2. Running it as a container with optional parameters

Let's say you need to make some R developments made easier with the [tidyverse](https://www.tidyverse.org/) family packages. To do this you will download the pre-built [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/image) from Docker hub using the command `pull` (note the similarity with [git](http://r-bio.github.io/intro-git-rstudio/)):

```bash
$ pull docker pull rocker/tidyverse
```
Remember that we have learned that once closed, containers loose all the modifications you have made within it. So, __how to save your R developments made within a container__ ? The trick is to actually __mount your project folder from your host computer to the container__. This is achieved by passing optional parameters to the `run` command.

If you want to run a container from the rocker/tidyverse image with an R project located in your host computer at `/home/yourUsername/Rprojects/yourProject/` and work in RStudio, use the `run` command with these optional parameters : 

```bash
$ docker run -w /home/rstudio/ rm -p 8787:8787 -v /yourUsername/Rprojects/yourProject/:/home/rstudio/ rocker/tidyverse
```
Docker will instantiate a new container from the rocker/tidyverse image and make your project folder available to the container by mounting it. All the modifications that you made to your mounted host folder from your container will be effective in your host machine. So once you stop your container, don't worry, your modifications will be saved ! 

To launch your container RStudio install, open a web-browser and navigate to `http://localhost:8787`. You habitual RStudio interface will be launched within a few seconds and your mounted folder will appear in the files pane. __Congratulations, you are now ready to work within a dockerised RStudio install !__

In most of the cases, before running an image, you will need to customise it so that it reflects your own needs. __Customising an image__ requires to __edit its dockfile__ and rebuild the image as mentioned earlier. 

To keep __git versioned dockfiles__ of your images, you can push them to [Github](https://github.com/). Hosting your dockfile on Github offers you a nice feature : [automated builds](https://docs.docker.com/docker-hub/builds/). Once enabled, each time you push a modification of your dockfile to Github, Docker will rebuild your image and make it ready to be pulled by others.

You can share this very specific R environment with your co-workers. First, share them this tutorial and then share your image. For this purpose, you have two solutions :

1. Sending them the corresponding Dockfile and let them build the image on their machine (more complex)
2. Upload your image to Docker hub (manually or with the automated build feature) and simply send them the name of your image so that then can you it immediately use it with the `run` command

## Conclusion

You have learned how to use Docker to run your own customized R isolated environment inside a container and how to share this specific environment with your colleagues.

In a next tutorial, I'll explain you how to run a container able to connect to an external postgreSQL database.  

## Future readings 

* [Andrew Heiss tuto](https://www.andrewheiss.com/blog/2017/04/27/super-basic-practical-guide-to-docker-and-rstudio/)
* [Dirk Eddelbuettel presentation](http://dirk.eddelbuettel.com/papers/useR2015_docker.pdf)
* [Brian J. Knaus CLI tuto](https://knausb.github.io/2017/06/running-r-in-docker/)
* [R-Blogger post](https://www.r-bloggers.com/r-3-3-0-is-another-motivation-for-docker/)

### Dockfile customization

* [R package to create dockfiles]( http://o2r.info/2017/05/30/containerit-package/)
* [tutorial from ropenscilabs](http://ropenscilabs.github.io/r-docker-tutorial/05-dockerfiles.html)
* [mirantis blog tutorial](https://www.mirantis.com/blog/how-do-i-create-a-new-docker-image-for-my-application/)
* [stackoverflow install-r-packages-using-docker-file](https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file)
* [stackoverflow verify-r-packages-installed-into-docker-container](https://stackoverflow.com/questions/46902203/verify-r-packages-installed-into-docker-container)
* [stackoverflow upload-local-files-to-docker-container](https://stackoverflow.com/questions/26500174/upload-local-files-to-docker-container?noredirect=1&lq=1)
