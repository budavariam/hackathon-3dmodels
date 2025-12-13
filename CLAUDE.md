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

### Build Verification

**CRITICAL: Always verify that models build successfully after creation or modification**

When you finish creating or modifying a model:

1. Navigate to the model directory
2. Run the export script
3. Check for build errors in the output
4. Verify that STL files are generated in the `output/` directory

Example workflow:
```bash
cd src/002_reusable_shapes
bash export.sh
```

Expected output should show successful exports without errors. If OpenSCAD reports syntax errors, parsing errors, or warnings, fix them before considering the task complete.

**This step is mandatory** - Do not consider a model "done" until you have successfully run the export script and verified the build.

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

### Module Organization

OpenSCAD supports modular code organization:

- **`use <filename.scad>`** - Import only modules/functions (not top-level code)
- **`include <filename.scad>`** - Import everything including top-level code

Example structure:
```
src/002_reusable_shapes/
  ├── icon_library.scad        # Reusable module definitions
  └── 002_reusable_shapes.scad # Main file using: use <icon_library.scad>
```

Use relative paths for imports: `use <icon_library.scad>` when files are in the same directory.

## Audit Protocol

**IMPORTANT: After each conversation, audit all user prompts and save them to `prompts/claude.md`**

Format requirements:
1. **User prompts**: Start line with `>` symbol, add blank line after
2. **Improvement suggestions**: Start line with `>?` symbol, add blank line after
3. **Content**: Save prompts without answers or long code blocks
4. **Purpose**: Track prompt engineering learning process

Example format:
```
> user prompt text here

? Suggestion on how to improve this prompt for better results

> next user prompt

? Next improvement suggestion
```

## Maintenance

**Keep this file updated throughout development:**

1. **New commands/workflows** - Add to Development Commands section
2. **New patterns/conventions** - Add to OpenSCAD Model Architecture section
3. **New functions** - Add to docs/CHEATSHEET.md file
4. **Folder reorganizations** - Update Project Structure section
5. **Prompt audits** - Update prompts/claude.md after each conversation