#!/usr/bin/env bash

PROJECT_NAME="NULL"

main() {
	PROJECT_NAME="$1"
	create_directory
	fetch_problem
	parse_input_output
	copy_templates

}

chomp_open() {
    
}

chomp_close() {

}

# Parse example input and output
parse_input_output() {
    input_output=$(sed -n -e '/<pre>/,/<\/pre>/ p' "$PROJECT_NAME.html")

    #echo "$input_output"
    input=$(echo "$input_output" | sed '/<\/pre>/q')
    #echo "$input"
    #input_output=${input#"$input_output"}
    #echo "$input_output"


    length=${#input}
    echo "${input_output:length}"
    

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
	curl -s "https://open.kattis.com/problems/$PROJECT_NAME" > "$PROJECT_NAME.html"
	# Check if curl was successful
	if [[ "$?" != "0" ]]; then
		die "Cant find project name: $PROJECT_NAME"
	fi
}

copy_templates() {
	# Parse templates to update variables
	parse_templates
	echo "$MAKEFILE_TEMPLATE" > Makefile
	echo "$MAIN_TEMPLATE" > main.cpp

}

# Print an error and then exit unsuccesfully
die() {
	echo "$1"
	exit 1
}

# Update templates with latest variables
parse_templates() {

MAKEFILE_TEMPLATE="
all: 
	${CXX} -o $PROJECT_NAME main.cpp

run: all
	./$PROJECT_NAME

"

MAIN_TEMPLATE="
int main() {


return 0;
}
"

}

main "$@"
