---
title: "Hugo + npm = Awesome?"
date: 2020-12-10T18:39:18Z
draft: false
tags: ["hugo", "static site generator", "npm", "htmlhint"]
---
Anyone setting up a blog/static site using Hugo is destined to quickly start missing the conveniency of having some kind of build system/package manager at their disposal. The following text describes some basic setup instructions for wrapping your Hugo project with some npm magic and get something that can easily be expanded on depending on the requirements of the project at hand.

If you are looking into using Hugo, my first experience can be found [here.]({{< ref "/blog/hugo" >}} "About Us")

So... after my initial setup of a Hugo blog (this site) I quickly found that I lacked basic functionality of some kind of build system. And when it started to evolve into custom bash scripts I found it was better to just make use of npm instead.

###### **I wanted npm to provide me**
1. "Boostrapping" and easy management of third-party dependencies
2. Life cycle scripts for the recurring activities handling the "application" as a whole
3. Easy way to incorporate at least some kind of post build validation of the web page.

##### 1. Add Hugo assets from node_modules
Resort to the official npm docs https://docs.npmjs.com/ for regarding installation of nodejs+npm, and setting up a npm project ('npm init').

With a package.json in place I was could replace my locally bundled bootstrap css by adding it as a dependency and then using the Hugo mounts config feature to mount the node_modules folder to the assets folder. **You need to** mount it to the assets folder as it allows you to do a lot of neat asset processing using [Hugo Pipes](https://gohugo.io/hugo-pipes/introduction/). Which is a great feature btw.


###### Step by step:
1. Add bootstrap to the project
```sh
npm install bootstrap
```
2. Mount the folder to assets
```toml
[module]
  [[module.mounts]]
    source = "./node_modules/bootstrap/dist/css"
    target = "./assets/css/bootstrap"
```
3. Make sure it's used in the relevant html template
```html
{{ $bootstrap := resources.Get "css/bootstrap/bootstrap.min.css" }}
<link rel="stylesheet" href="{{ $bootstrap.Permalink }}">
``` 
Thats it, any bundled bootstrap files can be removed. And if I ever have to bump the version it is managed an easy.

Note that here I'm not doing any fancy piping as I use the minified css that comes with bootstrap, but basically you can do all sorts of things with pipes; like minifying, adding fingerprints etc.

##### 2. Necessities of a build system
Next part was a way to organize usual activities, such as building, testing and deploying.

As mentioned, in lack of a build system I had started making bash scripts. Also the .travis.yml served as some kind of build system as it was doing work for me. But neither expanding on the Travis config nor making more bash scripts felt like a good idea. Instead I wrapped what I had with npm scripts.

More or less self explanatory I think. I made so the default hugo serving also enabled the drafts, but excluding them when making a staging or production build.

```json
 ...
  "scripts": {
    "serve": "bash dev.sh --with-drafts",
    "serve:prod": "bash dev.sh",
    "build": "npm run compile && npm run lint:postbuild",
    "compile": "bash build.sh",
    "lint:postbuild": "npx htmlhint target",
    "deploy:dev": "bash deploy-dev.sh",
    "deploy:prod": "echo 'not setup for Travis'",
    "oscarberg.com": "npm version patch && bash deploy-prod.sh -y",
    "hugoshell": "bash hugoshell.sh",
    "preversion": "npm run build",
    "postversion": "git push && git push --tags"
  },
  ...
```

So far I do "production" deployments from local machine, but let travis manage the "stage" environment. The build queues for free open source projects can take several hours in Travis. I prefer production to be a bit more controlled than that assuming I will make mistakes.

##### 3. At least some kind of build validation
Even though this is pretty much a "for fun" project (without any kind of serious requirements on anything really) I figured I wanted at least some kind of automated validation before putting anything in production. Especially now that I had prepped so nicely for it... E2E testing felt like too much trouble and there isnt really any code to unit test. So I ended up added HTMLhint on the Hugo output site.

[HTMLHint](https://www.npmjs.com/package/htmlhint) provides some basic static code analyis of HTML and is easy to install and execute in any npm project. (`npm install htmlhint --save-dev`)

```json
  "devDependencies": {
    "htmlhint": "~0.14.2"
  },
```

As can be seen in the package.json script snippets above its triggered in the build chain, but can also be run manually.

```sh
npm run lint:postbuild
```

So now if I make a boo-boo I have Hugo acting compiler and catching bigger issues, and then I have the linter at least catching some of the details that can slip by, like unclosed tags:

```sh
> oscarberg.com@1.0.1 lint:postbuild /home/oscar/repos/oversizedhat/oscarberg.com
> npx htmlhint target


   Config loaded: /home/oscar/repos/oversizedhat/oscarberg.com/.htmlhintrc

   /home/oscar/repos/oversizedhat/oscarberg.com/target/404.html
      L5 |...hanks for letting me know</button></div></body></html>
                                                     ^ Tag must be paired, missing: [ </div> ], start tag match failed [ <div id=content> ] on line 3. (tag-pair)

Scanned 19 files, found 1 errors in 1 files (41 ms)

```

#### Final remarks and takeways

Npm is pleasant to work with. With a small amount of boilerplate it's possible to wrap any kind of project with a repository and basic "application level" activities. And when in front-end, it makes no sense not to utilize the massive registry of open source packages.

As a side effect the travis yml ended up clean and simple, just making use of the scripts, effectively hiding any complexity.

```yml
language: node_js

node_js:
  - 14

services:
  - docker

env:
  - HUGO_DEPLOY_ENV=stage
  
before_script:
  - npm ci

script:
  - npm run compile
  - npm run lint:postbuild

deploy:
  - provider: script
    script: npm run deploy:dev
    skip_cleanup: true
    on:
      branch: main
```

This website is the output so far. With sources public in github: https://github.com/oversizedhat/oscarberg.com.

:heart: