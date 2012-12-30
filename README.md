ASMBLOG

### What is new:

+ Dynamic post loading (make changes whenever)
+ HTML output, dynamic and/or static
+ NGINX environment reporting
+ CSS styling

****

### About

ASMBLOG is an NASM (Netwide Assembler) powered blog, using an FCGI core to serve web content. The project is a proof of concept that you can use a basic, archaic language to do modern, complex tasks. While I admit I cheat on several occasions, using functionality written in C, at some point it will all be phased out for the full assembly based version. 

The blog is basically a series of assembly routines that do a set of tasks to serve the content, like serve the HTML header, dynamically load blog posts (work in progress), and get specific posts through GET commands (also work in progress). Another aspect of the project is as a learning experience for logic and low level computing, turns out the C standard is a real bitch to deal with efficiently behind the scenes. 

I make no promises regarding efficiency, as some of the routines I know to be ridiculously slow relative to what I can get out of it. In time I will try to optimize the methods for built in caching, and generally better algorithms. 

Currently, ASMBLOG is designed primarily for operation under NGINX, as I have been using the spawn-fcgi script to spawn instances that serve requests, and it is the easiest to use. There is also a command built into the Makefile that will automatically spawn a new instance as well as kill the currently running one, this eases the process of testing. There is no reason why the blog won't run on Apache or any other web server, so long as it supports FCGI, and you know a thing or two about assembly.

****

### Problems 

There are some limitations with the current build, namely that the character buffer for any line is 500 characters. This is because of the inability to sanely allocate memory in assembly. You can make the standard malloc call, but handling that return value can get a little too hairy for what I care about in v0.1. So basically, if you have a line in your post, or html, over 500 characters, I'm pretty sure you'll segfault. Not ideal for a web environment. However, there is the advantage that all data

is tightly controlled, I don't believe there are any current vulnerabilities with the blog itself. The biggest problem is the underlying server, and the FCGI libraries themselves. The assembly routines are all desgined to do one task only, there is not much room for malicious intent. 

****

### Requirements
These are tentative, and will periodically be updated. 

+ Clang (GCC will also work)
+ NASM (Netwide Assembler)
+ x86* Architecture Computer
+ NGINX
+ FCGI module

*While this will work on a 32 bit computer, you'd have to.... rewrite large portions of it. 
