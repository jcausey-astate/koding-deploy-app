# koding-deploy-app
This is a simple Bash script designed to make it easy to switch between multiple applications in a virtual machine 
on [Koding.com](https://koding.com).  

This allows you to develop and test multiple applications within a single Koding VM, and gives the ability to 
switch between the currently deployed application near-instantly.

To accomplish this, it changes the default _"Web"_ directory in your VM into a 
[symbolic link](http://en.wikipedia.org/wiki/Symbolic_link) pointing to the main (document root) directory of
your application, which must be installed in the _"Applications"_ directory.

## Installation
Download the `deploy-app.sh` script and place it into your Koding VM's home directory.

Now execute `chmod u+x deploy-app.sh` in a Terminal window to make the script executable.  That's it!

## Usage
Once the app is installed, type:

```
./deploy-app.sh your-app-name
```

This will deploy the app whose directory (within _"Applications"_) is named `your-app-name`.

## Required Directory Structure
In order to use this script, it is expected that each of your applications has a directory within the default 
_"Applications"_ directory in your Koding VM.  Your application's code may be either directly in this directory
or in an immediate subdirectory named `public`.

### Example Directory Structures

```
~/Applications/
    app-one/
        index.php
    app-two/
        lib/
        templates/
        public/
            index.php
```
In this example, there are two "installed" apps: `app-one` and `app-two`.  To deploy `app-one`, enter the 
following in the Terminal (with your working directory set to the same one containing the `deploy-app.sh` script):

```
./deploy-app.sh app-one
```
The script will symbolically-link the _"~/Web"_ directory to the _"~/Applications/app-one"_ directory (since there is no _"public"_ sub-directory).

To deploy `app-two`, enter this:

```
./deploy-app.sh app-two
```
The script will symbolically-link the _"~/Web"_ directory to the _"~/Applications/app-two/public"_ directory.

## First-Use Warning
The very first time you run the script, it will **delete** your current _"Web"_ directory _along with all contents_!
If there is anything stored within that you would like to keep, back it up first.




