# Advent Calendar Project

24-door advent calendar with snap-fit hinges and flat embossed numbers.

## Design Features

- **Box dimensions**: 400mm x 500mm x 60mm (vertical orientation)
- **Grid layout**: 6 columns x 4 rows (uniform)
- **Door sizes**: All doors same size (rectangular, ~65mm x 122mm each)
- **Door numbers**: Randomized 1-24 using seed (repeatable)
- **Snap-fit hinges**: 3mm diameter pins with 0.2mm clearance
- **Numbers**: Flat embossed 1.5mm with gold color (not beveled)

## Getting Started

### Prerequisites

- OpenSCAD installed (version 2021.01 or later)
- Command line access (Terminal on macOS/Linux)

### Generate STL Files

Navigate to the project directory and run the export script:

```bash
cd projects/advent_calendar
bash export_stl.sh
```

This generates:
- `output/advent_box.stl` - Main calendar box (~12 seconds)
- `output/all_doors.stl` - All 24 doors for batch printing (~53 seconds)
- `output/door_1.stl`, `door_7.stl`, `door_18.stl`, `door_24.stl` - Sample individual doors

**Total export time:** ~1-2 minutes

### Generate Preview Images

From the project directory, run:

```bash
# Generate all standard views (perspective, top, front, left, wireframe, blueprint)
bash ../../scripts/generate_previews.sh case.scad

# Generate previews for specific parts
bash ../../scripts/generate_previews.sh -p "box" case.scad
bash ../../scripts/generate_previews.sh -p "all_doors" case.scad
bash ../../scripts/generate_previews.sh -p "door_1" case.scad

# Custom size and output directory
bash ../../scripts/generate_previews.sh -s 1920x1080 -o ./images case.scad
```

Preview images are saved to `previews/` directory by default.

### Verify Build Success

After running the export script, verify:

1. Check that all STL files exist in `output/` directory
2. No OpenSCAD errors in terminal output
3. File sizes look reasonable:
   - `advent_box.stl` ~535KB
   - `all_doors.stl` ~1.7MB
   - Individual doors ~20-100KB each

## Printing Recommendations

**Box:**
- Layer height: 0.2mm
- Infill: 20%
- Supports: Build plate only
- Material: PLA or PETG
- Print time: ~10-12 hours

**Doors (all 24):**
- Layer height: 0.15mm
- Infill: 100% (for hinge strength)
- Supports: None needed
- Material: PLA recommended
- Print time: ~6-8 hours

## Assembly

1. Print box and all 24 doors
2. Test fit door hinges (should snap in with light pressure)
3. If hinges too tight: sand hinge pins slightly
4. If hinges too loose: increase hinge diameter in code
5. Doors should swing open smoothly and stay closed with snap catch

## Customization

Edit `case.scad` parameters:
- `box_width`, `box_height`, `box_depth` - Box dimensions
- `door_thickness` - Door panel thickness
- `hinge_diameter` - Hinge pin size
- `hinge_clearance` - Fit adjustment (0.2mm default)
- `number_depth` - How deep numbers are beveled
- `door_configs` array - Rearrange door sizes/positions

## Files

- `case.scad` - Main OpenSCAD model
- `export_stl.sh` - STL export script
- `output/advent_box.stl` - Main calendar box
- `output/all_doors.stl` - All 24 doors for batch printing
- `output/door_N.stl` - Individual door samples
- `previews/` - Generated preview images
