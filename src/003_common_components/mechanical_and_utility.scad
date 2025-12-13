// Common Components Library - Part 2
// Mechanical Joints, Cable Management, and Utility Components

/**
 * Snap-Fit Joint (Male)
 * Creates a male snap-fit connector for tool-free assembly
 *
 * @param width - Joint width
 * @param height - Joint height
 * @param depth - Joint depth/thickness
 * @param hook_depth - Depth of retention hook
 * @param clearance - Fit clearance
 */
module snapfit_male(
    width=10,
    height=15,
    depth=3,
    hook_depth=0.8,
    clearance=0.2
) {
    hook_angle = 45;

    difference() {
        union() {
            // Main body
            cube([width - clearance*2, depth, height]);

            // Retention hook
            translate([0, 0, height])
                rotate([0, 0, 0])
                    linear_extrude(height=0.1)
                        polygon([
                            [0, 0],
                            [width - clearance*2, 0],
                            [width - clearance*2, depth],
                            [width - clearance*2 - hook_depth, depth + hook_depth],
                            [hook_depth, depth + hook_depth],
                            [0, depth]
                        ]);
        }
    }
}

/**
 * Snap-Fit Joint (Female)
 * Creates a female snap-fit socket
 *
 * @param width - Joint width
 * @param height - Joint height
 * @param depth - Joint depth/thickness
 * @param wall_thickness - Wall thickness around socket
 * @param clearance - Fit clearance
 */
module snapfit_female(
    width=10,
    height=15,
    depth=3,
    wall_thickness=2,
    clearance=0.2
) {
    difference() {
        // Outer walls
        cube([width + wall_thickness*2, depth + wall_thickness, height + wall_thickness]);

        // Socket cavity
        translate([wall_thickness, 0, wall_thickness])
            cube([width, depth + 1, height + 1]);
    }
}

/**
 * Living Hinge
 * Creates a flexible hinge pattern for thin walls
 *
 * @param width - Hinge width
 * @param length - Hinge length
 * @param thickness - Base thickness
 * @param segment_width - Width of flexible segments
 * @param gap_width - Width of gaps between segments
 */
module living_hinge(
    width=50,
    length=10,
    thickness=0.8,
    segment_width=1,
    gap_width=0.5
) {
    segment_count = floor(width / (segment_width + gap_width));

    for (i = [0:segment_count-1]) {
        translate([i * (segment_width + gap_width), 0, 0])
            cube([segment_width, length, thickness]);
    }
}

/**
 * Cable Clip
 * Creates a clip for cable management
 *
 * @param cable_diameter - Diameter of cable
 * @param wall_thickness - Clip wall thickness
 * @param height - Clip height
 * @param base_width - Base mounting width
 * @param base_thickness - Base thickness
 */
module cable_clip(
    cable_diameter=5,
    wall_thickness=2,
    height=10,
    base_width=15,
    base_thickness=3
) {
    clip_radius = cable_diameter/2 + wall_thickness;

    difference() {
        union() {
            // Base
            translate([-base_width/2, -clip_radius - wall_thickness, 0])
                cube([base_width, base_thickness, height]);

            // Clip arc
            difference() {
                cylinder(h=height, r=clip_radius, $fn=40);
                translate([0, 0, -1])
                    cylinder(h=height + 2, r=cable_diameter/2, $fn=40);

                // Opening gap
                translate([-cable_diameter, -clip_radius - wall_thickness, -1])
                    cube([cable_diameter*2, clip_radius + wall_thickness, height + 2]);
            }
        }

        // Mounting hole
        translate([0, -clip_radius - wall_thickness/2, height/2])
            rotate([90, 0, 0])
                cylinder(h=base_thickness + 2, d=3.2, center=true, $fn=30);
    }
}

/**
 * Cable Guide
 * Creates a guide/channel for routing cables
 *
 * @param length - Guide length
 * @param cable_diameter - Cable diameter
 * @param wall_height - Height of guide walls
 * @param wall_thickness - Thickness of guide walls
 */
