#!/usr/bin/env bash

PROJECT_NAME="NULL"
NUM_EXAMPLES=0

main() {
	PROJECT_NAME="$1"
	create_directory
	fetch_problem
	parse_input_output
	copy_templates

}

chomp_open() {
    chomp=$(echo "$1" | sed '/<pre>/q')
    chomp_length=${#chomp}
    remainder=${1:chomp_length}


    # Return remainder
    echo "$remainder"
}

chomp_close() {
    chomp=$(echo "$1" | sed '/<\/pre>/q')
    chomp_length=${#chomp}
    remainder=${1:chomp_length}

    # Save as example input 
    if [[ "$2" == "input" ]]; then
	echo "$chomp" > "tests/input_$3.txt"
    elif [[ "$2" == "output" ]]; then
	# Save as example output
	echo "$chomp" > "tests/output_$3.txt"

    fi

    echo "$remainder"

}

# Parse example input and output
parse_input_output() {
    input_output=$(sed -n -e '/<pre>/,/<\/pre>/ p' "$PROJECT_NAME.html")

    example_num=0
    while [[ ! -z "$input_output" ]]; do
	# Save input
	$input_output=$(chomp_open "$input_output")
	$input_output=$(chomp_close "$input_output" input $example_num)
	# Save output
	$input_output=$(chomp_open "$input_output")
	$input_output=$(chomp_close "$input_output" "output" $example_num)
    done

}

# Setup project directory
create_directory() {
	if [[ -d "$PROJECT_NAME" ]]; then
		die "Project directory already exists, exiting"
	fi
	mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
	mkdir "tests"
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
