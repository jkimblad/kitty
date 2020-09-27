#!/usr/bin/env bash

PROJECT_NAME="NULL"

main() {
    PROJECT_NAME="$1"
    create_directory
    fetch_problem
    #copy_templates


}

# Setup project directory
create_directory() {
    if [[ -d "$PROJECT_NAME" ]]; then
	die "Project directory already exists, exiting"
    fi
    mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
}


fetch_problem() {
    # CURL to get test cases
    curl "https://open.kattis.com/problems/$PROJECT_NAME" > "$PROJECT_NAME.html"
    # Check if curl was successful
    if [[ "$?" != "0" ]]; then
	die "Cant find project name: $PROJECT_NAME"
    fi
}

echo "$MAKEFILE_TEMPLATE" > Makefile
echo "$MAIN_TEMPMLATE" > main.cpp



die() {
    echo "$1"
    exit 1
}

MAKEFILE_TEMPLATE="

"

MAIN_TEMPLATE="
int main() {


return 0;
}
"

main "$@"
