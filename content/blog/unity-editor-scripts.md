---
title: "Unity editor scripting - A real world use case"
date: 2021-10-04T10:01:34Z
tags: ['unity', 'editor script']
draft: false
---

{{% video "/blog/img/unity-editor-scripts-vid.mp4" %}}

After getting some play-time in Unity I found that one of the more exciting features is the ability to quite easily extend the base editor functionality by writing your own editor scripts.

Even though I feel I’ve only been touching the surface (this is the first real project I've made in using Unity) I feel there is a shortage of good guides and real world experiences using editor scripts. This post aims to illustrate a situation where I found custom editor scripts very useful myself in our app <a href="https://www.spaceandtimeapp.com">Space & Time</a>.


#### Space & Time “lessons” practical use case

The app features a dynamic interactive scene where the user can interact with the Earth and other terrestrial bodies like the Sun and the Moon. In a “sandbox” mode the user can interact with the scene in different ways; like manipulating date & time, adding locations, dropping down to the Earth’s surface level etc. 

{{% fluidimage "/blog/img/unity-editor-scripts-sandbox.png" "Space & Time app - sandbox mode" %}}

In the second part of the app we guide the user in the same scene. We enable/disable features, change camera views and try to explain different things. Basically we act as a teacher.

In the app it’s today possible to choose between about 16 guides (in code we call them lessons...) each of them containing somewhere between 7-20 steps. So it's well over 200 interactive steps in total.

{{% fluidimage "/blog/img/unity-editor-scripts-guides.png" "Space & Time app - interactive guides" %}}

Each of these steps needs enough configuration to display the scene in a certain way.

We also figured that we occasionally wanted custom elements (game objects) in any given step, as well as support for working with multiple languages.

The main challenge of setting it up was to make it easy enough to work with when adding content, i.e. when adding new lessons and lesson steps. This is where the editor scripts came in.


#### Prefabs, prefabs, prefabs

At first we had the lesson configuration in a text object format supported by code. It wasn't all bad to start with because code can be iterated on quickly and when the end goal is unclear. But as soon as the structure and our own requirements were settling down it became obvious that we wanted something more visual, and using prefabs felt like the obvious choice. Also this was part of myself learning Unity I think. The more I learned the more I felt compelled not to re-invent any wheel. The more I adapted to standards the better I could float in the current of existing tooling.

Basically a lesson is made up of two prefab types. One is the lesson configuration itself (i.e. a collection of lesson steps), and one is for any given step inside a lesson. 

When starting a lesson during editor play mode the specific lesson step prefabs are added to the scene and it’s easy and intuitive how to interact with them.

{{% fluidimage "/blog/img/unity-editor-scripts-intuitive.png" "Space & Time app - standard Unity scene workflow" %}}

We rely on editor scripts to create and edit the configuration of any lesson and lesson step. The nicest thing is being able to modfiy a step directly in the editor during play mode and have the step instantly reload on any change, and also saving the updated prefab (if it passes through a bunch of validation tests written to help avoid human errors). And as we have the prefab in the scene we can even pull in custom game objects straight into the scene, layout and save. A huge benefit is that we can also edit/iterate on localized text pretty much exactly how it will be displayed in the final build.

{{% fluidimage "/blog/img/unity-editor-scripts-custom.png" "Space & Time app - custom game objects" %}}

#### A script written to run only once can still save you time

Another tip of mine is to consider editor scripts when you want to make a significant change in your project structure. Sometimes it makes sense to just write a very custom editor script that does a task once (but at the same time allowing you to try it many times first). Going back to how we changed from using text based config of the lessons. I made a custom editor script that converted all the existing lessons to prefabs. And a similar, short-lived, setup was made converting all lesson step texts to a KeyValuePair setup with a localization framework.


And oh, make sure you have some kind of VCS setup first because changes are you will want to revert some changes.


As for tech details the Unity Script reference is a good resource even though it often feels difficult to navigate: 
https://docs.unity3d.com/ScriptReference/  


##### Here are a few good starting points:

Take control over the Inspector window by writing a custom inspector.  
https://docs.unity3d.com/ScriptReference/Editor.html

Write your own menu items/windows.  
https://docs.unity3d.com/ScriptReference/MenuItem.html
https://docs.unity3d.com/ScriptReference/EditorWindow.html

Interact with prefabs:  
https://docs.unity3d.com/ScriptReference/PrefabUtility.html



Hope this comes to use for anyone in a similar situation :heart:

And if it did make sure to download the app: :blush:
https://www.spaceandtimeapp.com
