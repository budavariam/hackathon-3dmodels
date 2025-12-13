# Component Library

Reusable OpenSCAD modules for 3D printing projects.

## Available Modules

### boxes_and_plates.scad

Foundation components for enclosures and mounting:

- **`parametric_box()`** - Customizable box with rounded corners and optional lid rim
  - Parameters: width, depth, height, wall_thickness, corner_radius, has_lid_rim

- **`mounting_plate()`** - Flat plate with customizable mounting holes
  - Parameters: width, depth, thickness, corner_radius, hole_positions, hole_diameter

- **`screw_post()`** - Cylindrical mounting pillar with screw hole
  - Parameters: height, outer_diameter, screw_diameter, base_diameter, base_height

- **`pcb_standoff()`** - PCB mounting standoff (screw or snap-fit)
  - Parameters: height, pcb_thickness, hole_diameter, mount_type, outer_diameter

- **`mounting_hole_pattern()`** - Generate grid or circular hole patterns
  - Parameters: pattern_type, spacing_x, spacing_y, count_x, count_y, radius, count

### mechanical_and_utility.scad

Mechanical joints and utility components:

- **`snapfit_male()` / `snapfit_female()`** - Tool-free assembly snap-fit joints
  - Parameters: width, height, depth, hook_depth/wall_thickness, clearance

- **`living_hinge()`** - Flexible hinge pattern for bendable parts
  - Parameters: width, length, thickness, segment_width, gap_width

- **`cable_clip()`** - Clip for cable management
  - Parameters: cable_diameter, wall_thickness, height, base_width, base_thickness

- **`cable_guide()`** - U-channel for routing cables
  - Parameters: length, cable_diameter, wall_height, wall_thickness

- **`rubber_foot_slot()`** - Press-fit slot for rubber feet
  - Parameters: diameter, depth, lip_height

- **`ventilation_grid()`** - Square or hexagonal ventilation pattern
  - Parameters: width, height, depth, cell_size, wall_thickness, pattern

- **`wall_mount_bracket()`** - Bracket with keyhole slot for wall mounting
  - Parameters: width, depth, height, wall_thickness, keyhole

### icon_library.scad

Decorative icons for embossing or cut-outs:

- **`wifi_icon()`** - WiFi symbol with signal arcs
  - Parameters: size, depth, scale_factor

- **`temperature_icon()`** - Thermometer symbol
  - Parameters: size, depth, scale_factor

## Usage

Import modules into your OpenSCAD projects:

```openscad
// Import only modules (recommended)
use <../lib/boxes_and_plates.scad>
use <../lib/mechanical_and_utility.scad>

// Example: Create a box with mounting posts
difference() {
    parametric_box(
        width=100,
        depth=80,
        height=40,
        wall_thickness=2,
        corner_radius=5
    );

    // Add ventilation
    translate([10, 10, 2])
        ventilation_grid(
            width=30,
            height=30,
            depth=3,
            cell_size=5,
            pattern="hex"
        );
}
```

## Design Standards

- **Screw holes**: M3 (3.2mm diameter recommended for clearance)
- **Wall thickness**: 2mm minimum for structural parts
- **Clearances**: 0.2mm for friction fit, 0.3-0.5mm for loose fit
- **Print orientation**: Design parts to print with minimal support
- **Living hinges**: 0.8mm thickness, print in flexible material (TPU) or oriented for layer flexibility

## See Also

- `docs/CHEATSHEET.md` - OpenSCAD syntax reference
- `projects/` - Example projects using these libraries
- `playground/` - Experimental components and tests
