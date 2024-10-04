#!/bin/bash

for module in \
    helpers \
    ansible/roles/*
do
    ./helpers/update_and_commit_git_module.sh "${module}"
done

exit 0
