<h1 style="font-weight:normal">
  Ironviz 2020 Gallery
</h1>


[![Status](https://www.repostatus.org/badges/latest/wip.svg)]() [![GitHub Issues](https://img.shields.io/github/issues/wjsutton/ironviz_2020_gallery.svg)](https://github.com/wjsutton/ironviz_2020_gallery/issues) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/wjsutton/ironviz_2020_gallery.svg)](https://github.com/wjsutton/ironviz_2020_gallery/pulls) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

A Gallery of 2020 Ironviz submissions found on Twitter. An offshoot from [wjsutton/datafam](https://github.com/wjsutton/datafam) for reproducibility.
 
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
- "n" the number of tweets (statuses) you want to return
- "path" the file path where to store the tweets

Please note there is are limitations on `rtweet::search_tweets()` and hence `function_get_and_save_tweets.R`:

- Only returns data from the past 6-9 days. 
- To return more than 18,000 statuses you will need to rework the function so that `rtweet::search_tweets()` inludes the clause "retryonratelimit = TRUE".

#### Manual workaround for tweets not pulled from API

From running this project I have noticed that some tweets including the term '#ironviz' aren't captured by `function_get_and_save_tweets.R` and additionally didn't appear on the #ironviz feed. These can be added manually by finding the status_id of the tweet and running it in the script `ironviz_get_missed_tweets.R`. 

To get the status _id of the tweet you need to click into the tweet to see the URL

e.g. https://twitter.com/jrcopreros/status/1290738849530941446

where 1290738849530941446 is the status_id

Other cases this script was used for:

- adding in older tweets that were over 10 days old when I started the project (and so missed by `rtweet::search_tweets()`)
- adding comments where the user posted a tweet about their ironviz then in the comments gave the Tableau Public link


### Phase :two: Identifying Tableau Public Links

#### Outline

Using the data collected in Phase 1, we are looking for URLs under the column urls_expanded_url that look like either of these:

Case 1. https://public.tableau.com/views/dashboard_name/tab_name?.......

Case 2. https://public.tableau.com/profile/profile_name#!/vizhome/dashboard_name/tab_name

There are a few issues we'll run into:

1. Tweets that aren't ironviz submissions but 'inspired by' posts
2. Submission URLs that link to a profile rather than a viz
3. Short/compressed URLs

From these links, we'll extract a screenshot of the dashboard to add to the gallery. Lastly, we'll write a .csv file containing the screenshot, link to the submission tweet and any other data we'll need for the gallery page.

#### Tackling Issues  

Issues 1 & 2 were identified midway through the project while I was updating the page every few hours with new submissions. The issues were spotted manually and workarounds were implemented to fix the page quickly rather than provide a coded solution that would work for a future dataset.

1. Tweets that were inspired by posts were identified manually and filter out from the dataset, e.g.
```
ironviz <- ironviz %>% filter(status_id != '1286048757071646720')
```
A less manual solution may be achieved by work along the lines of identifying tweets containing the word 'submission' and compared against 'inspired' but there's no guarantee of this given the nature of free-text datasets.

2. URLs that are profiles rather than vizs won't be recognised and end up in a separate data frame used for checking. Again manually this means checking the profile and find the correct viz (matching it to the tweet) and replacing the URL in the dataset, e.g.

```
df$urls_expanded_url <- gsub('^https://public.tableau.com/profile/aashique.s#!/$'
                             ,'https://public.tableau.com/profile/aashique.s#!/vizhome/LifeofaSickleCellWarrior/LifeofaSICKLECELLWARRIOR'
                             ,df$urls_expanded_url)
```
Another less manual approach would be to make a script that found the most recently published viz on the profile and include that or match the text in the tweet to the dashboard title, again no guarantee this method would work 100% of the time, especially if the tweet was posted days or weeks in the past.

3. Short URLs can be found in the dataset, despite being under the column `urls_expanded_url`. Short URLs are identified as a URL with less than 35 characters. Using the `longurl` package these URLs can be expanded and are then fed back into the dataset, e.g.

```
# Expand short urls
short_urls <- df$urls_expanded_url[nchar(df$urls_expanded_url)<35]
expanded_urls <- unique((longurl::expand_urls(short_urls)))

# Join longurls back to original dataset and replace if a longurl is available
url_df <- dplyr::left_join(df,expanded_urls, by = c("urls_expanded_url" = "orig_url"))
df$urls <- ifelse(!is.na(url_df$expanded_url),url_df$expanded_url,url_df$urls_expanded_url)
```
Lastly, some urls failed to be expanded by longurl, these were manually opened and replaced with the correct link in a similar fashion to issue 2.

```
df$urls_expanded_url <- gsub('^http://shorturl.at/fGLMS$'
                             ,'https://public.tableau.com/views/LEADINGCAUSESOFDEATH-ABORIGINALANDTORRESSTRAITISLANDERVS_NON-INDIGENOUS/Dashboard1?:language=en&:display_count=y&:origin=viz_share_link'
                             ,df$urls_expanded_url)
```

#### Identifying Tableau Public Links

Tableau Public viz submissions come in two forms:

Case 1. https://public.tableau.com/views/dashboard_name/tab_name?.......

Case 2. https://public.tableau.com/profile/profile_name#!/vizhome/dashboard_name/tab_name

Using regex we can match any urls of either of these forms

**Case 1**
```
pattern1 <- "^https://public\\.tableau\\.com/views(?:/.*)?$"
```
In English:
Find any link that starts 'https://public.tableau.com/views'
Followed by a "?:/" 
Then any characters
Ending with "?" 
*Note that R requires any use of \ to be escaped with another backslash, so \s would become \\s*

**Case 2**
```
pattern2a <- "^https://public\\.tableau\\.com/profile(?:/.*)?$"
pattern2b <- "^(.*)vizhome(.*)$"
```
In English:
Find any link that starts 'https://public.tableau.com/profile'
Followed by a "?:/" 
Then any characters
Ending with "?" 
AND also contains the term 'vizhome'
*Note that R requires any use of \ to be escaped with another \, so \s would become \\s*

#### Converting Links into Screenshots

This is a Tableau Public link:
https://public.tableau.com/profile/fredfery#!/vizhome/ThefailingoftheFirstworldcountriesagainstCovid-19ironviz2020/Manyfirstworldleadershavefailedintheirresponsetocoronavirus

This is a screenshot of the link:
https://public.tableau.com/static/images/Th/ThefailingoftheFirstworldcountriesagainstCovid-19ironviz2020/Manyfirstworldleadershavefailedintheirresponsetocoronavirus/1.png

The form is like this:
https://public.tableau.com/static/images/da/dashboard_name/tab_name/1.png
where da is the first two letters of the dashboard name.

In the script `ironviz_find_submissions.R` I take a list of URLs
1. check which type of Tableau Public link 
2. using `str_locate` from `stringr` identify start and endpoints 
3. insert 'static/images', '/da/' and '/1.png' to convert the link

##### Creating Tweet Links

Thankfully this is much more straightforward as we have the elements divided up, we just need to paste them all together. 

To make a tweet link like: "https://twitter.com/screen_name/status/status_id"

We paste the elements together, e.g.
```
ironviz_df$tweet_link <- paste0('https://twitter.com/',ironviz_df$screen_name,'/status/',ironviz_df$status_id)
```

To end we write the csv file locally.


### Phase :three: Building HTML Gallery Page 

For this final section requires three files: `ironviz.html`, `image_grid.css`, & `ironviz_build_html.R`

`ironviz.html` is a static HTML file which can be regenerated using an R script, `ironviz_build_html.R`. This allows any new images to be added to the gallery page automatically and it refreshes the order of the images so each entry has a fair chance of being top of the page for a while.

`image_grid.css` is our style sheet referenced in `ironviz.html` it takes our list of images and arranges them in a grid up to 4 images wide depending on the device viewing the page.

`ironviz_build_html.R` takes our .csv file of submission tweets from Phase 2, randomises their order and pastes them into a HTML file. As most of the HTML doesn’t change except the images and the number of images quoted I’ve pre-made these files and save them as .txt files under the folder `html`.
Reading/writing HTML files in R can be accomplished using the readLines & writeLines functions.

```
# Reading
x <- file(“path/to/file.txt”)
text <- readLines(x)

# Writing
y <- file(“path/to/file.txt”)
writeLines(text, y)

# Remembering to close the file connections after use:
close(x)
close(y)
```
Using these functions we will update the blurb with the number of vizs,
```
blurb_temp_file <- file("html/blurb_template.txt")
blurb <- readLines(blurb_temp_file)
blurb <- gsub('NUM_OF_VIZZES',number_of_vizzes,blurb)

blurb_file <- file("html/blurb.txt")
writeLines(blurb, blurb_file)
close(blurb_file)
close(blurb_temp_file)
```
write the list of images,
```
fileConn <- file("html/img_list.txt")
writeLines(ironviz_links, fileConn)
close(fileConn)
```
And write the entire HTML file.
```
# Header + blurb + images + footer = html file

header_file <- file("html/header.txt")
blurb_file <- file("html/blurb.txt")
images_file <- file("html/img_list.txt")
footer_file <- file("html/footer.txt")

header <- readLines(header_file)
blurb <- readLines(blurb_file)
images <- readLines(images_file)
footer <- readLines(footer_file)

full_html <- c(header,blurb,images,footer)

html_file <- file("gallery/ironviz.html")
writeLines(full_html, html_file)
close(html_file)

close(header_file)
close(blurb_file)
close(images_file)
close(footer_file)
```

To test the gallery page you can open the HTML file in a Chrome web browser, or by using the Live Server extension from VS Code and done!


![](ironviz_gallery_image.PNG)