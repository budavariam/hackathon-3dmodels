// Reusable Shapes Library
// Demonstrates parametric modules for embossed and cut-out decorative shapes

// Import the icon library
use <icon_library.scad>

// Demo box parameters
box_width = 100;
box_depth = 80;
box_height = 40;
wall_thickness = 2;

// Shape parameters
icon_depth = 1.5;  // Depth for embossing/cutting
icon_scale = 1.0;  // Global scale factor

// Render selection
render_part = "demo"; // Options: "demo", "wifi_cutout", "wifi_emboss", "temp_cutout", "temp_emboss"

// Main rendering
if (render_part == "demo") {
    demo_box();
} else if (render_part == "wifi_cutout") {
    wifi_icon();
} else if (render_part == "wifi_emboss") {
    wifi_icon();
} else if (render_part == "temp_cutout") {
    temperature_icon();
} else if (render_part == "temp_emboss") {
    temperature_icon();
}

// Demo box showing all shape applications
module demo_box() {
    difference() {
        union() {
            // Main box
            cube([box_width, box_depth, box_height]);

            // Embossed WiFi icon on front face
            translate([box_width/2, -icon_depth, box_height/2])
                rotate([90, 0, 0])
                    wifi_icon(size=15, depth=icon_depth, scale_factor=icon_scale);

            // Embossed temperature icon on right face
            translate([box_width + icon_depth, box_depth/2, box_height/2])
                rotate([90, 0, 90])
                    temperature_icon(size=12, depth=icon_depth, scale_factor=icon_scale);
        }

        // Hollow interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([box_width - 2*wall_thickness,
                  box_depth - 2*wall_thickness,
                  box_height]);

        // Cut-out WiFi icon on back face
        translate([box_width/2, box_depth + 1, box_height/2])
            rotate([90, 0, 180])
                wifi_icon(size=15, depth=wall_thickness + 2, scale_factor=icon_scale);

        // Cut-out temperature icon on left face
        translate([-1, box_depth/2, box_height/2])
            rotate([90, 0, -90])
                temperature_icon(size=12, depth=wall_thickness + 2, scale_factor=icon_scale);
    }
}