module cable_guide(
    length=50,
    cable_diameter=5,
    wall_height=5,
    wall_thickness=2
) {
    channel_width = cable_diameter + 1;

    difference() {
        // Outer block
        cube([length, channel_width + 2*wall_thickness, wall_height]);

        // Cable channel
        translate([0, wall_thickness, wall_thickness])
            cube([length, channel_width, wall_height]);

        // Top opening (U-channel)
        translate([0, wall_thickness, wall_height - cable_diameter/2])
            cube([length, channel_width, wall_height]);
    }
}

/**
 * Rubber Foot Slot
 * Creates a slot for press-fit rubber feet
 *
 * @param diameter - Foot diameter
 * @param depth - Slot depth
 * @param lip_height - Retention lip height
 */
module rubber_foot_slot(
    diameter=10,
    depth=3,
    lip_height=0.5
) {
    difference() {
        cylinder(h=depth, d=diameter, $fn=40);

        // Retention lip
        translate([0, 0, depth - lip_height])
            cylinder(h=lip_height + 0.1, d1=diameter, d2=diameter - 1, $fn=40);
    }
}

/**
 * Ventilation Grid
 * Creates a honeycomb or rectangular grid pattern for ventilation
 *
 * @param width - Grid width
 * @param height - Grid height
 * @param depth - Grid depth (extrusion)
 * @param cell_size - Size of grid cells
 * @param wall_thickness - Thickness of grid walls
 * @param pattern - "hex" for honeycomb, "square" for rectangular
 */
module ventilation_grid(
    width=50,
    height=50,
    depth=2,
    cell_size=5,
    wall_thickness=1,
    pattern="square"
) {
    if (pattern == "square") {
        difference() {
            cube([width, height, depth]);

            // Create grid of holes
            for (x = [wall_thickness : cell_size + wall_thickness : width - cell_size]) {
                for (y = [wall_thickness : cell_size + wall_thickness : height - cell_size]) {
                    translate([x, y, -1])
                        cube([cell_size, cell_size, depth + 2]);
                }
            }
        }
    } else if (pattern == "hex") {
        // Honeycomb pattern (simplified)
        hex_spacing = cell_size * 0.866; // sqrt(3)/2

        difference() {
            cube([width, height, depth]);

            for (row = [0 : floor(height / hex_spacing)]) {
                for (col = [0 : floor(width / cell_size)]) {
                    x_offset = (row % 2) * cell_size / 2;
                    translate([col * cell_size + x_offset, row * hex_spacing, -1])
                        cylinder(h=depth + 2, d=cell_size, $fn=6);
                }
            }
        }
    }
}

/**
 * Wall Mount Bracket
 * Creates a bracket for wall mounting
 *
 * @param width - Bracket width
 * @param depth - Bracket depth (protrusion from wall)
 * @param height - Bracket height
 * @param wall_thickness - Material thickness
 * @param keyhole - Add keyhole slot for hanging
 */
module wall_mount_bracket(
    width=40,
    depth=30,
    height=50,
    wall_thickness=3,
    keyhole=true
) {
    difference() {
        union() {
            // Back plate
            cube([width, wall_thickness, height]);

            // Bottom support
            cube([width, depth, wall_thickness]);

            // Triangular gusset
            translate([0, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(height=width)
                        polygon([
                            [0, 0],
                            [wall_thickness, 0],
                            [height*0.6, depth - wall_thickness],
                            [height*0.6, depth],
                            [0, wall_thickness]
                        ]);
        }

        // Keyhole mounting slot
        if (keyhole) {
            translate([width/2, -1, height - 10]) {
                // Wide part for screw head
                rotate([-90, 0, 0])
                    cylinder(h=wall_thickness + 2, d=8, $fn=30);

                // Narrow slot for screw shaft
                translate([-2, 0, -15])
                    cube([4, wall_thickness + 2, 15]);
            }
        }
    }
}
