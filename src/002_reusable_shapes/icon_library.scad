// Icon Library Module
// Reusable parametric icon modules for 3D printing

/**
 * WiFi Icon Module
 * Creates a WiFi symbol with curved signal arcs
 *
 * @param size - Overall icon size (default: 20)
 * @param depth - Extrusion depth for emboss/cutout (default: 2)
 * @param scale_factor - Scale multiplier for entire icon (default: 1.0)
 */
module wifi_icon(size=20, depth=2, scale_factor=1.0) {
    scaled_size = size * scale_factor;
    dot_size = scaled_size * 0.15;
    arc_thickness = scaled_size * 0.12;

    scale([scale_factor, scale_factor, 1]) {
        // Center dot
        translate([0, 0, 0])
            cylinder(h=depth, r=dot_size, $fn=20);

        // Inner arc (smallest)
        translate([0, 0, 0])
            wifi_arc(
                radius=size * 0.3,
                thickness=arc_thickness,
                depth=depth,
                angle_start=30,
                angle_end=150
            );

        // Middle arc
        translate([0, 0, 0])
            wifi_arc(
                radius=size * 0.5,
                thickness=arc_thickness,
                depth=depth,
                angle_start=30,
                angle_end=150
            );

        // Outer arc (largest)
        translate([0, 0, 0])
            wifi_arc(
                radius=size * 0.7,
                thickness=arc_thickness,
                depth=depth,
                angle_start=30,
                angle_end=150
            );
    }
}

/**
 * WiFi Arc Helper Module
 * Creates a single arc segment for the WiFi icon
 *
 * @param radius - Arc radius
 * @param thickness - Arc line thickness
 * @param depth - Extrusion depth
 * @param angle_start - Starting angle in degrees
 * @param angle_end - Ending angle in degrees
 */
module wifi_arc(radius, thickness, depth, angle_start, angle_end) {
    difference() {
        // Outer circle
        rotate_extrude(angle=angle_end - angle_start, $fn=50)
            translate([radius, 0, 0])
                circle(r=thickness, $fn=20);

        // Remove bottom half to create arc
        translate([0, 0, -depth/2])
            rotate([0, 0, angle_start])
                cube([radius * 2, radius * 2, depth * 2], center=false);
    }
}

/**
 * Temperature Icon Module
 * Creates a thermometer symbol
 *
 * @param size - Overall icon height (default: 20)
 * @param depth - Extrusion depth for emboss/cutout (default: 2)
 * @param scale_factor - Scale multiplier for entire icon (default: 1.0)
 */
module temperature_icon(size=20, depth=2, scale_factor=1.0) {
    scaled_size = size * scale_factor;
    tube_width = scaled_size * 0.25;
    tube_height = scaled_size * 0.6;
    bulb_radius = scaled_size * 0.3;

    scale([scale_factor, scale_factor, 1]) {
        // Thermometer bulb (bottom circle)
        translate([0, -size * 0.25, 0])
            cylinder(h=depth, r=bulb_radius, $fn=30);

        // Thermometer tube (vertical rectangle)
        translate([-tube_width/2, -size * 0.25, 0])
            cube([tube_width, tube_height, depth]);

        // Top rounded cap
        translate([0, tube_height - size * 0.25, 0])
            cylinder(h=depth, r=tube_width/2, $fn=30);

        // Mercury/liquid indicator (inner filled part)
        translate([0, -size * 0.25, 0])
            cylinder(h=depth, r=bulb_radius * 0.5, $fn=30);

        translate([-tube_width * 0.3/2, -size * 0.25, 0])
            cube([tube_width * 0.3, tube_height * 0.7, depth]);

        // Temperature marks (small horizontal lines)
        for (i = [0:2]) {
            translate([tube_width/2, -size * 0.25 + tube_height * 0.2 + i * tube_height * 0.15, 0])
                cube([tube_width * 0.4, tube_width * 0.15, depth]);
        }
    }
}
