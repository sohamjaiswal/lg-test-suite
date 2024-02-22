# lg_tester

A new Flutter project. For me, others and hopefully to apply for GSoC, but still mostly for me. 

## To Run

Just clone this project and select device and run using flutter lol, simple. 

## Project structure

Mostly everything that a dev working on this should be concerned about is in the lib folder.

Constants dir contains constants in the app.

Controllers dir contains mostly singletons that handle the business logic in the app.

Localizations dir contains generated locales 

Screens dir contains the various app screens that the user will see

Services dir contains a single file currently which was given with the flutter skeleton template, in traditional web dev sense it should contact external apis and services that help the app function, I have just kept it like that anyways. 

Utils dir contains common code that will be shared across the app


## About this project

I am in no way a flutter/dart aficionado currently, so I am just trying to learn by making this app.

I have tried following guides and normal object oriented and ui framework principles, which I have not been able to source from the current repos. 

The current sample apps available on the org's repos, although being helpful resources to understand how to get stuff done on the lg rig itself are not good or pincipled dart/flutter codebases according to my previous work experience and guides. 

Thus this the repo that I am creating not only for a gsoc, but also as a reference to me for future projects which I may make in flutter which has intrigued me quite a bit for a while now ngl. After all, qualifications like GSoC are temporary but knowledge is eternal.

### Why I intentionally supported all platforms 

Flutter is meant to be a framework that helps reduce a developer's burden by helping them compile to various platforms while maintaining a single codebase. In terms of performance, in Liquid Galaxy we dont do anything intensive at all on the client side other than the occassional ai fad that is not even handled in flutter at all. Why is it that we encourage to develop ONLY for tablets? 

If we required the perf., we would have gone with native android with java/kotlin but the project still encourages flutter/dart...

Thus I have tried to make it platform agnostic, (which is what flutter is meant for), so it should not be constrained to just android tablets. In fact I made sure to test it on iPhones and iPads too. 

Also this is my personal go to resource for flutter now so I had to make.

### Why not use already provisioned code

> It's not following best practices that I would personally want as reference, in most flutter apps currently on the org, the controllers are intrinsically linked to the UI, which is bad from every field of programming I know.
> Low OO principle usage/Low optimization/Not DRY code
> LG logic being all over the place... This is also a repo for me personally, I want to seperate the LG logic out so that I can use this as a base template for other flutter apps I make. In my code everything about LG would be handled in a single LG controller file.

### Would I recommend this to others

If you are currently doing GSoC, NO, you should make it yourself, I ain't no student yet but I was able to make it, you can too, just reading this readme should be enough for you to avoid the pitfalls I mentioned. 

If you want it as a general guide for if you already have some problems that I mentioned above, Ya, I think it would be pretty cool to actually maintain your open source apps than just abandon the project. 
