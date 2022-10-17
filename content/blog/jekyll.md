---
title: "Static site generators part 1 - Jekyll"
date: 2020-11-09T14:39:18Z
draft: false
tags: ["jekyll", "static site generator", "arduino"]
---
Recently I did a low-tech hamstermonitoring setup with Arduino and Grafana. I decided the end result was fun enough to share, and did a blog post/webpage of it:
https://oversizedhat.github.io/hamstermonitor

Likely I spent as much time on the webpage as I did on the project itself so I thought why not go all the way and also write about the experience using Jekyll, which was my first time testing out a static site generator. One out the gazillion to choose from (https://jamstack.org/generators\).

I choose Jekyll purely based on the fact that it seemed dead simple with GitHub pages, which felt like a good idea as the project was in Github and my requirements where minimal, and something like this:
- Easy to work with
- Responsive UI out of the box
- Site needs to be okeyish looking without me having to put effort on it (theme)
- Cheap or free

#### The process
Jeykll was indeed easy to setup and work with, especially considering my limited set of "requirements". If you are familiar with readme markdown commonly used for repository README.md files you can make a basic site simlar to how you make a word document. This site looks like it gives a good overview of markdown syntax: https://www.markdownguide.org/basic-syntax (and btw it seems that site itself is built using Jekyll).

Besides this you need some basic familiarity with version control systems, git specifically. At least if you want to use GitHub Pages for hosting.

##### There are tons of guides out there so I will spare you another...

This looks like a good guide for setting it up:
https://guides.github.com/features/pages/
and this looks like good knowledge base from taking it further than I did: https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/about-github-pages-and-jekyll

##### Here are however some of my own reflections/additions to the guides
- You will need to find a good way to work with it locally and doing so requires Ruby and Jekyll in your dev environment. The usual guides will show you how to install it on any system but if you are not a Ruby developer (or dislike polluting your environment) you might as well run Jekyll in a docker container. I found this neat Jekyll docker wrapper by Brett Fisher and made slight modification to it adding a "--watch" (flag https://github.com/oversizedhat/jekyll-serve\) to get live reload in the browser when you edit your files.
``` sh
$ docker-compose up :thumbs_up:
```
----
To keep it real simple stick to one of the GitHub supported themes: https://pages.github.com/themes/

``` yml
# in _config.yml
theme: jekyll-theme-minimal
```
----
Add the emoji plugin to make \:thumbs_up\: = :thumbs_up:

``` yml
# in _config.yml
plugins:
  - jemoji
```
----
Hook up your to your Google Analytics account

``` yml
# in _config.yml
google_analytics: "UA-XXXXXXXXXX"
```
----
Videos, for example, are'nt covered out of the box so you need to embed some html along with your markdown, and the same concept applies for anything custom that you cannot achieve with the markdown alone.

``` html
<!-- _includes_/video_embed.html-->
<div style="width:100%">
<video controls style="width:100%">
    <source src="assets/my_dang_cool_vid.mp4" type="video/mp4">
    <p>Your browser doesn't support HTML5 video. Here is
       a <a href="assets/my_dang_cool_vid.mp4">link to the video</a> instead.</p>
</video>
</div>
```
And include it it in the markdown:
``` markdown
## Check out my dang **cool** vid:
{% include video_embed.html %}
```
----
#### Takeaways
- This was the result: https://oversizedhat.github.io/hamstermonitor/
- It was indeed an easy setup. No time wasted on boilerplates or thinking about workflows and frameworks.
- The theme concept is indeed nice and allowed me to effectively postpone the decision to select a theme until the last minute basically. I really like that, as it allowed me to decide on a theme/style when I was finished with the content, and not the other way around.
- It adapts nicely according to the screen size/device.
- But would I take it further with Jekyll? I dont think so as it would mean investing time in Ruby and it's eco systom of RybyGems. I have far too little experience to begin downtalking Ruby, but just looking at programming language trends alone I doubt it's the right horse to bet on.
