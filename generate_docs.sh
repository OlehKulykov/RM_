#!/bin/bash

echo -e "Executing docs."

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
    echo -e "Generating Jazzy output \n"
    
    jazzy --clean --author "Oleh Kulykov" --author_url http://www.resident.name --github_url https://github.com/OlehKulykov/RM_ --xcodebuild-arguments "-scheme,RM_" --module RM_ --root-url http://olehkulykov.github.io/RM_ --theme apple --swift-version 2.2 --min-acl private --readme README.md

    pushd docs

    echo -e "Creating gh-pages\n"
    git init
    git config user.email ${GIT_EMAIL}
    git config user.name ${GIT_NAME}
    git add -A
    git commit -m "Documentation from Travis build of $TRAVIS_COMMIT"
    git push --force --quiet "https://${GH_TOKEN}@github.com/OlehKulykov/RM_.git" master:gh-pages > /dev/null 2>&1
        
    echo -e "Published documentation to gh-pages.\n"

    popd
fi
