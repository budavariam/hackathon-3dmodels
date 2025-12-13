# CHEATSHEET

## Shell Script to Export STL

```bash
#!/bin/bash
# Export OpenSCAD file to STL

# Set your paths
SCAD_FILE="box_with_lid.scad"
OUTPUT_DIR="output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Export box and lid as separate STL files
echo "Exporting box..."
openscad -o "$OUTPUT_DIR/box.stl" \
         -D 'render_part="box"' \
         "$SCAD_FILE"

echo "Exporting lid..."
openscad -o "$OUTPUT_DIR/lid.stl" \
         -D 'render_part="lid"' \
         "$SCAD_FILE"

echo "Export complete! Files saved to $OUTPUT_DIR/"
```

**For macOS**, use the full path (source: [Stack Overflow](https://stackoverflow.com/questions/76487840/openscad-batch-export-individual-files-via-shellscript)):

```bash
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output.stl input.scad
```

**Binary STL** (smaller files, recommended for printing) - see [OpenSCAD command line docs](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment):

```bash
openscad -o output.stl --export-format binstl input.scad
```

## OpenSCAD Cheatsheet

OpenSCAD syntax feels like JavaScript/MATLAB. Here's what you need:

### Primitives (3D)

```openscad
cube([width, depth, height], center=true/false);
sphere(r=radius);  // or d=diameter
cylinder(h=height, r=radius, r1=bottom, r2=top);
```

### Primitives (2D - for extrusion)

```openscad
square([width, height], center=true/false);
circle(r=radius);
polygon([[x1,y1], [x2,y2], ...]);
text("Hello", size=10, font="Arial");
```

### Boolean Operations

```openscad
union() { obj1(); obj2(); }       // Combine (default)
difference() { base(); subtract(); }  // Cut away
intersection() { obj1(); obj2(); }    // Keep overlap
```

### Transformations

```openscad
translate([x, y, z]) obj();
rotate([x_deg, y_deg, z_deg]) obj();
scale([x, y, z]) obj();
mirror([x, y, z]) obj();
```

### Control Flow

```openscad
// For loops
for (i = [0:10]) { ... }           // 0 to 10
for (i = [0:2:10]) { ... }         // Step by 2
for (i = [1, 5, 9, 15]) { ... }    // List

// If statements
if (condition) { ... }
if (x > 5) { ... } else { ... }

// Ternary operator (like JS)
var = (x > 5) ? 10 : 20;

// Let (local variables)
let (a = 5, b = a * 2) { ... }
```

### Variables & Functions

```openscad
// Variables
width = 100;
size = [10, 20, 30];

// Functions (return values)
function double(x) = x * 2;
function max(a, b) = (a > b) ? a : b;

// Modules (like functions but create geometry)
module my_box(w, h) {
    cube([w, h, 10]);
}
my_box(20, 30);
```

**Key difference**: Modules create geometry (no return), functions calculate values.

### Advanced Operations

```openscad
hull() { obj1(); obj2(); }        // Convex hull
minkowski() { obj1(); obj2(); }   // Minkowski sum
linear_extrude(height=10) square([20, 20]);
rotate_extrude(angle=360) square([10, 20]);
```

### Useful Operators

```openscad
// Comparison
==  !=  <  >  <=  >=

// Logical
&&  ||  !

// Math functions
sin(deg)  cos(deg)  tan(deg)
sqrt(x)  pow(x, y)  abs(x)
floor(x)  ceil(x)  round(x)
min(a, b)  max(a, b)
```

### Reusable Parametric Modules

Create modules with parameters for reusable shapes:

```openscad
/**
 * WiFi Icon - Creates WiFi symbol with curved signal arcs
 * @param size - Overall icon size
 * @param depth - Extrusion depth for emboss/cutout
 * @param scale_factor - Scale multiplier
 */
module wifi_icon(size=20, depth=2, scale_factor=1.0) {
    // Implementation with parametric scaling
}

/**
 * Temperature Icon - Creates thermometer symbol
 * @param size - Overall icon height
 * @param depth - Extrusion depth
 * @param scale_factor - Scale multiplier
 */
module temperature_icon(size=20, depth=2, scale_factor=1.0) {
    // Implementation with parametric sizing
}
```

**Embossed shapes** (raised on surface):

```openscad
union() {
    cube([100, 80, 40]);  // Base object
    translate([50, -1, 20])
        rotate([90, 0, 0])
            wifi_icon(size=15, depth=1.5);  // Protrudes outward
}
```

**Cut-out shapes** (removed from surface):

```openscad
difference() {
    cube([100, 80, 40]);  // Base object
    translate([50, 81, 20])
        rotate([90, 0, 0])
            wifi_icon(size=15, depth=3);  // Cuts through wall
}
```

### Common Component Libraries

**Boxes and Containers:**
- `parametric_box()` - Customizable box with rounded corners, lid rim
- `screw_post()` - Mounting pillars with screw holes
- `rubber_foot_slot()` - Press-fit slots for rubber feet

**Mounting and Assembly:**
- `mounting_plate()` - Plates with customizable hole patterns
- `pcb_standoff()` - Standoffs for PCB mounting (screw or snap-fit)
- `snapfit_male()` / `snapfit_female()` - Tool-free assembly joints
- `living_hinge()` - Flexible hinge for bendable parts

**Cable Management:**
- `cable_clip()` - Clips for securing cables
- `cable_guide()` - U-channel for routing cables
- `ventilation_grid()` - Square or hexagonal ventilation patterns

**Utility Components:**
- `wall_mount_bracket()` - Brackets with keyhole slots for wall hanging
- `mounting_hole_pattern()` - Generate grid or circular hole patterns

See `src/003_common_components/` for implementation examples.

### Debugging

```openscad
echo("Value:", var);              // Print to console
# obj();                          // Highlight (transparent red)
% obj();                          // Show as transparent
* obj();                          // Disable
! obj();                          // Show only this
```

### Special Variables

```openscad
$fn = 50;                         // Facet number (circle smoothness)
$fa = 12;                         // Minimum angle
$fs = 2;                          // Minimum size
$children;                        // Number of child objects
```

## Resources

- [OpenSCAD Official Cheatsheet](https://openscad.org/cheatsheet/)
- [OpenSCAD User Manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment)
- [Conditional Flow Control](https://www.openscad.info/index.php/2020/06/05/if-condtional-flow-control/)
- [STL Import and Export](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/STL_Import_and_Export)
