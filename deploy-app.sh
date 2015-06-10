#!/bin/bash

#---------------------------------------------------------------------
# Deploy a Koding application to make it the current "live" 
# application (by symlinking the "Web" directory to the application's
# internal document root).
#
# Usage:  deploy-app appname
#
# NOTE:  If the application directory (which MUST match `appname`)
#        contains a "public" directory (as a direct descendant)
#        then that will be used as the target of the symlink,
#        otherwise the application's root directory will be used.
#        Example:
#            App Directory Tree     Produces Symlink
#            ---------------------------------------------------------
#            myapp/                 Web -> Applications/myapp/public/
#               data/
#               include/
#               public/
#            ---------------------------------------------------------
#            myapp/
#               images/             Web -> Applications/myapp/
#---------------------------------------------------------------------

APPDIR="~/Applications/$1"
WEBPATH="~/Web"
# expand the tildes:
eval APPDIR=$APPDIR                                 
eval WEBPATH=$WEBPATH

DOCROOT=$APPDIR

# sanity check: see if appname is specified
if [[ $1 =~ ^$ ]]
then
    echo "Error: Missing application name."
    echo # newline
    echo "Usage: "
    echo "  $0 appname"
    echo # newline
    echo "  Where \"appname\" is the top-level directory name of the application"
    echo "  that you wish to deploy."
    echo "  The application must be located in the \"Applications\" directory."
    echo # newline
    exit 1
fi

# sanity check: see if app exists
if [ ! -d "$APPDIR" ]
then
    echo "Error: \"$1\" is not currently installed in $APPDIR"; echo ; exit 2
fi

# check for "public" subdirectory at first level:
if [ -d "$APPDIR/public" ]
then
    # if found, update DOCROOT:
    DOCROOT="$APPDIR/public"
fi

# remove the existing Web link:
if [ -h "$WEBPATH" ]
then
    unlink "$WEBPATH"
# Or warn and get permission to delete the original directory if it
# hasn't already been done:
elif [ -d "$WEBPATH" ]
then
    echo "It appears you have not used app-deploy before to deploy an application..."
    echo "Doing so will delete the current contents of your \"Web\" directory!"
    echo # newline
    read -p "Are you sure you want to do this? (Y/N)  " -n 1 -r
    echo # newline
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf "$WEBPATH"
    else
        echo "Action canceled."
        echo # newline
        exit 0
    fi
elif [ -e "$WEBPATH" ]
then
    # Here, the Web directory existed, but wasn't a directory or link. Abort.
    echo "Error: The path \"$WEBPATH\" seems to reference something"
    echo "other than a directory."
    echo # newline
    exit 3
fi

# Now the link should be gone; create the new link.
ln -fs "$DOCROOT" "$WEBPATH" && echo "$1 Deployed OK" && echo && exit 0

# If we are still here, the linking step failed:
echo "Failed to create link for the application document root \"$DOCROOT\"."
echo # newline
exit 4