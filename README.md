# Kitty

Kitty is a tool to setup kattis work folders.

Please consider that it is deemed bad practice to keep your solutions to kattis
problems in public repositories.

Given a kattis problem name kitty will create a folder with a makefile that can
be used to compile and test your solution written in c++ against the public
testcases found on the problem page.

## Usage

To set up a project for the kattis problem
[zamka](https://open.kattis.com/problems/zamka), simply run:

```
$ kitty zamka
```

This will create a directory of name zamka containing three files.
    - A main.cpp skeleton where your c++ code will go.
    - A Makefile skeleton which can be used to compile and run your code as well as test it using the testcases found on the problem webpage.
    - A directory called tests where the testcases from the problem page will be found automatically.

Example usage of the Makefile

```
// Compile main.cpp
make

// Compile and run main.cpp with stdin and stdout coupled to the command line
make run

// Compile and run testcases by automatically feeding it all input files from /tests/input_X.txt checking it to the expected output in /tests/output_X.txt
make tests
```
