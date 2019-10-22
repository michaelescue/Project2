# ECE 540 Project #2 -- The Rojobot World
## <b>This assignment is worth 100 points.  Demos on Tue, 19-Feb and Wed 20-Feb.  Deliverables are due to GitHub on Fri, 22-Feb by 10:00 PM.  </b>

### <i> You will do your development using Xilinx Vivado for hardware and C4E (Codescape for Eclipse) for software.  You may also use the MIPS GCC command line tools if you would prefer to.    You should submit your assignment before the deadline by pushing your final deliverables to your shared GitHub repository for the assignment.  

#### NOTE:  The use of GitHub and GitHub classroom is required for this project.</i>

## Learning Objectives
- Gain experience designing an SoC with an embedded CPU, 3rd party IP and custom hardware
- Gain experience implementing an icon-based VGA video controller
- Gain experience writing assembly language for the MIPSfpga softcore CPU
- Learn SoC simulation (optional) and debug techniques


### Introduction

This project builds on the SimpleBot concepts introduced in Project 1 by placing a virtual two-wheeled mobile platform with proximity and IR sensors (for black line following) into a virtual world. The mobile platform and its world are emulated in an IP (intellectual-property) block called Rojobot31. Rojobot31 is a SoC design in its own right containing a Xilinx Picoblaze, firmware in program memory and logic to manage its interface.  This functionality has been wrapped in a Vivado IP block that can be added to your design without having to understand the details of the implementation. You can treat Rojobot31 as a “black box” that can be monitored and controlled from an application CPU (in this case a MIPSfpga system).

You will be provided with small sections of the hardware design, a demo program (Proj2Demo) to test your implementation and plenty of documentation.  The system you built for Project #1 is the jumping off point for the hardware for this project but you will need to add new circuitry, primarily a memory mapped I/O interface to the Rojobot registers.  The Rojobot registers could be added to the existing mpg_ahb_gpio module or you could implement an additional AHB-Lite slave for the Rojobot registers much like you did for the 7-segment display for Project #1.  There are advantages and disadvantages to both approaches, but the design decision is yours to make.  You will also be provided with an ECE540_IP repository that contains the Rojobot31 IP.  This IP block can be added to your design in a manner similar to the way you added the clock generator in Project #1 using the Vivado IP Integrator.     

The deliverables for this project will be a successful demo for the T/A or Grader, a theory of operation for your implementation, Verilog or SystemVerilog code for your peripheral and VGA controller and source code for your black line following assembly language program.

### 	Project teams
You will do this project in teams of 2 like Project #1.  Our preference is that you stay in the same teams as you did for Project #1 but you may change partners if both partners agree.  Since both members of the team will receive the same grade it is important to meet with me (Roy) confidentially as early in the project as you can if the partnership isn't working out.  The longer you wait the more difficult it is for us to make corrections.

We will be using the team project support in GitHub classroom for this assignment.  This means that your team will share a private repository on GitHub that can also be accessed by the instructor, Grader, and T/A for the course. You will submit your work via a private repository using GitHub classroom.  

#### Tutorials on using git and GitHub:
- Edureka (1hr, 45 min): https://www.youtube.com/watch?v=xuB1Id2Wxak
- TraversyMedia (32 min): https://www.youtube.com/watch?v=SWYqp7iY_Tc&t=96s

### Tutorials on using version control systems such as Git/GitHub with Vivado
- Xilinx Quicktake video (~ 11 minutes)  https://www.youtube.com/watch?v=L17LvqkAv28
- [Vivado Design Flows Overview](git_vivado/ug892-vivado-design-flows-overview.pdf)
- [Vivado Revision Control Tutorial](git_vivado/ug1198-vivado-revision-control-tutorial.pdf)
- [Xilinx Application Note 1165](git_vivado/xapp1165.pdf)
- [Xilinx Application Note 1165 examples](git_vivado/xapp1165.zip)


### To manage your project under GitHub classroom:
1. Install the Git tools (can be downloaded from https://git-scm.com/) on the PC your are using for the course and create a GitHub account (if you do not already have one)
2. Log into your GitHub account, open a new window in your browser, and copy/paste the link for the assignment (link will be posted to D2L).  You will have to authorize your account for the GitHub classroom course for the course (first time only) and accept the assignment.
3. Once you accept the assignment you should be emailed a link to your private repository for the project. Save that link.
4. Create your project in Vivado.
6. Develop your code, pushing to your private repository to GitHub following the guidelines for using version control with Vivado
7. When you have finished the project, write your Theory of Operation and include it in your repository.
8. Do a final push of your deliverables to the private repository for the project before the deadline.

## Deliverables
Push your deliverables to your private GitHub repository for the assignment.  The repository should include:
- Your Theory of Operation (.pdf preferred).
- A final version of the Verilog and MIPS assembly language. code for all of the files you created or modified.  “Neatness counts” for this project - we will grade the quality of your code.  You code should be well structured, indented consistently (editors like NotePad++ help with this) and you should include comments describing what long sections of your code do.    Comments should be descriptive rather than explain the obvious (ex:  //set a to b when the actual code says a = b; does not provide any value-added).  Your team stands to lose many points if your code is poorly commented and/or structured and is difficult for us to follow.

## A final word before you begin
This project is significantly more complex than the first project. In fact, in all of the years I've been using the Rojobot program and its predecessors I can't point to a single team who got the project working the first time.  Projects of this nature tend to fail during integration and testing so leave plenty of time to put the pieces together and get them working.   The order of tasks that I listed in class when I introduced the project is a logical way to organize the project, bringing up the design in incremental steps, each building on functionality that has been tested earlier.   Do not wait to start this project.  There is plenty of reading, a fair amount of design work, and a goodly amount of development work and ~two weeks is not a lot of time.
