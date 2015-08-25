#!/bin/bash

# Set the tmpdir
if [ -z "$TMPDIR" ]; then
  TMPDIR="/tmp"
fi

# Set the path
DEPLOY="$TMPDIR/vagrant-docs"
rm -rf $DEPLOY
mkdir -p $DEPLOY

# Get the parent directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# Copy into tmpdir
cp -R $DIR/website/docs/ $DEPLOY/

# Change into that directory
cd $DEPLOY

# Ignore some stuff
touch .gitignore
echo ".sass-cache" >> .gitignore
echo "build" >> .gitignore

# Add everything
git init .
git add .
git commit -q -m "Deploy by $USER"

git remote add heroku git@heroku.com:vagrantup-docs-2.git
git push -f heroku master

# Cleanup the deploy
rm -rf $DEPLOY
