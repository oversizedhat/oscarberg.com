---
title: "Designing a microservices application using Kubernetes and Skaffold - part 2"
date: 2022-10-16T08:01:34Z
tags: ["skaffold", "kubernetes", "GCP", "minikube", "docker"]
draft: false
---

There is a part 1 to post <a href="/blog/skaffold-part1/">here</a>.

Every now and then you get the chance to build something from scratch. A greenfield project! Endless possibilities often combined with the requirement to have something up and running as quickly as possible, and with low running costs.

<p class="lead">WOW! A chance to use past experiences but hopefully not make the exact same mistakes made in the past...</p>

In the last part we briefly touched the reasoning to introduce Skaffold in the first place but did not go into any details. In this part we will go into some more details on how to get started.

#### The project at hand (recap)

This time the challenge was to setup an application consisting of a few frontends and a backend as well as making use of other tools and services that we either use via externally hosted APIs or self-host and use as part of our system.

#### How to setup and run <a href="https://skaffold.dev/">Skaffold?</a>

The quick/lazy way to describe what Skaffold is, is to just copy that description from the <a href="https://skaffold.dev/docs/Skaffold">Skaffold documentation</a>, so here goes:
"Skaffold is a command line tool that facilitates continuous development for Kubernetes-native applications. Skaffold handles the workflow for building, pushing, and deploying your application, and provides building blocks for creating CI/CD pipelines. This enables you to focus on iterating on your application locally while Skaffold continuously deploys to your local or remote Kubernetes cluster."

So in reality Skaffold is a CLI tool and for that tool to make any use you need a yaml file to describe your system, as well as making sure your services can be built and deployed in containers. In our case we will use Docker. And we will also rely on minikube and kubectl, so <a href="https://skaffold.dev/docs/quickstart/">install these 3 tools in your environment</a>. We will also use Node.js and create a simple backend using NestJS. But for this part you can use whatever programming language and framework you want.

Note also that we in this example will use Skaffold v1.39. There is a version 2 currently in beta for anyone who wants to go bleeding-edge.

Skaffold is not opinionated regarding how you structure your project but we will use the following folder structure:

- <b>src</b> for the source code of our services
- <b>k8s-manifests</b> for the kubernetes manifests


We also need something to deploy. So let's just create a simple NestJS backend.
```sh
npm i -g @nestjs/cli # install nestjs cli
cd src
nest new myservice # create our Hello world service

```
Now we have a NestJS server waiting to get deployed. In order for us to deploy it into a Kubernetes cluster we just need a Dockerfile and a kubernetes manifest. Let's create those. In fact let's create two Dockerfiles and place them under our service folder src/myservice, I will explain why later.

##### src/myservice/Dockerfile
``` Dockerfile
FROM node:18-alpine

WORKDIR /app
EXPOSE 3000

COPY . .
RUN npm ci && npm run build

ENV PORT=3000
ENV NODE_ENV=production
CMD ["npm", "run", "start:prod"]
```

##### src/myservice/Dockerfile.dev
``` Dockerfile
FROM node:18-alpine

WORKDIR /app
EXPOSE 3000

COPY . .
RUN npm install

ENV PORT=3000
ENV NODE_ENV=development
CMD ["npm", "run", "start:dev"]

```
Note the subtle differences. In the main Dockerfile we start the service in production mode. We install ci-style and build, followed by starting what we just built.

In the dev file (Dockerfile.dev) we just install and start the dev server. No need to build here.

As for the Kubernetes manifest we just configure it to deploy our service on the Nestjs default port 3000.
##### src/k8s-manifests/myservice.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myservice
spec:
  type: ClusterIP
  ports:
    - port: 3000
      targetPort: 3000
  selector:
    app: myservice
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myservice
  template:
    metadata:
      labels:
        app: myservice
    spec:
      containers:
        - name: myservice
          image: oscarberg/skaffold-demo-myservice
          ports:
            - containerPort: 3000
```
And finally we add the Skaffold configuration yaml...
##### skaffold.yaml
```yaml
apiVersion: skaffold/v2beta26
kind: Config
build:
  artifacts:
    - image: oscarberg/skaffold-demo-myservice
      context: src/myservice
deploy:
  kubectl:
    manifests:
      - ./k8s-manifests/myservice.yaml
profiles:
  - name: dev
    activation:
      - kubeContext: minikube
        command: dev
    build:
      artifacts:
      - image: oscarberg/skaffold-demo-myservice
        docker:
          dockerfile: Dockerfile.dev
        context: src/myservice
        sync:
          manual:
            - src: 'src/**/*.*'
              dest: .
            - src: 'test/**/*.*'
              dest: .
```
Notice the dev profile. Skaffold will by default build and deploy a Dockerfile. By adding a dev profile that we activate when targeting minikube and the skaffold dev command we can trigger a different Dockerfile used for development (in this case Dockerfile.dev). Note also that the profile can be used to override other default behavior in your main skaffold <a href="https://skaffold.dev/docs/pipeline-stages/pipeline">pipeline</a>.

Also notice the sync block. This block allows us to tell Skaffold that any file changes in these folders should'nt trigger a rebuild of the entire docker image. Instead files changed in these folders will be copied into the running container and thus triggering the file watcher in our NestJS server to hot reload.

##### OK that's it! We are all set for the test run.

In order to run Skaffold we also need a docker registry. If you have a docker registry feel free to use that one but for the purpose of this demo we just start a local one and have skaffold use that one.
```sh
# Create a local docker registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# ...and let's tell Skaffold to use it as default repo
skaffold config set default-repo localhost:5000

#...and finally start minikube so we have somewhere to deploy
minikube start --driver=docker
```


##### DEV MODE - Start the dev server, ready for hot-reloading on code changes
```sh
skaffold dev --port-forward
```
Open your browser at localhost:3000 and watch it respond.

Also try out changing some code. Notice that if you change code inside the src and test folders the service will just hot-reload quickly but if you edit any file outside those folders the docker image will get rebuilt before the service is up and running again.

##### PROD MODE - start the prod server, tail the logs
```sh
skaffold run --port-forward --tail
```
Open your browser at localhost:3000 and watch it respond.

Try shutting it down and restarting a couple of time. Observe how Skaffold will use cached images if no changes are found since last build. (This is what saves you when your app starts growing with more services)
```sh
Checking cache...
 - oscarberg/skaffold-demo-myservice: Found Locally
```
:heart:


#### Some outtakes from part 2
- In this part we set up the necessary boilerplate configuration allowing us to execute the main skaffold commands: <b>run</b> and <b>dev</b> which is pretty much enough to get started. Notice how the Dockerfiles are unaware of what they actually build and deploy. Keeping them generic will simplify if you for example need a quick setup for adding new microservices as your application grows.
- Note also that we deploy to a local minikube cluster but the setup isn't limited to minikube or local development in any way. We could just as easy deploy to a remote cluster like one residing in GKE.
