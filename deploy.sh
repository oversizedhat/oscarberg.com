#!/bin/bash

# https://www.sidorenko.io/post/2018/12/hugo-on-github-pages-with-travis-ci/

set -e

# TODO prevent accidentally chaging git config if running from local machine...
echo $GITHUB_AUTH_SECRET > ~/.git-credentials && chmod 0600 ~/.git-credentials
git config --global credential.helper store
git config --global user.email "oversizedhat-bot@users.noreply.github.com"
git config --global user.name "oversizedhat-bot"
git config --global push.default simple

rm -rf target
git clone -b main https://github.com/oversizedhat/oscarberg.com-dev target
rsync -av --delete --exclude ".git" docs/ target
cd target
git add .
# we need the || true, as sometimes you do not have any content changes
# and git woundn't commit and you don't want to break the CI because of that
git commit -am "rebuilding site on `date`, commit ${TRAVIS_COMMIT} and job ${TRAVIS_JOB_NUMBER}" || true
git push

cd ..
rm -rf target