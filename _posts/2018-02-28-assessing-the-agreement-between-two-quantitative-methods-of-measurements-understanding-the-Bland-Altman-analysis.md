---
title: "Assessing the agreement between two quantitative methods of measurements : understanding the Bland Altman analysis"
classes: "wide"
toc: false
toc_label: "Table des matières"
toc_icon: "cog"
categories:
  - howTo
tags:
  - statistics
  - method
  - r
  - standard
---

Attempting to statistically assess the agreement between two quantitative methods of measurements requires validation tool. 

A widely adopted tool is the correlation study computed with one method as predictor and the other as response variable (e.g. see [this](http://onlinelibrary.wiley.com/doi/10.1002/wea.2158/pdf) publication that compares temperature measurements obtained by two different kind of weather stations at the exact same location).  

However, as described by [Giavarina (2015)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4470095/), correlation study should not be used to asses the comparatibility or agreement between two instruments (because it studies the relation between one variable and the other and not the __differences__).

In 1986, [Bland and Altman](https://www-users.york.ac.uk/~mb55/meas/ba.pdf) have proposed an analysis that quantifies the agreement between two quantitative sets of measurements of the same parameter by statistically studying the behaviors of the differences between paired measurements. This analysis is useful to determine if a method can be used interoperably with another without the need of a correction model

## Some words about measurements difference

From [Giavarina (2015)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4470095/) :

> An ideal model would claim that the measurements obtained by one method or another gave exactly the same results. So, all the differences would be equal to zero. But any measurement of variables always implies some degree of error. Even the mere analytical imprecision for method A and method B generates a variability of the differences. However, if the variability of the differences were only linked to analytical imprecision of each of the two methods, the average of these differences should be zero. This is the first point required to evaluate the agreement between the two methods: look at the average of the differences between the paired data.


## Quick presentation of the Bland Altman analysis

Their graphical method plots the __differences between the two paired measurements__ against __the averages of these measurements__.

Here is an examplative Bland-Altman plot : 
![blandAltman plot example]({{ "/assets/images/blandAltman.png" | absolute_url }})

*[Source](https://cran.r-project.org/web/packages/BlandAltmanLeh/vignettes/Intro.html)*

Horizontal lines are drawn at the __mean difference__ (thick red line), and at the upper and lower __limits of agreement__ (thick blue lines) together with their 0.95 [confidence interval - CI](https://www.mathsisfun.com/data/confidence-interval.html) (thin lines). 

* The __mean difference__ is the estimated __bias__. Its 0.95 CI illustrates the magnitude of the systematic difference. 

* The __limits of agreement__ measure the __random fluctuations around the mean difference__. These correspond to the mean difference plus and minus 1.96 times the standard deviation of the differences. These lines tell us how far apart measurements by 2 methods were more likely to be for most individuals.

* __The Maximum allowed difference between methods (D)__ is an arbitrary treshold which value must be chosen so that differences in the range −D to D are considered irrelevant or neglectable in the context of your study.

## Interpretation guidelines

The plot allows to infer some information about the agreement of two methods : 

* If the line of equality (horizontal line at 0) is not in the mean difference 0.95 CI, there is a __significant systematic difference__.

* If the mean value of the difference differs significantly from 0, this indicates the presence of a __fixed bias__.  This bias can be adjusted for by subtracting the mean difference from the the measurements of the method we want to determine if it can substituate the other. 

* If the limits of agreement do not exceed the maximum allowed difference, the two methods are considered to be __in agreement__. They are therefore considered as interchangeable. This interpretation does not however takes CI into accounts (see next point).

* If the maximum allowed difference is higher than the 0.95 upper limit of the higher limit of agreement and if the maximum allowed difference is lower than the 0.95 lower limit of the lower limit, we are __95% certain that the methods do not disagree__ (if the differences are [normally distributed](https://rexplorations.wordpress.com/2015/08/11/normality-tests-in-r/)).

* If the scatter presents a trend, there is a relationship between the differences and the magnitude of measurements (__proportional error/bias__). The existence of such a proportional bias indicates that the methods do not agree equally through the range of measurements. To formally evaluate this relationship, one could compute a regression model between the difference and the average of the 2 methods. 

## Some usage precautions

The Bland and Altman analysis allows to determine if the bias is significant (e.i. the line of equality is not within the confidence interval of the mean difference) __but__ it does not allow to say if the agreement is sufficient or suitable for your instruments interoperability.  

This analysis modestly quantifies the bias and a range of agreement within which 95% of the differences between one measurement and the other are included.

Only the __context of your analysis__ could define whether the agreement interval is too wide or sufficiently narrow for your purpose. This is why you should arbitrary set the limits of maximum acceptable differences (limits of agreement expected) based on relevant criteria defined in the context of your analysis.


## Software implementation

I mainly work in R ([and you should too](https://www.r-bloggers.com/why-use-r-five-reasons/)). 
If you already do so, I would recommand you the excellent [BlandAltmanLeh](https://cran.r-project.org/web/packages/BlandAltmanLeh/vignettes/Intro.html) package that is sufficiently well document in order to perform your own Bland Altman analysis.


## See also

* [medcalc.org Bland Altman explanation page](https://www.medcalc.org/manual/blandaltman.php)
* [Bland Altman Wikipedia page](https://en.wikipedia.org/wiki/Bland%E2%80%93Altman_plot#/media/File:Bland-Alman_Plot_with_CI%27s_on_LOA.png)
* [a scientific paper that presents a use case of Bland Altman study in the context of temperature measurement](https://repository.uwl.ac.uk/id/eprint/2044/1/Amoako-Attah-Jahromi-2015-Method-comparison-analysis-of-dwellings-temperatures-in-the-UK.pdf)

