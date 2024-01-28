# oscarberg.com
[![Build Status](https://travis-ci.com/oversizedhat/oscarberg.com.svg?branch=main)](https://travis-ci.com/oversizedhat/oscarberg.com)  
HUGO static site and theme for oscarberg.com using Bootstrap 4 for UI

Landing page and blog pretty much.

### Pre-reqs
Note: Setup only tested on Ubuntu and MacOS.

- npm
- docker + docker-compose (for running hugo)

### Install
```
npm install
```

### Develop
```
# start hugo server on port 8080 (and launch browser)
npm run serve

# build (once) - runs hugo and htmllint validation of output
npm run build
```

##### Adding content:
```
# hugo cli is access through creating end entering a shell with hugo
npm run hugoshell

# create a blog post
hugo new blog/look-at-me.md
```
