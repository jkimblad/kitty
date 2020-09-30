#!/usr/bin/env python3

# Copyright (c) 2020 Jacob Kimblad #

import os
import sys
import requests
import re
from html.parser import HTMLParser


def main():
    if len(sys.argv) < 2:
        print("Usage: kitty [problem_name]")
        exit()

    problem_name = str(sys.argv[1])

    create_directories(problem_name)
    problem_html = fetch_problem(problem_name)
    parse_testcases(problem_html, problem_name)
    copy_templates(problem_name)


def create_directories(problem_name):
    path = problem_name + "/tests"
    try:
        os.makedirs(path)
    except OSError:
        print("Creation of directory %s failed!" % path)

def fetch_problem(problem_name):
    problem_url = "https://open.kattis.com/problems/" + problem_name
    return requests.get(problem_url).text

def parse_testcases(problem_html, problem_name):
    class MyHTMLParser(HTMLParser):
        is_example = False
        is_input = False
        example_counter = 0
        example = []

        def handle_starttag(self, tag, attrs):
            if tag == "pre":
                self.is_input = not self.is_input
                self.is_example = True

        def handle_endtag(self, tag):
            if tag == "pre":
                self.is_example = False

        def handle_data(self, data):
            if self.is_example:

                # Is input example
                if self.is_input:
                    filename = problem_name + "/tests/input_" + str(self.example_counter) +".txt"
                else:
                    # Is output example
                    filename = problem_name + "/tests/output_" + str(self.example_counter) +".txt"
                    self.example_counter += self.example_counter + 1

                example_file = open(filename, "w+")
                example_file.write(data)
                example_file.close()


    parser = MyHTMLParser()
    parser.feed(problem_html)

def copy_templates(problem_name):

    templates = populate_tempates(problem_name)
    files = [{
        "filename" : "/Makefile",
        "template" : templates[0]
        },
        {
        "filename" : "/main.cpp",
        "template" : templates[1]
        }]
    
    for file_template in files:
    # Create makefile from template
        f = open(problem_name + file_template["filename"], "w+")
        f.write(file_template["template"])
        f.close()

def populate_tempates(problem_name):
    makefile_template = """
SHELL := /bin/bash

all: 
	${CXX} -o """ + problem_name +  """ main.cpp

run: all
	./""" + problem_name + """

define run_tests =
num_of_tests=$(expr $(ls -l | wc -l) / 2)
current_test=0

while [[ "$current_test" != "$num_of_tests" ]]; do
    echo "Running test case $current_test"
    output=$(cat tests/input_"$current_test".txt | ./""" + problem_name + """)
    if [[ $output == $(cat tests/output_"$current_test".txt) ]]; then
	echo "[PASS]"
    else
	echo "[FAIL]"
    fi

    current_test=$(($current_test + 1))
done

endef

tests: all ; @$(value run_tests)
.ONESHELL:



"""

    maincpp_template = """
#include <iostream>

int main() {


    return 0;
}
"""
    return [makefile_template, maincpp_template]


if __name__ == "__main__":
    main()
