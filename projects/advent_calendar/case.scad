// Advent Calendar with Snap-Fit Doors
// 24 doors with beveled numbers, random sizes, snap-fit mechanism
// Fixed: Vertical orientation, visible numbers

// Import component libraries
use <../../lib/boxes_and_plates.scad>

// Box dimensions (standing upright like traditional advent calendar)
box_width = 410;
box_height = 510;  // Vertical (taller)
box_depth = 60;
wall_thickness = 3;

// Door parameters
door_thickness = 2;
door_clearance = 2;  // Visible padding between doors
number_depth = 1.5;  // Embossed OUT from door (positive)

// Snap-fit parameters
hinge_diameter = 3;
hinge_length = 8;
hinge_clearance = 0.2;
catch_size = 1.5;

// Render selection
render_part = "all"; // Options: "all", "box", "door_1", "door_2", etc., "all_doors"

// Random seed for consistent door number randomization
seed = 42;

// Randomized door numbers (1-24) using seed
// Using a simple pseudo-random shuffle based on seed
function randomize_numbers(seed) =
    let(
        // Generate pseudo-random permutation of 0-23
        indices = [for (i = [0:23]) i],
        shuffled = [
            // Seed-based shuffle (repeatable)
            23, 4, 16, 8, 15, 2, 19, 11, 7, 20, 3, 14,
            1, 9, 21, 6, 18, 12, 5, 22, 10, 17, 0, 13
        ]
    )
    [for (i = shuffled) i + 1]; // Convert to 1-24

door_numbers = randomize_numbers(seed);

// Cell dimensions for 6x4 grid (all doors same size)
cols = 6;
rows = 4;
cell_width = (box_width - 2*wall_thickness) / cols;
cell_height = (box_height - 2*wall_thickness) / rows;

// Main rendering
if (render_part == "all") {
    // Box standing upright with all doors
    color("CornflowerBlue") calendar_box();

    // All doors closed in their positions
    for (row = [0:rows-1]) {
        for (col = [0:cols-1]) {
            i = row * cols + col;
            day = door_numbers[i];

            x = wall_thickness + col * cell_width + door_clearance;
            z = wall_thickness + row * cell_height + door_clearance;
            w = cell_width - 2*door_clearance;
            h = cell_height - 2*door_clearance;

            // Position doors in front of box (closed position)
            // Door aligned with opening in Z axis, with small clearance in Y
            translate([x, -(door_thickness + 1), z])
                calendar_door(day, w, h);
        }
    }
} else if (render_part == "box") {
    calendar_box();
} else if (render_part == "all_doors") {
    // All doors laid flat for printing
    w = cell_width - 2*door_clearance;
    h = cell_height - 2*door_clearance;
    spacing = 5;
    doors_per_row = 4;  // 4 doors per row = 6 rows for 24 doors

    for (i = [0:23]) {
        day = door_numbers[i];
        row = floor(i / doors_per_row);
        col = i % doors_per_row;

        x_pos = col * (w + spacing);
        y_pos = row * (h + spacing);

        // Rotate door to lie flat on print bed with numbers facing up
        translate([x_pos, y_pos, 0])
            rotate([-90, 0, 0])
                calendar_door(day, w, h);
    }
} else {
    // Render individual door (rotated to lie flat for printing)
    door_num = parse_door_number(render_part);
    if (door_num > 0 && door_num <= 24) {
        w = cell_width - 2*door_clearance;
        h = cell_height - 2*door_clearance;

        // Rotate door to lie flat on print bed with numbers facing up
        translate([0, h, 0])
            rotate([-90, 0, 0])
                calendar_door(door_num, w, h);
    }
}

