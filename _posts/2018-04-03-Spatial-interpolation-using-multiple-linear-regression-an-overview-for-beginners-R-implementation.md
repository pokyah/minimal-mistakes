---
title: "Spatial interpolation using multiple linear regression : an overview for beginners (R implementation)"
header:
  og_image: /assets/images/spatial_multiple_regression.jpg
comments: true
toc: false
toc_label: "Table des matières"
toc_icon: "cog"
categories:
  - howTo
  - synthesis
tags:
  - statistics
  - method
  - r
  - modeling
  - geomatic
  - weather
  - interpolation
  - standard
---

The AGROMET Project lead by the Walloon agricultural research center ([CRA-W](http://www.cra.wallonie.be/fr)) requires to generate spatialized weather dataset. In this context, multiple spatialization methods will be tested and evaluated among which the __multiple regression__ technique.
This post provides an introductory material to the multiple regression modeling technique applied to spatial data. It is not a tutorial and is rather aimed at paving the way for beginners who want to take their first steps into in the field of applied geostatistics (with R) by defining key concepts and providing a lot of external resources worth reading !


<details>
  <summary>Full details about the AGROMET project</summary>
  <p>
<!-- the above p cannot start right at the beginning of the line and is mandatory for everything else to work -->
<h3> Context </h3>
The European directive 2009/128/CE imposes member-states to set up tools that allow for a more rational use of crop protection products. Among these tools, agricultural warning systems, based on crop monitoring models for the control of pests and diseases are widely adopted and have proved their efficiency. However, due to the difficulty to get meteorological data at high spatial resolution (at the parcel scale), they still are underused. The use of geostatistical tools (Kriging, Multiple Regressions, Artificial Neural Networks, etc.) makes it possible to interpolate data provided by physical weather stations in such a way that a high spatial resolution network (mesh size of 1 km2) of virtual weather stations could be generated. That is the objective of the AGROMET project.
<br>

<h3> Objectives </h3>
The project aims to set up an operational web-platform designed for real-time agro-meteorological data dissemination at high spatial (1km2) and temporal (hourly) resolution. To achieve the availability of data at such a high spatial resolution, we plan to “spatialize” the real-time data sent by more than 30 connected physical weather stations belonging to the PAMESEB and RMI networks. This spatialization will then result in a gridded dataset corresponding to a network of 16 000 virtual stations uniformly spread on the whole territory of Wallonia.
These “spatialized” data will be made available through a web-platform providing interactive visualization widgets (maps, charts, tables and various indicators) and an API allowing their use on the fly, notably by agricultural warning systems providers. An extensive and precise documentation about data origin, geo-statistic algorithms used and uncertainty will also be available.

</p></details>

## Spatialization definition

Spatialization or spatial interpolation derives a __continuous surface__ from values measured at discrete locations to predict values at any location in the interest zone.
The global objective is to produce the most accurate surface from existing sample data as well as characterizing the error and variability of the predicted data.

 In the chapter *The principles of geostatistical analysis*  of the [Using ArcGis Geostatistical analyst](http://dusk2.geo.orst.edu/gis/geostat_analyst.pdf), K. Johnston gives an efficient overview of what spatialization is and what are the two big groups of techniques (deterministic and stochastic). The book also provides a glossary of recurrent geostatistical terms (another useful one is available on Pr. D.E. Meyers [personal page](http://www.u.arizona.edu/~donaldm/homepage/glossary.html)).

 The choice of the method depends on several factors which are all associated with certain __assumptions that have to be fulfilled__ in order to be applied. However, most spatial interpolation methods can mathematically be reduced to basically the same principles. Therefore, most of the applications follow the same principles in order to meet the assumptions and criteria required by the methods. These criteria are based on the __assumption on second order spatial [stationarity](https://www.youtube.com/watch?v=K3eUIDu4NWw) or, for the geostatistical approach, the intrinsic hypothesis__.

 We will not present all of them in the context of this post to keep the focus on the multiple regression technique.


## Multiple linear Regression : key concept

No need to reinvent the wheel, let's borrow 3 definitions found in the literature :  

1. From Selva Prabhakaran's [r-statistics.co site](http://r-statistics.co/Linear-Regression.html) :
> Linear regression is used to predict the value of an outcome variable Y based on one or more input predictor variables X. The aim is to establish a linear relationship (a mathematical formula) between the predictor variable(s) and the response variable, so that, we can use this formula to estimate the value of the response Y, when only the predictors (Xs) values are known.

2. In his comprehensive [litterature review](https://www.snap.uaf.edu/sites/default/files/files/Interpolation_methods_for_climate_data.pdf), R. Sluiters from the KNMI defines multiple regression as follows :  
> Linear regression expresses the relation between a predicted variable and one or more explanatory variables. In its simples form a straight line is fitted through the data points. Linear regression models are most often global interpolators. Linear regression models are deterministic, but by considering some statistical assumptions about the probability distribution of the predicted variable the method becomes stochastic. In that case the standard error can be calculated, the inference about the regression parameter and the predicted values can be assessed and the prediction accuracy can be calculated. For deterministic linear regression models the assumption is that the regression model could be interpreted on the basis of physical reasons, for stochastic linear regression models a normal distribution and spatial independence is also assumed. No extrapolations are allowed from the theoretical perspective. Ancillary data can be included using multiple regression. For deterministic linear regression models the measure of success is through cross validation. For stochastic linear regression models it can be measured by the explained variance and the regression standard error.

3. In their paper (from which the Agromet project was inspired) *Decision Support Systems in Agriculture: Administration of Meteorological Data, Use of Geographic Information Systems(GIS) and Validation Methods in Crop Protection Warning Service*, [Racca et al. 2011](https://www.intechopen.com/books/efficient-decision-support-systems-practice-and-challenges-from-current-to-future/decision-support-systems-in-agriculture-administration-of-meteorological-data-use-of-geographic-info) present multiple regression in these terms:  
> The general purpose of multiple regressions (the term was first used by Pearson, 1908) is to learn more about the relationship between several independent or predictor variables and a dependent or criterion variable. MR is an interpolation method that allows simultaneous testing and modeling of multiple independent variables (Cohen, et al., 2003). Parameters that have an influence on temperature and relative humidity, e.g. elevation, slope, aspect, can therefore be tested simultaneously

  (*In this paper, the authors also briefly present why the Multiple Regression technique was chosen over other modeling techniques. A more detailed explanation of the comparative study between the various techniques is available in the companion paper by [Zeuner et. 2007](https://onlinelibrary.wiley.com/doi/pdf/10.1111/j.1365-2338.2007.01134.x)*).

## Data prediction using multiple linear regression : workflow

### Building the model

In [Supervised machine learning](https://machinelearningmastery.com/supervised-and-unsupervised-machine-learning-algorithms/), the response variable is modeled as a function of predictors. To build the model you will need to construct a dataset made of predictors (e.g. elevation, latitude, longitude, soil occupation, aspect) and response variable (e.g. temperature, humidity, rainfall). You will most likely also need to inspect and clean your dataset (e.g. removing outliers, check for errors, treat any missing values) before building the model :

> [Garbage in, garbage out](https://en.wikipedia.org/wiki/Garbage_in,_garbage_out)

Once your dataset is prepared you can build your regression model. Each data-analysis software provides a set of functions to build such a kind of model (in R you do it with the `lm()` function).

### Evaluating the model - Linear Regression Diagnostics

Once the linear model is fitted, the mathematical formula to predict the response variable is obtained. However it is not enough to actually use this model ! Before using a regression model, you have to ensure that it is __statistically significant__. There are many indicators that you can use to evaluate the validity of a regression model, among which :

* Residual plot
* Goodness of fit
* Standard error of the regression
* p-value

To get a deep insight of these model diagnostic indicators, check these 2 excellent R-oriented posts about evaluating regression model outputs by [Felipe Rego](https://feliperego.github.io/blog/2015/10/23/Interpreting-Model-Output-In-R) and [Selva Prabhakaran](http://r-statistics.co/Linear-Regression.html). You can also have a quick look at this [page](https://www.otexts.org/fpp/4/4).

### Using the model and measuring its success (i.e. validation process)

Now that you have tested the validity of your model (i.e. your model is statistically significant), you can use it to make some predictions. But an important question then arises : how well your model performs at predicting the data at unknown locations ? To answer this question, you need to rigorously test your model performance as much as possible. This is done using a __cross-validation__ (CV) process.

From Robin Lovelace's *Geocomputation with R* [book](https://geocompr.robinlovelace.net/spatial-cv.html) :
> CV determines a model’s ability to predict new data or differently put its ability to generalize. To achieve this, CV splits a dataset (repeatedly) into __test__ and __training__ sets. It uses the training data to fit the model, and checks if the trained model is able to predict the correct results for the test data. Basically, cross-validation helps to detect over-fitting since a model that fits too closely the training data and its specific peculiarities (noise, random fluctuations) will have a bad prediction performance on the test data. However, the basic requirement for this is, that the test data is independent of the training data. CV achieves this by splitting the data randomly into test and training sets. However, randomly splitting spatial data results in the fact that training points are frequently located next to test points. Since points close to each other are more similar compared to points further away, test and training datasets might not be independent. The consequence is that cross-validation would fail to detect over-fitting in the presence of spatial autocorrelation

(*To understand the [importance of the autocorrelation concept](https://stats.stackexchange.com/questions/36145/linear-regression-and-spatial-autocorrelation), you could read the [Spatial regression models paragraph](http://rspatial.org/analysis/rst/7-spregression.html) of the *Spatial Data Analysis and Modeling with R* website*).

To assess how well a model performs at making its predictions actually good predictions, 2 CV methods are often presented :  
* (spatial) k-fold cross validation
* (spatial) leave-one-out (refs : [K. Le Rest](https://onlinelibrary.wiley.com/doi/pdf/10.1111/geb.12161) & [D.R. Roberts](https://davidrroberts.wordpress.com/2016/03/11/spatial-leave-one-out-sloo-cross-validation/))

How to know which one best fits your needs [(k-fold or leave-one-out)](https://stats.stackexchange.com/questions/154830/10-fold-cross-validation-vs-leave-one-out-cross-validation) ? The short answer is to use the leave-one-out method when you have a small amount of samples.

To check if the trained model is able to predict the correct results for the test data, [calculating the accuracy measures and error rates](http://r-statistics.co/Linear-Regression.html) allows to find out the prediction accuracy of the model.

In your analysis, you might try many variants of the same kind of modeling technique, for example, by adding or removing extra independent variables. In this case, you will need to establish a diagnostic of the measure of success of each of the variants investigated. There is no universal technique to compare these. You can grab some ideas to implement in your own work from the [Aertsen et al. 2010 paper](https://www.sciencedirect.com/science/article/pii/S0304380010000463) where they describe a multi-criteria decision analysis for model evaluation.


## R guidelines

Now that you have a better insight of what spatialization and multiple linear regressions are, it's time to get the job done and dive in some coding work with R !

### If you are totally new to programming with R...

Learning and mastering a new programming language might scare you as it seems as a very difficult goal to achieve. However, with the help of the Internet and the R community, you can quickly start to write your first R programs. You can learn through tutorials (like at [Datacamp](https://www.datacamp.com/courses/free-introduction-to-r)), blog posts (like the blog aggregator [R-Bloggers](https://www.r-bloggers.com/)), package documentation (on [CRAN](https://cran.r-project.org/)) and of course help forums like [Stackoverflow](https://stackoverflow.com/) which is where I spend a lot of time searching answers to my questions (most of the time already posted by others).  

### Why R ?

* R is open-source [(why it is important)](https://www.gnu.org/philosophy/shouldbefree.en.html)
* R is gaining more and more popularity. Mastering it can opens you [many job opportunities](https://thenextweb.com/offers/2018/03/28/tech-giants-are-harnessing-r-programming-learn-it-and-get-hired-with-this-complete-training-bundle/)

A good starting point to work with multiple regression analysis with R is [this](https://feliperego.github.io/blog/2015/03/12/Multiple-Linear-Regression-First-Steps) tutorial by Felipe Rego. On his excellent blog you will also find a detailed [post](https://feliperego.github.io/blog/2015/10/23/Interpreting-Model-Output-In-R) about regression model output interpretation.

(*A special version of spatial regression modeling is the Geographically weighted regression which is described in [this](https://rpubs.com/chrisbrunsdon/101305) R tutorial written by Pr. Chris Brundson*).

### Getting started with R for spatial data analysis
In the [Geocomputation with R book](https://geocompr.robinlovelace.net) by Robin Lovelace you will get all you need to get started with spatial data manipulation and analysis with R. The book tutorials make a heavy use of these libraries, and especially the new [sf package](https://edzer.github.io/UseR2017/) for spatial data analysis.

```R
library(sf)            # classes and functions for vector data
library(raster)        # classes and functions for raster data
library(spData)        # load geographic data
library(spDataLarge)   # load larger geographic data
```

### Useful R cheatsheets

* [dplyr](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) - Data manipulation
* [ggplot2](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf) - Data Visualization
* [Coordiante reference systems](https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf)

### Worth reading R spatial oriented blog
https://www.r-spatial.org/

## A note about coordinate reference systems (CRS) notations

### Geographic vs projected coordinate reference system (CRS)

* __Geographic CRS's__ identify any location on the Earth’s surface using two values — longitude and latitude
* __Projected CRS's__ are based on Cartesian coordinates on an implicitly flat surface. They have an origin, x and y axes, and a linear unit of measurement such as meters. All projected CRSs are based on a geographic CRS, and rely on map projections to convert the three-dimensional surface of the Earth into Easting and Northing (x and y) values in a projected CRS.

### Notations systems of CRSs

* [EPSG vs. proj4string notations](https://earthdatascience.org/courses/earth-analytics/spatial-data-r/understand-epsg-wkt-and-other-crs-definition-file-types/)

## Conclusion

Thanks to this post and all its references, you should now be able to start building a multiple regression spatial interpolation analysis based on your own data using R. If you need additional references, you could also check out this multiple linear regression [tutorial](https://www.statmethods.net/stats/regression.html) by R.I. Kabacoff.
