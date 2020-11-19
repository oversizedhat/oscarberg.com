# oscarberg.com

HUGO static site and theme for oscarberg.com using Bootstrap 4 for UI

Landing page and blog pretty much.

### Pre-reqs
if you don't have or want to install hugo in your env you might as well run hugo in a docker container, ie. you need docker + docker-compose.

### Develop
```
# start regular dev server with file watcher (runs 'hugo server')
docker-compose up
# NOTE: we run on port 8080 instead of the hugo default 1313
```
##### Adding content:
```
# create a hugo shell
./hugoshell.sh

# create a blog post
hugo new blog/look-at-me.md
```

