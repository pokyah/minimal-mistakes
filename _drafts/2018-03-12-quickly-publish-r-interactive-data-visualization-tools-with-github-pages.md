---
title: "Quickly publish your R interactive data visualisation tools with github pages (Leaflet example)"
header:
  overlay_image: /assets/images/r_docker.jpg
  og_image: /assets/images/r_docker.jpg
  caption: "Photo credit: [**pixabay**](https://pixabay.com)"
classes: "wide"
comments : true
toc: false
toc_label: "Table des matières"
toc_icon: "cog"
categories:
  - howTo
tags:
  - R
  - git
  - github
  - dataviz
  - webÓÓ
  - tools
  - english
  - standard
  - gis
---

As a data scientist, you certainly produce a bunch of tables, plots, maps and many other outputs to let your data "speak for itself". This is your core business and I'm sure you do it pretty well ! But when it comes to make this data available to your target audience things can quickly get more frustrating. **Say more - You often struggle with exporting options, formats,**

Thanks to the advances in web technologies and the development of powerful Javascript librairies, our web-browsers are now able to render impressive datavisualation apps and presentations. These last years, the R community has developed ::countless:: libraries (leaflet, shiny, plotly, knitr, etc) that take advantages from these advances in order to allow you to easily transform your analysis outputs in intelligible and eye catching webapps. We will see how to combine these R libraries capabilities with github pages in order to quickly make your top notch data visulation app available to your audience (and don't be modest : to the world)

Before we dig into the topic, it is important to understand what a webpage actually is ! So here is a short recap !

## How does a webpage works (in simple terms) ?

When you enter an address (URL) in your web-browser, your web-browser send a request to the hosting server. In returns, the server sends to your web-browser the requested content in the form of an HTML file. HTML is a kind of formatted text contained between specific tags (headings, bold, tables, etc) and that can eventually link to other documents. Your web-browser translate this non-human readable HTML to its human friendly version. ::give example::
This HTML can be "upgraded" by 2 other ::languages:: also supported by your web-broser : CSS and Javascript. While CSS is responsible for the styling (font color, background color, font-size, etc), the Javascript manages the interactivity (like zooming on a map) and the actions that can be performed by/on the web-page (like actions triggered by clicking on a button. e.g. calling a server to get data) ::give code example::. And that's it ! With these 3 ingredients, you can build a webpage.
An important thing to get in mind is the difference between a [static](https://en.wikipedia.org/wiki/Static_web_page) and a dynamic web-page !

So, when it comes to static content, with no need for a server to load additionnal information on the fly, you can host your webpages.

## What is Github pages

For those who are familiar with the version control software git (if you don't know what [git](https://git-scm.com/) is, you really **must** get to [know it](http://r-bio.github.io/intro-git-rstudio/) to impressively speed up your (R) code development work), you most probably already knows [Github](https://github.com/) as a git repository hosting service. Github offers many other possibilities : collaborative code developement, issues tracking and discussions, project presentation page, wiki, [Jekyll blog](https://jekyllrb.com/) and various integrations with other web services thanks to their API. Among these features, exists [Github pages](https://pages.github.com/) which is intended to allow you to publish **static** pages without the need to run our rent your own webserver. **So, as long as your dataviz product does not require any running backend (be it in node.js, Python, R, Java, Ruby, etc), you can host it on Github pages !** This means that [R Shiny apps](https://shiny.rstudio.com/) can not be hosted on github pages. But yeah, you can still publish [leaflet](https://rstudio.github.io/leaflet/) maps, [plotly](https://plot.ly/r/) graphs and [knitr](https://yihui.name/knitr/demo/minimal/) html reports ! That already opens up a wide variety of possibilities !

In simple terms :  

__Github pages turns your repository containing your source file hosted at `https://github.com/yourUserName/repositoryName` to a rendered web-page hosted at `https://yourUserName.github.com/repositoryName`__  

## How to publish your R outputs to Github pages ?

The workflow is as follows (more details with an example here below) :

1. Exports your R analysis outputs to a specific folder
2. Make this folder a git repository
3. Create a `gh-page` branch
3. Commit your changes
4. Push to Github
5. Visit your published work at `https://yourGithubUsername.github.io/repositoryname`

For the sake of :::: we will describe these 5 steps with a ::effective:: example.   

### First things first : create an online repository at Github

Once you have created a Github account, go to `https://github.com/yourUserName`, click on the "*+*" button and select "*new repository*". Give it the name "mywebapps" (or whatever you want) :  

![new_repository]({{ "/assets/images/new_repository.png" | absolute_url }})  

Eventually add a description and choose an existing .gitignore file and license and click on "*create repository*". You are now on your Github mywebapps repository page. Click on the green button "*Clone or download*", then on the link "*use HTTPS*" (you can of course also use [SSH](https://help.github.com/articles/connecting-to-github-with-ssh/) if you know what it means) and copy the link provided in the text box :  

![clone_repo]({{ "/assets/images/clone_repo.png" | absolute_url }})

### Sync (i.e. clone) this repository to your computer and create the gh-pages branch for auto-publishing

Let's create a folder called `dev` under your home directory into which we will clone the online repository by pasting its addresse as a parameter of the git clone command in your terminal ([more about the use of git with the command line](http://dont-be-afraid-to-commit.readthedocs.io/en/latest/git/commandlinegit.html)) :

```bash
$ mdkir ~/dev
$ cd ~/dev
$ git clone https://github.com/yourUserName/mywebapps.git
```
Enter your Github username and password, press enter and your `dev` folder now contains a `mywebapps` folder which is a git repository (i.e. the root of the `mywebapps` folder contains a hidden `.git` folder that manages all its git features). Let's check this :

```bash
$ ls -al
```
If everything went OK, you should see the mywebapps and the .git folder listed in your terminal. Now, let's create a specific branch (more about branches [here](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)) for automatic hosting and publishing of your webapps code ! Github uses `gh-pages` as the default branch name to create and hosted web-page version of your repository. So let's create it and use it !  

```bash
$ git checkout -b gh-pages
```

### Code your interactive leaflet map with R !  

Your are now ready to build some git versioned code and make it ready to be published on the web through the magic of git and Github pages !

As example, we will use R to build an interactive leaflet map that displays two layers : A DEM of Belgium and a [WMS](https://en.wikipedia.org/wiki/Web_Map_Service) layer of currently observed precipitations provided by the KNMI. [Download](::::) the source of the `demo-map.R` script and save it under your `mywebapps` folder. Open your terminal inside this folder and execute the `demo-map.R` script :  

```bash
$ Rscript demo-map.R
```

The script should has produced a `demo-map.html` file containing the interactive map plus a `demo-map_files` folder containing all the required javascript libraries required to make it interactive. It has also saved 3 files resulting from the download of the raster elevation data.

If you get errors it might be because you don't have the required libraries installed. To avoid such problems, simply install the missing libraries (if you are adventurous, you can have a look at my [R + Docker tutorial](::::) !)

Your interactive web map is now built ! You can locally open it with your browser by right-clicking on the `demo-map.html` file and choose to open it with your favorite browser. Check the various buttons to be sure that everything works as expected. What is important to know is that this impressive web app does not need any backend to run. Once the page is loaded, everything works inside your browser thanks to HTML, CSS and Javascript ! *Ok, but how is it then possible for me navigate and zoom in every part of the world without having to run a server to serve the base layer tiles* you will tell ? The trick is that leaflet render tiles stored on a third party tiles provider (i.e. a web-server). It is actually a simple line of Javascript that does the magic of calling the tiles and serving these to your browser. If you turn your wifi off, you will see that you won't be able anymore to see the base layer while navigating the world.

### Publish it online using gh-pages !

Head back to your terminal (opened in your `webapps` folder) and save and publish your work to Github :

```bash
$ git add .
$ git commit -m "adding interactive demo-map.html"
$ git push --set-upstream origin gh-pages
```
Now the source code of your interactive map (both the `demo-map.R` and the `demo-map.html` ) has been pushed to `https://github.com/yourUserName/mywebapps` and your hosted interactive map is rendered at `https://yourUserName.github.io/mywebapps/demo-map.html` !

Great ! Simply share this link to your audience and you are done ! Your interactive webmap can ::make them understand your work::

Sometimes github pages struggles to rebuild your rendered page when you commit your changes. If this happens, you can force github pages to rebuild it using these two git instructions (solution found on [stackoverflow](https://stackoverflow.com/questions/24098792/how-to-force-github-pages-build)) :  

```bash
$ git commit -m 'rebuild pages' --allow-empty
$ git push origin gh-pages
```

## Some tricks to improve this workflow

If you want to showcase multiple interactive data visualizations outputs, it might be cool to have a webpage that presents all of them so that your visitors can easily discover your work. The simplest solution is to create an `index.html` file that lists all your outputs and that is located at the root of your `mywebapps` directory. Doing so, while your visitors head at https://yourUserName.github.io/mywebapps, the `index.html` will act as a home page and your visitors will receive a listing of the outputs you have add to your `mywebapps` repository.

You have two options to maintain this directory listing `index.html` file updated. Either you manually add a new line for each new interactive output you have published, either you run a bash script that build the `index.html` file for you (preferred).

### bash script to build the directory listing index.html file

So each time you have built a new interactive output, run the following script to make it listed on your mywebapps homepage (i.e. `index.html`). 

## Conclusion







to facilitate   users can benefit of nice libraries to  


For those who are not so familiar with web technologies, let's quickly see how a web page works.
Most of the times these apps need to communicate with



## Online publishing for seamless communication

## What is github pages ?



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

In most of the cases, before running an image, you will need to customise it so that it reflects your own needs. __Customising an image__ requires to __edit its Dockerfile__ and rebuild the image as mentioned earlier.

To keep __git versioned Dockerfile -s__ of your images, you can push them to [Github](https://github.com/). Hosting your Dockerfile on Github offers you a nice feature : [automated builds](https://docs.docker.com/docker-hub/builds/). Once enabled, each time you push a modification of your Dockerfile to Github, Docker will rebuild your image and make it ready to be pulled by others.

You can share this very specific R environment with your co-workers. First, share them this tutorial and then share your image. For this purpose, you have two solutions :

1. Sending them the corresponding Dockerfile and let them build the image on their machine (more complex)
2. Upload your image to Docker hub (manually or with the automated build feature) and simply send them the name of your image so that then can you it immediately use it with the `run` command

## Conclusion

You have learned how to use Docker to run your own customized R isolated environment inside a container and how to share this specific environment with your colleagues.

In a next tutorial, I'll explain you how to run a container able to connect to an external postgreSQL database.  

## Future readings

* [Andrew Heiss tuto](https://www.andrewheiss.com/blog/2017/04/27/super-basic-practical-guide-to-docker-and-rstudio/)
* [Dirk Eddelbuettel presentation](http://dirk.eddelbuettel.com/papers/useR2015_docker.pdf)
* [Brian J. Knaus CLI tuto](https://knausb.github.io/2017/06/running-r-in-docker/)
* [R-Blogger post](https://www.r-bloggers.com/r-3-3-0-is-another-motivation-for-docker/)

### Dockerfile customization

* [R package to create Dockerfile]( http://o2r.info/2017/05/30/containerit-package/)
* [tutorial from ropenscilabs](http://ropenscilabs.github.io/r-docker-tutorial/05-dockerfiles.html)
* [mirantis blog tutorial](https://www.mirantis.com/blog/how-do-i-create-a-new-docker-image-for-my-application/)
* [stackoverflow install-r-packages-using-docker-file](https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file)
* [stackoverflow verify-r-packages-installed-into-docker-container](https://stackoverflow.com/questions/46902203/verify-r-packages-installed-into-docker-container)
* [stackoverflow upload-local-files-to-docker-container](https://stackoverflow.com/questions/26500174/upload-local-files-to-docker-container?noredirect=1&lq=1)
