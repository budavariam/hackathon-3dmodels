// Common Components Library - Part 1
// Boxes, Plates, and Mounting Components

/**
 * Parametric Box
 * Creates a box with optional features: rounded corners, lid rim, mounting holes
 *
 * @param width - Box width (X dimension)
 * @param depth - Box depth (Y dimension)
 * @param height - Box height (Z dimension)
 * @param wall_thickness - Wall thickness
 * @param corner_radius - Corner radius (0 for sharp corners)
 * @param has_lid_rim - Add rim for lid (boolean)
 * @param rim_height - Height of lid rim
 * @param rim_clearance - Clearance for lid fit
 */
module parametric_box(
    width=100,
    depth=80,
    height=40,
    wall_thickness=2,
    corner_radius=0,
    has_lid_rim=false,
    rim_height=5,
    rim_clearance=0.2
) {
    difference() {
        // Outer shell
        if (corner_radius > 0) {
            rounded_cube([width, depth, height], corner_radius);
        } else {
            cube([width, depth, height]);
        }

        // Hollow interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            if (corner_radius > 0) {
                rounded_cube([
                    width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height
                ], max(0, corner_radius - wall_thickness));
            } else {
                cube([
                    width - 2*wall_thickness,
                    depth - 2*wall_thickness,
                    height
                ]);
            }

        // Lid rim cutout
        if (has_lid_rim) {
            translate([wall_thickness + rim_clearance,
                       wall_thickness + rim_clearance,
                       height - rim_height])
                cube([
                    width - 2*(wall_thickness + rim_clearance),
                    depth - 2*(wall_thickness + rim_clearance),
                    rim_height + 1
                ]);
        }
    }
}

/**
 * Rounded Cube Helper
 * Creates a cube with rounded corners using minkowski
 *
 * @param size - [width, depth, height]
 * @param radius - Corner radius
 */
module rounded_cube(size, radius) {
    if (radius <= 0) {
        cube(size);
    } else {
        translate([radius, radius, 0])
            minkowski() {
                cube([size[0] - 2*radius, size[1] - 2*radius, size[2]/2]);
                cylinder(r=radius, h=size[2]/2, $fn=30);
            }
    }
}

/**
 * Mounting Plate
 * Creates a flat plate with mounting holes (for PCBs, electronics, wall mounting)
 *
 * @param width - Plate width
 * @param depth - Plate depth
 * @param thickness - Plate thickness
 * @param corner_radius - Corner radius
 * @param hole_positions - Array of [x, y] positions for mounting holes
 * @param hole_diameter - Diameter of mounting holes
 */
module mounting_plate(
    width=100,
    depth=80,
    thickness=3,
    corner_radius=5,
    hole_positions=[[10,10], [90,10], [10,70], [90,70]],
    hole_diameter=3.2
) {
    difference() {
        // Base plate
        if (corner_radius > 0) {
            rounded_cube([width, depth, thickness], corner_radius);
        } else {
            cube([width, depth, thickness]);
        }

        // Mounting holes
        for (pos = hole_positions) {
            translate([pos[0], pos[1], -1])
                cylinder(h=thickness + 2, d=hole_diameter, $fn=30);
        }
    }
}

/**
 * Screw Post/Mounting Pillar
 * Creates a cylindrical post with screw hole for mounting components
 *
 * @param height - Post height
 * @param outer_diameter - Outer diameter of post
 * @param screw_diameter - Inner screw hole diameter (0 for no hole)
 * @param base_diameter - Base diameter (0 for no base)
 * @param base_height - Base height
 */
module screw_post(
    height=10,
    outer_diameter=8,
    screw_diameter=3.2,
    base_diameter=0,
    base_height=0
) {
    difference() {
        union() {
            // Main post
            cylinder(h=height, d=outer_diameter, $fn=40);

            // Optional base
            if (base_diameter > 0 && base_height > 0) {
                cylinder(h=base_height, d=base_diameter, $fn=40);
            }
        }

        // Screw hole
        if (screw_diameter > 0) {
            translate([0, 0, -1])
                cylinder(h=height + 2, d=screw_diameter, $fn=30);
        }
    }
}

/**
 * Mounting Hole Pattern Generator
 * Creates standard mounting hole patterns (rectangular grid, circular pattern)
 *
 * @param pattern_type - "grid" or "circular"
 * @param spacing_x - X spacing for grid pattern
 * @param spacing_y - Y spacing for grid pattern
 * @param count_x - Number of holes in X direction
 * @param count_y - Number of holes in Y direction
 * @param radius - Radius for circular pattern
 * @param count - Number of holes for circular pattern
 */
function mounting_hole_pattern(
    pattern_type="grid",
    spacing_x=50,
    spacing_y=50,
    count_x=2,
    count_y=2,
    radius=40,
    count=4
) =
    pattern_type == "grid" ?
        [for (i = [0:count_x-1], j = [0:count_y-1])
            [i * spacing_x, j * spacing_y]] :
    pattern_type == "circular" ?
        [for (i = [0:count-1])
            [radius * cos(i * 360/count), radius * sin(i * 360/count)]] :
    [];

/**
 * PCB Standoff
 * Creates a standoff for mounting PCBs with snap-fit or screw mount
 *
 * @param height - Standoff height (clearance under PCB)
 * @param pcb_thickness - PCB thickness
 * @param hole_diameter - PCB mounting hole diameter
 * @param mount_type - "screw" or "snapfit"
 * @param outer_diameter - Outer diameter of standoff
 */
module pcb_standoff(
    height=5,
    pcb_thickness=1.6,
    hole_diameter=3.2,
    mount_type="screw",
    outer_diameter=6
) {
    difference() {
        union() {
            // Base post
            cylinder(h=height, d=outer_diameter, $fn=40);

            if (mount_type == "snapfit") {
                // Snap-fit retention clip
                translate([0, 0, height])
                    cylinder(h=pcb_thickness + 0.5, d=hole_diameter - 0.3, $fn=40);
                translate([0, 0, height + pcb_thickness])
                    cylinder(h=0.8, d1=hole_diameter - 0.3, d2=hole_diameter + 1, $fn=40);
            } else {
                // Screw post extends through PCB
                translate([0, 0, height])
                    cylinder(h=pcb_thickness + 3, d=outer_diameter*0.7, $fn=40);
            }
        }

        // Screw hole (for screw mount type)
        if (mount_type == "screw") {
            translate([0, 0, -1])
                cylinder(h=height + pcb_thickness + 5, d=hole_diameter*0.6, $fn=30);
        }
    }
}
