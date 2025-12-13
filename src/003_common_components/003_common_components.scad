// Common Components Demonstration
// Shows usage examples of reusable components

// Import component libraries
use <boxes_and_plates.scad>
use <mechanical_and_utility.scad>

// Render selection
render_part = "all"; // Options: "all", "box_demo", "mounting_demo", "cable_demo", "snapfit_demo", "ventilation_demo"

// Spacing for layout
spacing = 120;

// Main rendering
if (render_part == "all") {
    // Box with mounting features
    translate([0, 0, 0])
        box_demo();

    // Mounting plate with standoffs
    translate([spacing, 0, 0])
        mounting_demo();

    // Cable management
    translate([0, spacing, 0])
        cable_demo();

    // Snap-fit joint
    translate([spacing, spacing, 0])
        snapfit_demo();

    // Ventilation patterns
    translate([spacing*2, 0, 0])
        ventilation_demo();

} else if (render_part == "box_demo") {
    box_demo();
} else if (render_part == "mounting_demo") {
    mounting_demo();
} else if (render_part == "cable_demo") {
    cable_demo();
} else if (render_part == "snapfit_demo") {
    snapfit_demo();
} else if (render_part == "ventilation_demo") {
    ventilation_demo();
}

// Demonstration modules

/**
 * Box Demo
 * Shows parametric box with rounded corners and mounting posts
 */
module box_demo() {
    difference() {
        union() {
            // Rounded box
            parametric_box(
                width=100,
                depth=80,
                height=40,
                wall_thickness=2,
                corner_radius=5,
                has_lid_rim=true
            );

            // Add screw posts in corners
            post_positions = [[10, 10], [90, 10], [10, 70], [90, 70]];
            for (pos = post_positions) {
                translate([pos[0], pos[1], 2])
                    screw_post(
                        height=35,
                        outer_diameter=8,
                        screw_diameter=3.2
                    );
            }
        }

        // Add ventilation on side
        translate([2, 20, 10])
            rotate([0, 90, 0])
                ventilation_grid(
                    width=40,
                    height=20,
                    depth=3,
                    cell_size=4,
                    wall_thickness=1,
                    pattern="square"
                );
    }
}

/**
 * Mounting Demo
 * Shows mounting plate with PCB standoffs
 */
module mounting_demo() {
    // Base mounting plate
    mounting_plate(
        width=100,
        depth=80,
        thickness=3,
        corner_radius=5,
        hole_positions=[[10,10], [90,10], [10,70], [90,70]],
        hole_diameter=3.2
    );

    // PCB standoffs in standard positions
    pcb_positions = [[20, 20], [80, 20], [20, 60], [80, 60]];
    for (pos = pcb_positions) {
        translate([pos[0], pos[1], 3])
            pcb_standoff(
                height=5,
                pcb_thickness=1.6,
                hole_diameter=3.2,
                mount_type="snapfit"
            );
    }
}

/**
 * Cable Demo
 * Shows cable management components
 */
module cable_demo() {
    // Cable clips
    translate([10, 10, 0])
        cable_clip(
            cable_diameter=5,
            wall_thickness=2,
            height=10
        );

    translate([30, 10, 0])
        cable_clip(
            cable_diameter=8,
            wall_thickness=2,
            height=10
        );

    // Cable guide
    translate([10, 30, 0])
        cable_guide(
            length=50,
            cable_diameter=5,
            wall_height=5
        );

    // Rubber feet slots on a base plate
    translate([0, 60, 0])
        difference() {
            cube([60, 20, 5]);

            // Feet positions
            feet_positions = [[10, 10], [50, 10]];
            for (pos = feet_positions) {
                translate([pos[0], pos[1], 5])
                    rotate([180, 0, 0])
                        rubber_foot_slot(diameter=10, depth=3);
            }
        }
}

/**
 * Snap-Fit Demo
 * Shows snap-fit joint components (male and female separated)
 */
module snapfit_demo() {
    // Male connector
    translate([0, 0, 0])
        snapfit_male(
            width=10,
            height=15,
            depth=3
        );

    // Female socket (separated for printing)
    translate([20, 0, 0])
        snapfit_female(
            width=10,
            height=15,
            depth=3,
            wall_thickness=2
        );

    // Living hinge example
    translate([0, 30, 0])
        union() {
            // Part 1
            cube([20, 10, 2]);

            // Hinge
            translate([20, 0, 0])
                living_hinge(
                    width=10,
                    length=10,
                    thickness=0.8
                );

            // Part 2
            translate([30, 0, 0])
                cube([20, 10, 2]);
        }
}

/**
 * Ventilation Demo
 * Shows different ventilation patterns
 */
module ventilation_demo() {
    // Square grid pattern
    translate([0, 0, 0])
        ventilation_grid(
            width=50,
            height=50,
            depth=2,
            cell_size=5,
            wall_thickness=1,
            pattern="square"
        );

    // Hexagonal honeycomb pattern
    translate([60, 0, 0])
        ventilation_grid(
            width=50,
            height=50,
            depth=2,
            cell_size=5,
            wall_thickness=1,
            pattern="hex"
        );
}
