---
title: "The best local dev environment for PlantUML diagrams!"
date: 2021-01-14T07:44:39Z
draft: false
tags: ["docker", "plantuml"]
---
{{% fluidimage "/img/blog/plantuml-watcher.png" "Release notes"%}}
<br/>

[PlantUML](https://plantuml.com/) is a great tool that allows you to write your diagrams and sequences in plain text and have them rendered to image formats such as PNG and SVG. The downside is that you pretty much have to live with, and sometimes fight against, automatic layouting and opinionated visuals (even though some styling is possible). Personally I love it.

How to work effectively with it is however a bit of a mystery to me. The [getting started](https://plantuml.com/starting) guide describes the installation of Java, Graphviz, the latest plantuml jar and then using java to run commands on your command line. 
```sh
java -jar plantuml.jar sequenceDiagram.txt
# This outputs your sequence diagram to a file called sequenceDiagram.png.
```
Again I love it. Clearly this is designed for developers:smile:

**BUT** It's not an ideal way of working, as you want quick feedback on your changes.

There IS a super nice Visual Studio Code plugin for it but it still comes with the environment pre-reqs AS well as the cumbersome pressing of Alt-D (or was it Ctrl-D??) to get the preview. For other IDE's I bet there are similar plugins leaving the same nasty taste of dissatisfaction... and the pollution of your environment.

#### Dockerized plantuml file watcher to the rescue

So to solve this I made a little dockerized file watcher that renders any PlantUML file when they are changed. It's a simple setup where a Docker image that is strapped with the necessary tools to run PlantUML (Java, Graphviz and the plantuml jar), and it uses the popular [chokidar](https://www.npmjs.com/package/chokidar) lib for watching of the fs.

When a file is changed the plantuml jar is executed. Any compiler flags are passed along. No installation required, the docker image will be pulled from Docker Hub and started with a simple command in your favorite terminal.

```sh
$ docker run --rm -ti -v ${PWD}:/ws -w /ws oscarberg/plantuml-watcher
******************************************************************
plantuml-watcher watching for changes in .puml and .plantuml files
plantuml args: []
******************************************************************
watching: /ws/example.puml
``` 

And to make it even more convienient I set up an alias for it in my usual environment.

```sh
#~/.zshrc
alias plantuml-watcher='docker run --rm -ti -v ${PWD}:/ws -w /ws oscarberg/plantuml-watcher'
# Note the single quote. If you use double quote the PWD substition will happen at the time of the alias declaration.
```

With a watcher up and running I can add/remove new diagrams, edit and get instant feedback. And with diagrams as text close to the code chances are they will be kept to up to date (and created to begin with...).

The code and more descriptions can be found in the [GitHub repo](https://github.com/oversizedhat/plantuml-watcher)
or in [Docker Hub](https://hub.docker.com/repository/docker/oscarberg/plantuml-watcher).