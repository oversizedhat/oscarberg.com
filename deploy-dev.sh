#!/bin/bash

# https://www.sidorenko.io/post/2018/12/hugo-on-github-pages-with-travis-ci/

set -e

commitMessage=""

if [ -z "$TRAVIS_JOB_NUMBER" ]
then
    echo "Deploy for local env"
    commitMessage="build from local env `date`"
else
    echo "Travis CI deploy"
    echo $GITHUB_AUTH_SECRET > ~/.git-credentials && chmod 0600 ~/.git-credentials
    git config --global credential.helper store
    git config --global user.email "oversizedhat-bot@users.noreply.github.com"
    git config --global user.name "oversizedhat-bot"
    git config --global push.default simple
    commitMessage="travis ci build `date`, commit ${TRAVIS_COMMIT} and job ${TRAVIS_JOB_NUMBER}"
fi

echo $commitMessage

rm -rf deploy
git clone -b main https://github.com/oversizedhat/oscarberg.com-dev deploy
rsync -av --delete --exclude ".git" target/ deploy
cd deploy
git add .
# we need the || true, as sometimes you do not have any content changes
# and git woundn't commit and you don't want to break the CI because of that
git commit -am "$commitMessage" || true
git push

cd ..
rm -rf deploy