# ClarionMultiLanguage
Example of multilanguage programming in Clarion featuring Knapsack problem/0-1

This is a sample program including comparable procedures that implement an algorithm to solve the Knapsack problem/0-1 implemented in Assembly, C, Clarion and Modula-2 languages integrated into a Clarion Solution and are compiled together.

### This project shows and serves as:

- a "Hello World" application showing the ability of Clarion IDE to edit and compile using different programming languages available in Softvelocity Clarion package (Clarion, and TopSpeed C, Modula-2, Assembler) that works even not installing the header files for the different languages, ready to download, open and compile project
- a practical example in real world applications to find the first subset of values that sums the requested amount, as the first solution to the KnapSack problem/0-1 using concepts of memoization and "linked lists" over arrays.
- being a more complex algorithm than a simple Hello World application, it offers a certain simplicity to be able to focus attention on the languages, all presented in source code, offering visually the possibility of comparing the differences and similarities of the different languages included with each other, as well as the differences and similarities with other implementations of C, Modula-2 and Assembler according to the interest and previous knowledge of the observer.
- serves as proof that it is possible to compile different languages, since, even noting that the finished and working code seems simple, when you start from scratch you may find different inconveniences and error messages that are not always clear or specific enough, and programmers might stop trying due to such inconveniences.
- a procedure calling by address technique with indirect branches
- a guide with some references mentioning documents and sites of interest related to the included languages 
- an editable project having the possibility using the Clarion IDE to change test values, recompile and run, and to use Clarion debugger to run and follow the logic flow of the algorithm in the different languages
- a project tested on Clarion 10.0.12799 and Clarion 11.0.13244, but that could be opened in previous versions, plus another prj file generated with Clarion 5, and a subproject adapted for CDD3&TS with following restrictions: Assembler and C version: 16bit values and max amount, Modula2: 16bit max amount, Clarion: 32bit values and max amount but using a fixed small array on main.

## Expected outputs

### C11
![C11](https://github.com/federico-navarro/ClarionMultiLanguage/blob/main/Captures/KnapLiteC11.png?raw=true)

### C5
![C5](https://github.com/federico-navarro/ClarionMultiLanguage/blob/main/Captures/KnapLiteC5.png?raw=true)

### C3
![C3](https://github.com/federico-navarro/ClarionMultiLanguage/blob/main/Captures/KnapLiteC3.png?raw=true)


# KnapSack project
Includes KnapLite and provides a user interface to automate tests

### Additionally to the features mentioned for KnapLite project, this project shows and serves as:

- a user interface to show current and historic results
- a sample data generator with different methods, random, delta intervals, sorting and shuffling and manual editing
- preloaded data with previous results and provides other test data sets
- a benchmarking tool for the different algorithms
- a portable benchmarking tool for different computers with shareable results through its data files
- a RAM memory consumer and CPU stressing tool for hardware testing
- a simulation of invoices amounts stored on integer fields, e.g., previously multiplied by 100 to have 2 decimal precision
- shows the exponential behavior of the algorithm as the data and amount grow
- an appgen project for C10 and C11 (with auto conversion) and txa/txd files for previous versions

## Sample outputs

### KnapSack Console with Lite project values
![LiteValues](https://github.com/federico-navarro/ClarionMultiLanguage/blob/master/Captures/KnapSackLiteValues.png?raw=true)

### KnapSack Console with large values
![Large](https://github.com/federico-navarro/ClarionMultiLanguage/blob/master/Captures/KnapSackLarge.png?raw=true)
