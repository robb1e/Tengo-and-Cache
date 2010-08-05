Tengo and Cache
===============

What's in a name?
-----------------

Tengo is Spanish for 'I have' and cache is geek speak for storing information.  It's also a play on words on that 80s classic 'Tango and Cash'.  

So what's is all about then?
----------------------------

This project was born from a desire to push on from some work of creating iPhone applications using only web technologies that I had done some time ago. That work can be seen http://github.com/robb1e/iWeb.  This first project was a way of deploying a HTML/CSS/Javascript application onto an iOS device and have it run as a native application.  

The issue with that was the only way to change HTML, CSS, Javascript, images or other data was to depend on a live internet connection or do an application update.  I was looking for a way to make it easier to cache those resources with a specific eye on offline experience.  

After some thought, the lightbulb switched on and it became an immediate choice to use the HTML5 Cache Manifest file as a basis of discovering what resources should cached.  This project aims to do just that.

Between the application bootstrapping and a webpage being rendered, the cache manifest is read and each file is downloaded and stored in the iOS application sandbox directory.  After all files have been saved, the UIWebView will render an index.html file in that sandbox.  

How to use it
-------------

* You'll need the iOS SDK, I've been using 3.x.  
* Open the Cachemanifest.xcodeproj file in xCode
* Open Cachemanifest-Info.plist file
** alter the values for AppUri and Manifest accordingly to point at your domain and manifest file
* Run the project, if you watch the console, you should see plenty of logging

Current Limitations/Opportunities for Improvement
-------------------------------------------------

Currently the application doesn't adhere to all of the HTML5 cache manifest directives.  For instance, all resources in 'network' are downloaded where they should be ignored.

Using Fallback will probably break this app at the moment, and it certainly won't don't any redirecting if there's no network connection.

The application doesn't raise any events as described by section 5.6.1.1 from here: http://www.w3.org/TR/html5/offline.html - I'm not certain that all are relevant but some can certainly be fired using the stringByEvaluatingJavaScriptFromString method on the UIWebView.

 

