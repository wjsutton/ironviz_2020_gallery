<h1 style="font-weight:normal">
  Ironviz 2020 Gallery
</h1>


[![Status](https://www.repostatus.org/badges/latest/wip.svg)]() [![GitHub Issues](https://img.shields.io/github/issues/wjsutton/ironviz_2020_gallery.svg)](https://github.com/wjsutton/ironviz_2020_gallery/issues) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/wjsutton/ironviz_2020_gallery.svg)](https://github.com/wjsutton/ironviz_2020_gallery/pulls) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

A Gallery of 2020 Ironviz submissions found on Twitter. Offshoot from [wjsutton/datafam](https://github.com/wjsutton/datafam) for reproducability.
 
:construction: Repo Under Construction :construction: 

[Twitter][Twitter] :speech_balloon:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[LinkedIn][LinkedIn] :necktie:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[GitHub :octocat:][GitHub]&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[Website][Website] :link:


<!--
Quick Link 
-->

[Twitter]:https://twitter.com/WJSutton12
[LinkedIn]:https://www.linkedin.com/in/will-sutton-14711627/
[GitHub]:https://github.com/wjsutton
[Website]:https://wjsutton.github.io/


### :a: About

This project involves building a HTML gallery webpage of Tableau Public ironviz 2020 submissions on Twitter. Identified by the hashtag "#ironviz" or "#ironviz2020" and a Tableau Public. 

This project can be divided up into 3 main phases of work

1. Pulling #ironviz and #ironviz2020 tweets from Twitter
2. Identifying Tableau Public links and obtaining dashboard images
3. Building HTML code to displaying images in a grid

### :checkered_flag: Getting Started

This project was built using R version 3.6.2, earlier versions are untested.

This project requires Twitter API access for pulling tweets from Twitter, a guide on how to can be found with the rtweet library docs here: [https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html](https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html)

#### :package: Packages

This project utilises the following R packages:

- rtweet
- dplyr
- longurl
- stringr
- tidyr

### Phase :one: Pulling Tweets from Twitter

The function `function_get_and_save_tweets.R` builds from the rtweet function `rtweet::search_tweets()` by merging the dataset with an existing file and replacing any recurring tweets with the latest tweet. Tweets are then saved as an .RDS file.

`function_get_and_save_tweets.R` takes the arguments:

- "text" the term you want to search Twitter for
- "n" the amount of tweets (statuses) you want to return
- "path" the file path where to store the tweets

Please note there is are limitations on `rtweet::search_tweets()` and hence `function_get_and_save_tweets.R`:

- Only returns data from the past 6-9 days. 
- To return more than 18,000 statuses you will need to rework the function so that `rtweet::search_tweets()` inludes the clause "retryonratelimit = TRUE".

#### Manual workaround for tweets not pulled from API

From running this project I have noticed that some tweets including the term '#ironviz' aren't captured by `function_get_and_save_tweets.R` and additionally didn't appear on the #ironviz feed. These can be added manually by finding the status_id of the tweet and running it in the script `ironviz_get_missed_tweets.R`. 

To get the status _id of the tweet you need to click into the tweet to see the url

e.g. https://twitter.com/jrcopreros/status/1290738849530941446

where 1290738849530941446 is the status_id

Other cases this script was used for:

- adding in older tweets that were over 10 days old when I started the project (and so missed by `rtweet::search_tweets()`)
- adding comments where the user posted a tweet about their ironviz then in the comments gave the Tableau Public link


### Phase :two: Identifying Tableau Public Links

### Phase :three: Building HTML Gallery Page 