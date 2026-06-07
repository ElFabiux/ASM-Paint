# ASM-Paint

Low-level paint application developed in x86 Assembly for the DOS environment. The project provides a simple pixel-based drawing canvas using VGA graphics mode, keyboard input, and BIOS interrupts.

## Overview

ASM-Paint is a technical project focused on low-level graphics programming. The application allows users to move a brush across the screen, draw pixels, change colors, and clear the canvas using keyboard controls.

The project demonstrates how classic DOS applications interact directly with hardware-level services through BIOS interrupts, including video mode initialization, keyboard input handling, pixel rendering, and screen management.

## Key Features

* 16-bit DOS application written in x86 Assembly
* VGA 640x480 graphics mode with 16 colors
* Pixel-based drawing system
* Keyboard-controlled brush movement
* Color selection using numeric keys
* Canvas clearing functionality
* BIOS interrupt usage for video and keyboard operations
* Small memory model with code, data, and stack segments
* Automated build process using TASM and TLINK

## Tech Stack

* X86 Assembly
* TASM
* TLINK
* DOSBox
* VGA Graphics
* BIOS Interrupts

## Architecture

The project is built as a real-mode DOS application using a single Assembly source file. The program initializes the data segment, switches the display to VGA graphics mode, and enters a continuous event loop that listens for keyboard input.

The application logic is organized around three main areas:

### Initialization

The program sets up the data segment, initializes the graphics mode, clears the screen, and prepares the brush state.

### Event Loop

The main loop continuously checks for keyboard input. Depending on the key pressed, the program moves the brush, changes the active color, or clears the canvas.

### Drawing and Screen Management

Drawing is performed by writing individual pixels to the screen using BIOS video interrupts. The current brush position and selected color are stored in the data segment and updated during user interaction.

## Controls

* **Arrow Keys:** Move the brush
* **1 - 0:** Change the active drawing color
* **L:** Clear the canvas

## Getting Started

The project is designed to run in a DOS-compatible environment, usually through DOSBox.

### Requirements

* DOSBox
* TASM
* TLINK

### Running the Application

Mount the project folder in DOSBox:

```bash
mount c C:\Path\To\ASM-Paint
```

Switch to the mounted drive:

```bash
c:
```

Run the build script:

```bash
ASM.BAT
```

The script assembles the source code, links the object file, and runs the final executable.

## Project Purpose

This project was created to explore low-level programming concepts such as graphics rendering, keyboard input handling, memory organization, BIOS interrupts, and DOS application development. It demonstrates strong understanding of computer architecture, Assembly programming, and how software interacts with hardware-level services.
