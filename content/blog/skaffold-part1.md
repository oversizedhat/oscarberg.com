---
title: "Designing a microservices application using Kubernetes and Skaffold - part 1"
date: 2022-10-15T08:01:34Z
tags: ["skaffold", "kubernetes", "GCP"]
draft: false
---

Every now and then you get the chance to build something from scratch. A greenfield project! Endless possibilities often combined with the requirement to have something up and running as quickly as possible, and with low running costs.

<p class="lead">WOW! A chance to use past experiences but hopefully not make the exact same mistakes made in the past...</p>

The thought with this post and upcoming ones is to share some light on the thought process and design choices made when starting from scratch and also, in later parts, some details regarding the tech stack that is still forming.

#### The project at hand

This time the challenge was to setup an application consisting of a few frontends and a backend as well as making use of other tools and services that we either use via externally hosted APIs or self-host and use as part of our system.

The company I was contracted by had past experiences using Google Cloud Platform (GCP) which was a driving factor in choice of cloud provider. My goal was however to ensure the application was as platform agnostic as possible without compromising in development speed.

#### Why Kubernetes?

We decided pretty quickly to use Kubernetes for orchestration of containers. To go completely serverless for a bigger project would be interesting but felt too risky given the situation and we also knew that we needed to run at least parts of the system in containers.

My experiences using Kubernetes were slim to none at this point although I had some hands-on experience deploying and running containers in AWS ECS as well as utilizing docker + docker compose in various dev environments and tools.

The choice to go with Kubernetes felt straight forward. Arguably Kubernetes is the winner in the race of container orchestration. It's built by Google and has more or less "native" support in GCP.

#### Why <a href="https://skaffold.dev/">Skaffold</a>?

Again my experiences using Kubernetes were limited at this point. I knew that I wanted to keep things as simple as possible, and not waste time managing a cluster.

I found that Google had a demo project of an ecommerce application using different microservices which was making use of Skaffold: 
https://github.com/GoogleCloudPlatform/microservices-demo

Cloning this project and watching it deploy nicely to a local minikube cluster simply bu using a single command was enough to get me excited. 

Using the same concept I was quickly able to put together a similar setup for our services enabling them to be deployed to a local k8s cluster (Minikube) or a cluster in GCP GKE. Simply by deploying services in dev mode watching the filesystem for changes it was easy to deploy a full environment that was watching/rebuilding the corresponding service on any code change. Working primarily with Node.js where most frameworks has this built in the setup was a breeze.

Also I found it positive that Skaffold is'nt the only tool out there to serve the same purpose. There are serveral alternatives, like <a href="https://garden.io/">Garden.io</a> and <a href="https://tilt.dev/">Tilt</a>, which seem to serve a very similar purpose. In my book this means that even if Skaffold won't survive and/or not be sufficent for our needs, there are alternatives and a migration should hopefully be simple. It also means that others see the need for introducing such a tool into their stack.

... and oh, Skaffold is free and open-source, which of course helped to seal the deal.


#### Monorepo vs Multirepo (and the <a href="https://12factor.net/">12-factor app</a> guidelines)

Another question was the ever so important choice between monorepo and multirepo. Personally I have a fair amount of experience of the multi repo setup. At first it's easy but the complexity grows exponentially with the system. Dependency management may be easy to setup but the problems start when you have a system to maintain whilst wanting to introduce new features and or make bigger structural changes. Unless you have a system of fully isolated components you will end upp with complex branching situations and build/deployment procedures to support them.

The <a href="https://12factor.net/">12-factor</a> codebase rule says it nicely: "There is always a one-to-one correlation between the codebase and the app. If there are multiple codebases, it’s not an app – it’s a distributed system. Each component in a distributed system is an app, and each can individually comply with twelve-factor.".

There is a line to draw here though. As I mentioned above part of this system will exist of other self-hosted "applications"/or services developed and maintained by others. In these situations we treat them separately and our Skaffold/Kubernetes setup is only depending on such services in their output (docker image) form.

#### Keep your secrets secure from day 1

Another fundamental part of any kind of system is how to manage it's secrets. 

There are a few basic rules to adhere:
- NEVER put secrets in your codebase.
- NEVER put secrets in docker images.

Having previously worked with AWS I found the most effective way to handle secrets was to rely on their secret key/value service, AWS Secrets Manager. GCP has an equivalent service, GCP Secret Manager, which is pretty much 1:1 to the former. The use of such a service can easily be implemented in any environment and you can manage access to secrets depending on the IAM user authenticated, regardless if it’s human user or service user. A secret is not limited to a password but can be used to store complex data, jsons or hashes.

So put your secrets in a secure key value store like GCP Secret Manager and feed your containers deploy-time with environment variables or even have your services fetch the secrets runtime when they boot up. In the latter approach automatically rotated secrets is easier to implement.


#### Some outtakes from part 1

- Carefully read and adhere to the <a href="https://12factor.net/">12-factor app</a> guidelines. Make your own set of rules that extend them and/or further define how the rules are applied in your specific setup. 
- Use a monorepo setup unless you really know what you are doing. When starting up a project you definitely don't want to waste time with complex repository, build and branch management. Instead go for having a single repo with a set of branch rules that build and deploy as you see fit.
- Try to build something that is not relying too heavily on third party tools. After about 8 months using Skaffold the experience has been positive but the question remains if it will stand the test of time. Here I am not sure. And like with any moving codebase you will find issues. Some of them might be painful. Choose your weapons with care, and keep your dependencies as shallow as possible. In reality Skaffold provides us with some basic features to help build docker images and deploy kubernetes manifests to any cluster (local or managed). Replacing Skaffold with something that is designed to solve the same challenges won’t be that cumbersome.
- Design with security in mind from day 1. If you accidentally exposed a secret for example by pushing it to a codebase it should be considered exposed forever and must be replaced. Having a setup for this from start limits the need to share secrets betwen devs in Slack messages, emails etc.

Onwards to part 2 <a href="/blog/skaffold-part2/">here</a>.