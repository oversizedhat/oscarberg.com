# oscarberg.com

HUGO static site and theme for oscarberg.com using Bootstrap 4 for UI

Landing page and blog pretty much.

### Pre-reqs
Only tested on Ubuntu.

if you don't have or want to install hugo in your env you might as well run hugo in a docker container, ie. you need docker + docker-compose.

### Develop
```
# start regular dev server with file watcher (runs 'hugo server' via docker-compose)
# we feed the private ip of the host to hugo for easier testing with any mobile device
# connected to the network

./dev.sh
```
Dev command also launches a browser pointing at private ip port 8080 (Needs to be refreshed once after startup).


##### Adding content:
```
# hugo cli is access through creating end entering a shell with hugo
./hugoshell.sh

# create a blog post
hugo new blog/look-at-me.md
```