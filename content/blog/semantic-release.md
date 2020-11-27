---
title: "semantic-release with npm, travis and github"
date: 2020-11-26T10:01:34Z
tags: ['semver', 'semantic-release','npm']
draft: false
---
I made up an excuse to try out the popular [semantic-release](https://www.npmjs.com/package/semantic-release) framework/workflow tool for automating release related activities of npm packages. It's been around for a number of years and increasing steadily in popularity last year.

#### Why use semantic-release?

Publishing a package to the global npmjs registry is a dead simple activity. Basically anyone with an email address can set a npmjs account and publish a package within minutes.
``` sh
npm publish
...and boom it's done!!!
...and can never be undone!!!
```

So what happens is pretty much that the content in your npm project gets packed up into a tarball which is uploaded with version specified in the package.json file. Any attempt to update that version will result in 403:Forbidden. 

But what about versioning, tagging and doing it all from a consistent environment? 

The proposed solution is to leave any details regarding the release to [semantic-release](https://www.npmjs.com/package/semantic-release), and this is achived by it...
- determining version based on commit messages and past releases, and making sure it complies with [semver](https://semver.org/).
- creating relevant VCS tags and release notes
- "forcing" releases from a CI environment

#### The setup
I made small utility package I had been thinking about doing mostly to try out Inquirer.js. The utility starts a interactive cli menu based on your ~/.ssh/config file: https://github.com/oversizedhat/sshin\, litterally saving you milliseconds every week.

``` sh
npm install --save-dev semantic-release
```

Using Travis for CI I pretty much just copy/pasted the example in the offical [docs](https://semantic-release.gitbook.io/semantic-release/recipes/recipes/travis) to a .travis.yml. Besides that I needed to provide the Travis job some env vars to allow for it to publish my npm package and push to git repo.

Since my project did not have any kind of build/compile step, just a few unit tests, I could keep the default build step of just running tests. But while at it I added a "npm audit" step as a before_script step as can be seen [here.](https://github.com/oversizedhat/sshin/blob/master/.travis.yml)

(The important bit below)
```yml
     deploy:
        provider: script
        skip_cleanup: true
        script:
          - npx semantic-release
```
The script block initiates the release, as long as the branch is flagged for deployment in Travis. By default I think the deploy step is triggered from master or main branch. If you need other branches some additional config is needed.

That was pretty much it.

So I needed to try it out. And semantic-release publishes versions based on commit messages based on the [Angular Commit Message Conventions](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines), and I figured it was a "feature" to add semantic-release so...

```sh
git commit -am "feat: added semantic release"
git push
```
As travis "free" queue was taking forever to start the job I limited the excution to only run a single nodejs version, which felt like a "chore".

```sh
git commit -am "chore: lets just use node 14 for ci"
git push
```
After an hour or two Travis finally got around to my job...
It built ok but deployment was skipped:
```
Skipping a deployment with the script provider because this branch is not permitted: main
```

The github change from master->main is not yet standardized in tools. Both Travis or semantic-release still by default treat the "master" branch as default main/master/trunk-branch. Hmm... maybe they should have gone back to trunk instead of main? 

But, instead of working against the stream I pushed the branch as "master" for now.

Again after an hour or two Travis finally got around to my job... the log illustrates the "reasoning" made by semantic-release:
```
[8:45:02 AM] [semantic-release] › ℹ  Start step "analyzeCommits" of plugin "@semantic-release/commit-analyzer"
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: chore: lets just use node 14 for ci
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: feat: added semantic release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The release type for the commit is minor
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: added git repo to package.json, manual version bump
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: added description
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: first commit
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: Initial commit
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[8:45:02 AM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analysis of 6 commits complete: minor release
[8:45:02 AM] [semantic-release] › ✔  Completed step "analyzeCommits" of plugin "@semantic-release/commit-analyzer"
[8:45:02 AM] [semantic-release] › ℹ  There is no previous release, the next release version is 1.0.0
```

So based on the fact that there was no prior release made it decided to go ahead with 1.0.0. This confused me a bit as I had actually on purpose set the version to below 1.0.0, and also made 2 improper "test" releases straight to npm registry without making git tags (shame shame on me). For a brownfield project adopting semantic-release it feels relevant to be aware of this. 

###### **The release tag in github:**
{{% fluidimage "/blog/img/semantic-release-git-tag.png" "Release notes"%}}

*Note that the second "chore:" commit did not reach the release notes.*

Another thing that confused me bit was that the version in the git tag's package.json did not match the release. Not surprisingly this was the first question in the FAQ with the response being something like - well it's not really required, but if you want there is a plugin for it.

#### Takeaways
Clearly this simple use case was perfect for this, but surely the initial setup was satisfyingly simple and I will definitly try to use it in future projects.

But the real benefit of adding a tool like this to your workflow is not for a single developer setup. Having been a dev manager I know the hassle of ensureing consistency and making sure "rules" are followed regardless if they are coming from top down or ground up. People will make mistakes and forget, especially under pressure of delivery.

Although not having included here I will also make sure to combine this with some commit hook validating the message format. Husky+commitlint looks like a good combo for that: https://commitlint.js.org/#/guides-local-setup.