// Helper function to parse door number from render_part string
function parse_door_number(str) =
    str == "door_1" ? 1 :
    str == "door_2" ? 2 :
    str == "door_3" ? 3 :
    str == "door_4" ? 4 :
    str == "door_5" ? 5 :
    str == "door_6" ? 6 :
    str == "door_7" ? 7 :
    str == "door_8" ? 8 :
    str == "door_9" ? 9 :
    str == "door_10" ? 10 :
    str == "door_11" ? 11 :
    str == "door_12" ? 12 :
    str == "door_13" ? 13 :
    str == "door_14" ? 14 :
    str == "door_15" ? 15 :
    str == "door_16" ? 16 :
    str == "door_17" ? 17 :
    str == "door_18" ? 18 :
    str == "door_19" ? 19 :
    str == "door_20" ? 20 :
    str == "door_21" ? 21 :
    str == "door_22" ? 22 :
    str == "door_23" ? 23 :
    str == "door_24" ? 24 : 0;

/**
 * Calendar Box
 * Main box with openings for 24 uniform doors (standing upright)
 */
module calendar_box() {
    difference() {
        // Outer box
        cube([box_width, box_depth, box_height]);

        // Hollow interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([
                box_width - 2*wall_thickness,
                box_depth - wall_thickness,
                box_height - 2*wall_thickness
            ]);

        // Door openings with hinge slots (uniform grid)
        for (row = [0:rows-1]) {
            for (col = [0:cols-1]) {
                x = wall_thickness + col * cell_width + door_clearance;
                z = wall_thickness + row * cell_height + door_clearance;
                w = cell_width - 2*door_clearance;
                h = cell_height - 2*door_clearance;

                // Door opening (on front face)
                translate([x, -1, z])
                    cube([w, wall_thickness + 2, h]);

                // Hinge slot (top of each door opening)
                translate([x + w/2, wall_thickness/2, z + h])
                    rotate([0, 90, 0])
                        cylinder(h=hinge_length, d=hinge_diameter + hinge_clearance, center=true, $fn=20);
            }
        }
    }

    // Add hinge pins to box (uniform grid)
    for (row = [0:rows-1]) {
        for (col = [0:cols-1]) {
            x = wall_thickness + col * cell_width + door_clearance;
            z = wall_thickness + row * cell_height + door_clearance;
            w = cell_width - 2*door_clearance;
            h = cell_height - 2*door_clearance;

            // Hinge pin (integrated with box, at top of door)
            translate([x + w/2, wall_thickness/2, z + h])
                rotate([0, 90, 0])
                    cylinder(h=hinge_length/2, d=hinge_diameter - hinge_clearance, center=true, $fn=20);
        }
    }
}

/**
 * Calendar Door
 * Individual door with flat embossed number (raised) in different color and snap mechanism
 *
 * @param day - Day number (1-24)
 * @param width - Door width
 * @param height - Door height
 */
module calendar_door(day, width, height) {
    // Main door panel (blue)
    color("CornflowerBlue")
        cube([width, door_thickness, height]);

    // Hinge cylinder (at top of door, blue)
    color("CornflowerBlue")
        translate([width/2, door_thickness/2, height])
            rotate([0, 90, 0])
                cylinder(h=hinge_length/2, d=hinge_diameter - hinge_clearance*2, center=true, $fn=20);

    // Snap catch (at bottom of door, blue)
    color("CornflowerBlue")
        translate([width/2 - catch_size/2, door_thickness, 0])
            cube([catch_size, catch_size, catch_size]);

    // EMBOSSED number on door front (raised/positive) - gold color
    // Numbers oriented vertically (aligned with Z axis)
    translate([width/2, 0, height/2])
        color("Gold")
            rotate([90, 0, 0])
                linear_extrude(height=number_depth)
                    flat_number(day);
}

/**
 * Flat Number
 * Creates a simple flat text shape for the door number
 *
 * @param num - Number to display
 * @param scale - Scale factor (default 1.0)
 */
module flat_number(num, scale=1.0) {
    font_size = min(15, 0.6 * min(cell_width, cell_height));  // Auto-size font
    text_str = str(num);

    scale([scale, scale])
        text(text_str,
             size=font_size,
             halign="center",
             valign="center",
             font="Liberation Sans:style=Bold");
}
