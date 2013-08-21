#!/usr/bin/env sh

GIT=$(which git)
SED=$(which sed)

REMOTES=("origin" "github")

CURRENT_BRANCH=$($GIT branch | $SED -n '/\* /s///p')
DEVELOP_BRANCH="dev"
DEPLOY_BRANCHES=("master", "gh-pages", "dev")

function main {
    # first merge current chagnes into develop branch
    $GIT merge    $DEVELOPE_BRANCH
    $GIT checkout $DEVELOPE_BRANCH
    $GIT merge    $CURRENT_BRANCH

    # then deploy changes to targe branches
    for br in $DEPLOY_BRANCHES
    do
        $GIT checkout $br
        $GIT merge    $DEVELOPE_BRANCH
        for remote in $REMOTES
        do
            $GIT push $remote $br
        done
    done
    echo "done deploying"
}

main
