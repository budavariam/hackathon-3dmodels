// Box with Lid, Corner Posts, and Ventilation
// Adjustable parameters
box_width = 100;
box_depth = 80;
box_height = 40;
wall_thickness = 2;
lid_height = 15;
clearance = 0.2; // Gap between lid and box for fit

// Screw post parameters
post_diameter = 8;
screw_hole_diameter = 3;
post_height = box_height - wall_thickness;

// Ventilation slot parameters
vent_width = 40;
vent_height = 3;
vent_spacing = 15;

// Render selection (change to view different parts)
render_part = "both"; // Options: "box", "lid", "both"

// Main rendering
if (render_part == "both") {
    bottom_box();
    translate([0, 0, box_height + 5])
        lid();
} else if (render_part == "box") {
    bottom_box();
} else if (render_part == "lid") {
    lid();
}

// Bottom box with corner posts
module bottom_box() {
    difference() {
        union() {
            // Main box shell
            difference() {
                cube([box_width, box_depth, box_height]);
                translate([wall_thickness, wall_thickness, wall_thickness])
                    cube([box_width - 2*wall_thickness, 
                          box_depth - 2*wall_thickness, 
                          box_height]);
            }
            
            // Corner mounting posts (3 corners as requested)
            for (i = [0:2]) {
                x = (i == 0 || i == 1) ? wall_thickness + post_diameter/2 : box_width - wall_thickness - post_diameter/2;
                y = (i == 0 || i == 2) ? wall_thickness + post_diameter/2 : box_depth - wall_thickness - post_diameter/2;
                translate([x, y, wall_thickness])
                    cylinder(h = post_height, d = post_diameter);
            }
        }
        
        // Screw holes in 4 corners of base
        corner_positions = [
            [wall_thickness + post_diameter/2, wall_thickness + post_diameter/2],
            [box_width - wall_thickness - post_diameter/2, wall_thickness + post_diameter/2],
            [wall_thickness + post_diameter/2, box_depth - wall_thickness - post_diameter/2],
            [box_width - wall_thickness - post_diameter/2, box_depth - wall_thickness - post_diameter/2]
        ];
        
        for (pos = corner_positions) {
            translate([pos[0], pos[1], -1])
                cylinder(h = box_height + 2, d = screw_hole_diameter);
        }
        
        // Ventilation slots on bottom (3 slots)
        for (i = [0:2]) {
            translate([box_width/2 - vent_width/2, 
                       wall_thickness + 5 + i * vent_spacing, 
                       -1])
                cube([vent_width, vent_height, wall_thickness + 2]);
        }
    }
}

// Lid with rim and ventilation
module lid() {
    rim_depth = 5;
    rim_width = wall_thickness - clearance;
    
    difference() {
        union() {
            // Lid top plate
            cube([box_width, box_depth, wall_thickness]);
            
            // Rim that fits inside box
            translate([wall_thickness + clearance, 
                       wall_thickness + clearance, 
                       -rim_depth])
                difference() {
                    cube([box_width - 2*(wall_thickness + clearance), 
                          box_depth - 2*(wall_thickness + clearance), 
                          rim_depth]);
                    translate([rim_width, rim_width, -1])
                        cube([box_width - 2*(wall_thickness + clearance) - 2*rim_width, 
                              box_depth - 2*(wall_thickness + clearance) - 2*rim_width, 
                              rim_depth + 2]);
                }
        }
        
        // Ventilation slots on top (3 slots)
        for (i = [0:2]) {
            translate([box_width/2 - vent_width/2, 
                       box_depth/2 - vent_height/2 - vent_spacing + i * vent_spacing, 
                       -1])
                cube([vent_width, vent_height, wall_thickness + 2]);
        }
        
        // Screw clearance holes in lid corners
        corner_positions = [
            [wall_thickness + post_diameter/2, wall_thickness + post_diameter/2],
            [box_width - wall_thickness - post_diameter/2, wall_thickness + post_diameter/2],
            [wall_thickness + post_diameter/2, box_depth - wall_thickness - post_diameter/2],
            [box_width - wall_thickness - post_diameter/2, box_depth - wall_thickness - post_diameter/2]
        ];
        
        for (pos = corner_positions) {
            translate([pos[0], pos[1], -rim_depth - 1])
                cylinder(h = rim_depth + wall_thickness + 2, d = screw_hole_diameter + 1);
        }
    }
}
