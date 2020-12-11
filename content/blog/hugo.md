---
title: "Static site generators part 2 - Hugo"
date: 2020-11-10T14:39:18Z
draft: false
tags: ["hugo", "static site generator"]
---
Compared to last post about Jekyll I wanted to take a static site a bit further and build my own personal website (this one) so the requirements I had were a bit more defined this time (well, in reality still just in my own head, but anyways). Hoping that I will spend some time on this website as well as ENJOY spending time on it I wanted something:

- Easy **and fun** to work with
- Responsible UI out of the box
- Site needs to look the way I want (without me having to put a lot of effort on it)
- Cheap or free
- Easy to extend in future
- Ideally something hip and popular, lets face it. We all want to be hip, and work with new stuff
- Ideally new for me so I learn something

Going back to https://jamstack.org/generators/ 

Looking at the top ones I think Next.js and Gatsby where the natural choices for me, with a decent amount of experience working with Nodejs, npm and React. Or maybe Nuxt or VuePress with Vue templates. 

**Gatsby:** Just opening https://www.gatsbyjs.com/ gave me the chills. With a landing page looking like a corporate website from the late 90s, and trying to navigate the menus I instantly find the site slow, boring and with horrible UX.

**Next.js:** https://nextjs.org/ however looks and feels tight and inspiring to get started with. Given the opportunity I will get back to this one. But React? Having worked with it (and enjoyed it), it still felt a bit much given my simple use case. 

At 3rd place when it com when it came to stars I found **Hugo** written in Go, with Go templates.

"A typical website of moderate size can be rendered in a fraction of a second. A good rule of thumb is that Hugo takes around 1 millisecond for each piece of content."

That quote, the nice clean website/showroom (https://gohugo.io/\) and a chance to get more familiar with Go was enough for me to first try out Hugo.

#### The process
This time around I felt that the look and feel was a key factor so I spent some time trying to find a good theme to copy, and reduce time and misery trying to make something nice looking from scratch. Quickly I found a theme that I felt ticked my boxes in https://themes.gohugo.io//theme/raditian-free-hugo-theme/.

Just like with Jekyll I wanted to avoid polluting my environment, at least until I had commited to use Hugo. At this point in time Hugo does not have an official docker image but their own installation page pointed to this one: https://hub.docker.com/r/klakegg/hugo/

A docker-compose file later I was up and running with livereload out of the box.

```yml
  server:
    image: klakegg/hugo
    command: server
    volumes:
      - ".:/src"
    ports:
      - "1313:1313"
```
Next to the compose file I also introduced a hugoshell.sh bash script allowing me to create a temp shell to work in when running custom hugo commands.

##### Themes?
I was not impressed with how themes were introduced in Hugo documentation. Basically searching in their docs for "theme" the only reference is to the cli command to create a new theme. A quick google search told me to just download any theme repo and unzip it in the "themes" folder of my own project. Another option seems to use a git submodule. But I dont know, maybe I am conservative here but I believe anything that further complicates git should be avoided so I went for the clone/paste solution.

The next revalation for me was that it seems my expectations were a bit off regarding what the "theme" was. The nice looking theme I had chosen (https://github.com/radity/raditian-free-hugo-theme\) quickly became a prison for me. Sure if I had just done the exact same website but with my swedish looking face instead of the swiss looking one, and changed a few other things I could have had it done in little time. But the more I got familiar with the code it felt chunky, lots of hard to read html, inline script blocks and css animations and a fair amount of dated external dependencies such a jQuery, bootstrap, jquery, lazy, lozad and more.

So out went the sexy swiss theme and in came the cli command I first found in the hugo search:

```
oscarberg.com/main> hugo new theme oscar
```
Or basically I pretty much followed this guide: https://retrolog.io/blog/creating-a-hugo-theme-from-scratch/
Again it came with Bootstrap, but now I was more ready to understand that I needed some kind of UI framework and why not Bootstrap. It felt like a good choice for what I wanted to do, which as to keep it simple.

#### Takeaways
This website is the output so far. With sources public in github: https://github.com/oversizedhat/oscarberg.com.

As it's not possible to use GitHub pages out of the box with Hugo, I added a travis build step that compiles the sources in one repo and pushes them to another, which is acting "stage" environment for the real website.

Based on the few hours of experience so far it's hard to say yey or ney to Hugo. I am still a bit unsure of the theme concept. It feels wobbly to incorporate a theme and then just copy paste/modify your own site overriding whatever feels relevant. And doing so without any kind of valdation/test automation feels very risky, and complex to eventually update in case of a updated theme. And coming from the Nodejs+npm world I dislike this way of adding external dependencies by pasting in minified js files in my own repo (package.json come rescue me!!). 

On the other hand it has been very easy to work with Hugo, and it is lightning fast. AND I dont have to look at a node_modules folder with 1000 dependencies. But then again I haven't come to any complex stuff yet. I have pretty much worked within the standard boundries of Hugo+Bootstrap with hardly any code. With more complexity comes the need for proper test automation. And browser support, polyfills etc. So we will see where this lands in the end. For this basic purpose Hugo has been nice and easy to work with, but for a more complex site I am hesitant atm.

<div class="alert alert-warning" role="alert">
  <b>Update Dec 2, 2020:</b> Since the post I decided to experiment a bit more with Hugo + NPM so the repository is not 100% matching the text of the post. There is a tag of how it was before I started the inevitable quest of complicating things in order to keep it simple... <a href="https://github.com/oversizedhat/oscarberg.com/tree/v0.5.0">(The old tag)</a>
</div>