---
title: "6 months of using Github Copilot, what's the verdict?"
date: 2024-02-01T05:01:34Z
tags: ["github", "copilot"]
draft: false
---
About 6 months ago I started using the [Github Copilot](https://github.com/features/copilot) extension in VS Code and shortly after, the [Github Copilot Chat](https://github.com/features/copilot) extension. 

Has it had a positive effect on my overall productivity?

Short answer: **Yes, no doubt.** :rocket: :rocket: :rocket:

## To provide some context of use
I've been programming for around 20 years. In my current role, I tend to jump around when it comes to use of programming languages, declarative configuration languages etc. To name the most common tools used during this period:
 - TypeScript (Nestjs, React), Python
 - Terraform, Dockerfiles, Kubernetes manifests, Shell scripts

## Learning curve
My experience enabling Copilot was that there was basically zero learning curve getting started. For anyone that has been programming with an IDE providing IntelliSense/autocompletion Copilot feels like a natural evolution of this.

Copilot Chat has however still not become part of my daily work. Not sure if it's due to my poor prompting skills or that it's just not good enough to make any substantial difference. I would argue that it's not about the learning curve though.

## Where Github Copilot shines
> #### :thumbsup: Context jumping
> When context jumping between projects, programming languages or configuration "languages" less time is wasted on language specific nuances. This is especially true if you have some context already. Copilot more quickly let's me pick up where I left off, and helps adopting a certain established style.

> #### :thumbsup: Writing boilerplate stuff
> This goes for both programming and configuration. Copilot sometimes feels surprisingly accurate in filling out service configuration, and similar, that it assumes I am going to introduce. I guess based on the surrounding context.

> #### :thumbsup: Writing unit test cases
> As with other kinds of input/output type of code Copilot is often very useful in writing unit test cases, or completing them for me based on their description.

> #### :thumbsup:  Simple logic and algorithms
> Copilot is often good at smaller blocks of business logic. For example if I write a function declaration with a clear name and perhaps a comment block with description. Copilot quite often provides code that at least partially can be used.
> 
> This goes for more inline code too. I find myself often writing small temporay comments of what I mean to achieve next, and then jumping to the next line to instantly get a suggestion from Copilot. The temporary comment can then be kept or removed depending of how much value it adds for readability.

> #### :thumbsup: Inspiration and "snippets"
> Quite often the Copilot suggestions are not 100% accurate or satisfactory, but even then they can be useful. Maybe the suggestion provided a valid regex that could be used so less thinking about that, but **exactly** how it was used needed to be altered. Or maybe the suggested solution made me reflect on the solution altogheter, and more quickly made me realize that the approach I started was bad to begin with.

## Where Github Copilot does'nt shine
I think my overall concern with Copilot is that it's suddenly easier to quickly create a lot of code mass. It feels interesting to reflect on the longer term consequences of this. A bunch of junior developers with Copilot could do a lot of damage without solid routines when introducing new code to a larger framework. Tech debt is a very effective productivity killer...

> #### :thumbsdown: Poor at solving even just slightly larger programming problems on it's own
> My experience is that Copilot thrives in as small scope as possible. In rare situations I have tried using Copilot Chat to write bigger blocks of code, classes or functions, and this has most often been quite fruitless.
> 
> Even with test cases in place it seems Copilot Chat most often struggles even with simpler algorthims creating solutions that does'nt pass the tests, or passes just a few of them. I've however had a few positive experience with simple prompts like "Can you make this consume less runtime memory?" or "Can you simplify this?" but quite often the solutions end up flawed, not considering edge cases and existing test cases end up failing.

> #### :thumbsdown: Prone to copy & paste-style solutions
> Copilot primarily helps you write new code but often when you introduce new code you may need to reflect on the existing code. Copilot will not suggest necessary abstractions or in any way respect DRY. If the abstractions are there however, Copilot will make use of them.

> #### :thumbsdown: Architecture...
> Perhaps goes without saying but Copilot will help you write basic code but it wont help you if you are on the wrong path to begin with. Or if there is non-obvious solution within reach. Or how your code will behave in a complex environment handling concurrency, graceful shutdowns etc etc. Instead Copilot might keep pushing you in the wrong direction, driving tech debt and code mass. Github Copilot will also gladly suggest solutions that break basic programming principles like DRY and Single responisiblity. 

> #### ...and those the quick hacks :smile:
> On several occasions Copilot suggest comments similar to  the below
```sh
// This is just a quick hack. TODO improve later
```
> Pretty funny though! :smiley: Makes me wonder if what I've written is crap and deserving such a comment, or if that is just such a common programming comment that the AI has learned by consuming a lot of open source projects...

#### Meta notes:
When this was written the VS Code Github Copilot extension version was v1.156.0 and Copilot Chat version was v0.11.1