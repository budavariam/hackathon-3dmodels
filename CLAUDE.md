# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo is part of a hackathon series to learn prompt engineering.
My tool of choice is Claude Code.

I aim to create 3d models programmatically with prompt engineering.

This repository contains OpenSCAD-based 3D models designed for 3D printing. OpenSCAD is a script-based CAD system that allows programmatic generation of 3D models using a C-like syntax.

## Development Commands

### Exporting STL Files

Each model directory contains an export script to convert OpenSCAD files to STL format:

```bash
cd src/<model_directory>
bash <number>_export.sh
```

Example:
```bash
cd src/1_box_with_lid
bash 1_export.sh
```

This generates STL files in the `output/` subdirectory within the model folder.

### Manual OpenSCAD Export

To export specific parts manually:

```bash
openscad -o output/part_name.stl -D 'render_part="box"' model_file.scad
```

Replace `render_part` value with the desired part name (e.g., "box", "lid", "both").

## Project Structure

- `src/` - Contains model directories, the fodler name starts with an increasing 3zero padded number id and a short name.
  - `*.scad` - OpenSCAD source files defining the 3D models
  - `export.sh` - Shell scripts to export models to STL format
  - `output/` - Generated STL files (created by export scripts)
- `prompts/` - Development notes and AI prompts used during model creation
- `docs/` - Documentation files, cheatsheets

## OpenSCAD Model Architecture

Models follow a parametric design approach:

1. **Parameters Section** - Adjustable dimensions at the top of each `.scad` file (width, height, thickness, clearances, etc.)
2. **Module Definitions** - Reusable components defined as OpenSCAD modules
3. **Render Logic** - Conditional rendering using `render_part` variable to generate different parts separately
4. **Boolean Operations** - Uses `difference()` and `union()` to create complex shapes from primitives

### Common Patterns

- Use `render_part` variable to control which components are generated
- Define all dimensions as variables at the top for easy adjustment
- Include clearance parameters for parts that must fit together
- Use modules to encapsulate reusable geometry

### Model Design Conventions

- Wall thicknesses typically 2mm for structural integrity
- Include clearances (0.2mm) between fitting parts
- Screw holes are designed with appropriate diameters for M3 screws
- Ventilation slots are rectangular cutouts for airflow
- Corner posts use cylinders with threaded holes for assembly

## File Naming Convention

Model folders use 3-zero padded numbered prefixes (e.g., `001_box_with_lid/`, `export.sh`) to maintain ordering and track development sequence

## Audit

IMPORTANT: Audit the prompts and save them to prompts/claude.md without the answers and long code blocks. starting the line with `>` symbol and add a newline after the prompt.

IMPORTANT: after each answer provide a suggestion on how to make a better prompt at the end of the answer. add this suggestion to `prompts/claude.md` after `?` symbol and follow ith with a newline

## Updating

Keep this file up to date with new requests or folder reorganizations throughout the development.

Whenever a new funtion is introduced add it to docs/CHEATSHEET.md file