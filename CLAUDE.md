# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo is part of a hackathon series to learn prompt engineering.
My tool of choice is Claude Code.

I aim to create 3D models programmatically with prompt engineering.

This repository contains OpenSCAD-based 3D models designed for 3D printing. OpenSCAD is a script-based CAD system that allows programmatic generation of 3D models using a C-like syntax.

## Project Structure

```
root/
├── README.md                    # Project overview
├── LICENSE                      # Project license
├── CLAUDE.md                    # This file
├── docs/                        # Documentation and cheatsheets
│   └── CHEATSHEET.md           # OpenSCAD syntax reference
├── scripts/                     # Automation scripts
│   └── generate_previews.sh    # PNG preview generation (multiple angles)
├── lib/                         # Reusable component libraries
│   ├── boxes_and_plates.scad   # Box, plate, mounting components
│   ├── mechanical_and_utility.scad  # Joints, cables, ventilation
│   ├── icon_library.scad       # Decorative icons (WiFi, temp, etc.)
│   └── README.md               # Library documentation
├── projects/                    # Individual build projects
│   ├── box_with_lid/           # Example: box with lid project
│   │   ├── case.scad           # Main model file
│   │   ├── export_stl.sh       # STL export script
│   │   ├── previews/           # Generated preview images
│   │   └── output/             # Generated STL files
│   └── [other_projects]/
├── playground/                  # Experimental work and tests
│   ├── 002_reusable_shapes/
│   └── 003_common_components/
└── prompts/                     # Prompt engineering audit log
    └── claude.md               # Conversation prompts and improvements
```

## Development Commands

### Exporting STL Files

Each project directory contains an `export_stl.sh` script:

```bash
cd projects/<project_name>
bash export_stl.sh
```

This generates STL files in the `output/` subdirectory.

### Generating Preview Images

Use the preview generation script to create PNG previews with multiple viewing angles:

```bash
bash scripts/generate_previews.sh [OPTIONS] <scad_file>
```

**Generated views:**
- `perspective.png` - Default 3D perspective view
- `top.png` - Top-down orthographic view
- `front.png` - Front orthographic view
- `left.png` - Left side orthographic view
- `wireframe.png` - Wireframe view
- `blueprint.png` - Technical blueprint style (monotone, top orthographic)

**Options:**
- `-o, --output DIR` - Output directory (default: ./previews)
- `-s, --size WxH` - Image size (default: 1024x768)
- `-p, --part NAME` - Render specific part (for multi-part models)
- `-c, --colorscheme NAME` - Color scheme (default: Tomorrow)
- `-d, --distance NUM` - Camera distance (default: 200)

**Examples:**
```bash
# Generate all views for a model
bash scripts/generate_previews.sh projects/box_with_lid/case.scad

# Generate previews for specific part
bash scripts/generate_previews.sh -p "lid" projects/box_with_lid/case.scad

# Custom size and output directory
bash scripts/generate_previews.sh -s 1920x1080 -o ./images model.scad
```

### Optimizing PNG Files for Git

Compress PNG preview images to reduce repository size:

```bash
make optimize-pngs                    # Optimize all PNGs recursively
make optimize-pngs DIR=projects       # Optimize specific directory
make optimize-pngs DRY=1              # Dry run (preview changes)
```

**Direct script usage:**
```bash
bash scripts/optimize_pngs.sh -r -q 65-80 .
```

**Options:**
- `-r, --recursive` - Search recursively
- `-q, --quality RANGE` - Quality range (default: 65-80)
- `-s, --speed LEVEL` - Speed 1-11 (default: 3)
- `-d, --dry-run` - Preview without modifying

**Requirements:**
```bash
# macOS
brew install pngquant optipng

# Linux
apt-get install pngquant optipng

# Or use Makefile
make install-deps
```

Typical compression: 50-70% size reduction with minimal visual quality loss.

### Makefile Commands

The project includes a Makefile for common tasks:

```bash
make help           # Show available commands
make optimize-pngs  # Compress all PNG files
make render-all     # Generate STL files for all projects
make test-previews  # Generate previews for all projects
make clean          # Remove generated files
make install-deps   # Install required dependencies
```

### Manual OpenSCAD Commands

Export STL manually:
```bash
openscad -o output/part.stl -D 'render_part="box"' model.scad
```

Generate single PNG preview:
```bash
openscad -o preview.png --imgsize=1024,768 --colorscheme=Tomorrow \
         --autocenter --viewall model.scad
```

### Build Verification

**CRITICAL: Always verify that models build successfully after creation or modification**

When you finish creating or modifying a model:

1. Navigate to the project directory
2. Run the export_stl.sh script
3. Check for build errors in the output
4. Verify that STL files are generated in the `output/` directory
5. Generate preview images using `scripts/generate_previews.sh`

Example workflow:
```bash
cd projects/box_with_lid
bash export_stl.sh
bash ../../scripts/generate_previews.sh case.scad
```

Expected output should show successful exports without errors. If OpenSCAD reports syntax errors, parsing errors, or warnings, fix them before considering the task complete.

**This step is mandatory** - Do not consider a model "done" until you have successfully run the export script, verified the build, and generated preview images.

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
- Include clearances (0.2mm) for friction fit, 0.3-0.5mm for loose fit
- Screw holes are designed with appropriate diameters for M3 screws (3.2mm)
- Ventilation slots are rectangular or hexagonal cutouts for airflow
- Corner posts use cylinders with threaded holes for assembly

### Module Organization

OpenSCAD supports modular code organization:

- **`use <filename.scad>`** - Import only modules/functions (not top-level code) - recommended
- **`include <filename.scad>`** - Import everything including top-level code

Example usage:
```openscad
use <../lib/boxes_and_plates.scad>
use <../lib/mechanical_and_utility.scad>

parametric_box(width=100, depth=80, height=40, wall_thickness=2);
```

Use relative paths for imports. From projects:  `../lib/module.scad`. From playground: `../../lib/module.scad`.

## Component Library

See `lib/README.md` for detailed documentation of available reusable modules:

**Boxes & Mounting:**
- `parametric_box()`, `mounting_plate()`, `screw_post()`, `pcb_standoff()`

**Mechanical Joints:**
- `snapfit_male()`, `snapfit_female()`, `living_hinge()`

**Cable Management:**
- `cable_clip()`, `cable_guide()`, `ventilation_grid()`

**Decorative:**
- `wifi_icon()`, `temperature_icon()`

## Audit Protocol

**IMPORTANT: After each conversation, audit all user prompts and save them to `prompts/claude.md`**

Format requirements:
1. **User prompts**: Start line with `>` symbol, add blank line after
2. **Improvement suggestions**: Start line with `?` symbol, add blank line after
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
3. **New functions** - Add to docs/CHEATSHEET.md and lib/README.md files
4. **Folder reorganizations** - Update Project Structure section
5. **Prompt audits** - Update prompts/claude.md after each conversation
6. **Preview generation** - Always generate preview images for new projects
