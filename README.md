# RISC V SystemVerilog Model
Project to expand on a SystemVerilog RISC-V Model originally started as class project. 

<!-- Image/link format
![Name](folder/name.file) spaces encoded as %20
-->

## Table of Contents

- [Description](#description)
- [Design](#design)
- [Current State](#current-state-of-the-project)
- [Post Project Notes](#post-project-notes)
- [Installation](#installation) <!-- Should I have Installation and Usage above or below the Design, Current State, Changes, etc? -->
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Description

The goal of this project is to expand on the RISC-V SystemVerilog Model that started as a class group project fro my Introduction to SystemVerilog course. There are multiple tasks/end goals for the project and ideally more will be added as the project continues and as tasks are completed. 

General Tasks:
- [X] Code Refactoring
- [ ] Add Pipelining to the Model (without forwarding)
- [ ] Add Forwarding to the Pipeline Model
- [ ] Ensure the model synthesizable
- [ ] Add Emulation Support
- [ ] Emulate the model (If resources are available)
- [ ] Create and Add a Cache Model
- [ ] Multi-Core CPU Model

Model Extensions Tasks:
- [ ] Add the Integer Multiplication & Division Extension
- [ ] Add the Atomic Instructions Extension
- [ ] Add the Single-Precision Floating Point Extension
- [ ] Add the Double-Precision Floating Point Extension
- [ ] Add the Quad-Precision Floating Point Extension
- [ ] Add the Compressed Instrcution Extension
- [ ] Expand the model to 64 or 128 bit


## Designs

**Code Refactoring**
During the initial conversion to SystemVerilog, the decision was made to handle each instruction type differently, instead of using a unique case statement for each one. This was originally done to show our understanding of SystemVerilog but is unnecessary in the long run and also makes certain parts of the code difficult to read. For example, the I-Type module used a mux module that was a large nested ternary statement. In addition, more enumarated variables were added to the package file to make the case statements for each instruction more readable and reduce the chance of coding errors in the future. 

In addition, I updated the testbenches for the individual modules as they were designed before the interface was added to the design. While I was updating the testbenches to work with the interface, I also changed how the testbenches output information to the terminal. Most of the testbenches simply displayed the output with no context. I modified them to display the current state of relevant variables (Source Registers, Current Instruction, etc) as well as a pass/fail metric. 

In the CPU model itself, the instruction decode section of the code was a long case statement that set certain control variables within the interface depending on the instruction being processed. This section could be simplified by creating functions to set these variables and attaching these function to the interface itself since every variable was already apart of the interface. 

The main goal of the code refactor was to gain a thorough understanding of how each section of the code works as well as to create some uniforminity in the code base and to that end I was mostly successful. There is more that could be done to increase the readability of the model and testbenches such as adding better commenting. 


**Pipelining (wihtout Forwarding)**


<!--
**Synthesize Model**


**Emulation Support**



**Cache Model Addition (Separate Repo Project?)**


**Extension Modules**

-->

## Current State of the Project

The project is current in the planning and Code Refactoring stage of the project. 
Most of the modules have been modified but are untested. 


## Post Project Notes

<!-- Text -->


## Installation/Setup

<!-- What EDA libraries and files are needed for this project? -->


<!--
## Usage

Provide instructions and examples for use. Include screenshots as needed.

To add a screenshot, create an `assets/images` folder in your repository and upload your screenshot to it. Then, using the relative filepath, add it to your README using the following syntax:

    ```md
    ![alt text](assets/images/screenshot.png)
    ```

## Features

If your project has a lot of features, list them here.

## Tests/Simulation

-->

## Credits

<!-- List your collaborators, if any, with links to their GitHub profiles. -->


<!-- If you used any third-party assets that require attribution, list the creators with links to their primary web presence in this section. -->
<!-- Link the Symbols and Footprints used? -->

## License

<!-- Licensed under the [CERN-OHL-S-2.0](LICENSE.txt) License -->