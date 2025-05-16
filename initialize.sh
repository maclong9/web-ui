#!/bin/sh
PROJECT_NAME=$1
git clone --quiet https://github.com/maclong9/web-ui-example
if [ ! "$1" ]; then
    PROJECT_NAME="example"
else
    sed -i '' "s/example/$PROJECT_NAME/g" "$PROJECT_NAME"/Package.swift
    sed -i '' "s/example/$PROJECT_NAME/g" "$PROJECT_NAME"/Sources/Application.swift
fi
mv web-ui-example "$PROJECT_NAME"
rm -rf "$PROJECT_NAME/.git"
printf '\033[1;32m✓\033[0m \033[1;32m%s\033[0m initialisation complete
Run \033[1;33mcd %s && swift run\033[0m to build
your static site to the \033[1;36m.output\033[0m directory.' "$PROJECT_NAME" "$PROJECT_NAME"
