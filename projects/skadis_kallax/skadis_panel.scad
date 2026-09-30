// =====================================================================
// Skadis-style pegboard panel — Kallax / custom sizes
// =====================================================================
//
// PRESETS
//   "kallax"       330×330mm — fills back of a Kallax slot (no door)
//   "kallax_side"  380×325mm — fills inner side wall of a Kallax slot
//   "skadis_small" 360×560mm — standard IKEA Skadis small board
//   "skadis_large" 560×560mm — standard IKEA Skadis large board
//   "custom"       use custom_width / custom_height
//
// MOUNT STYLE
//   "clip"         Snap-clips grip Kallax frame — no drilling, no screws
//                  Based on commercial reference design (two-piece clip)
//   "bracket"      Slide-in holders screwed to Kallax back wall
//                  Bottom holders have a floor stop, top holders are open
//
// RENDER PARTS (set render_part = "..." before exporting)
//   "full"           whole panel assembled (preview)
//   "COL_ROW"        single print segment, e.g. "0_0" = col0 row0
//   "clip_male"      flat plate with two pins — front face of clip
//   "clip_female"    plate with barrel holes + Kallax-edge hook — back face
//   "holder_bottom"  slide-in bracket: U-channel WITH floor stop
//   "holder_top"     slide-in bracket: channel WITHOUT floor (panel slides thru)
// =====================================================================

preset       = "kallax";
mount_style  = "clip";   // "clip" | "bracket"
render_part  = "full";

// ── Custom dimensions (used when preset = "custom") ─────────────────
custom_width  = 330;
custom_height = 330;

// ── Resolved panel size ─────────────────────────────────────────────
panel_width = (preset == "kallax")       ? 330
            : (preset == "kallax_side")  ? 380
            : (preset == "skadis_small") ? 360
            : (preset == "skadis_large") ? 560
            : custom_width;

panel_height = (preset == "kallax")       ? 330
             : (preset == "kallax_side")  ? 325
             : (preset == "skadis_small") ? 560
             : (preset == "skadis_large") ? 560
             : custom_height;

panel_thickness = 5;   // panel body thickness (mm)

// =====================================================================
// BORDER / MARGIN
// =====================================================================
// Solid border around the hole area — no holes punched in this zone
margin_top    = 10;
margin_bottom = 10;
margin_left   = 10;
margin_right  = 10;

// =====================================================================
// SKADIS HOLE PATTERN
// =====================================================================
hole_w         = 5;    // oval narrow dimension
hole_h         = 10;   // oval tall dimension
hole_spacing_x = 40;   // horizontal center-to-center
hole_spacing_y = 20;   // vertical center-to-center
hole_stagger   = 20;   // odd rows offset by this many mm in X

// Shift the entire hole grid (tweak if alignment looks off)
hole_offset_x  = 0;
hole_offset_y  = 0;

// =====================================================================
// MOUNTING HOLES IN PANEL
// =====================================================================
// Circular holes at panel corners (and split junctions for ≥3×3 splits).
// Used by both clip and bracket mounting systems.
mh_d       = 5.0;   // through-hole diameter
mh_csink_d = 8.5;   // countersink diameter (front face)
mh_csink_h = 2.0;   // countersink depth
mh_inset   = 8;     // distance from outer panel corner to hole centre

// =====================================================================
// CLIP SYSTEM  (mount_style = "clip")
// =====================================================================
// Two-piece design (see reference images):
//   clip_male   — oblong body with two cylindrical PINS (front face)
//   clip_female — oblong body with two BARREL HOLES + Kallax-edge HOOK (back)
//
// Assembly:
//   1. Align panel corner with Kallax slot edge.
//   2. Push male-clip pins through the panel corner holes from the front.
//   3. Slide female-clip hook over the Kallax shelf/wall edge.
//   4. Press female barrels onto the male pins — they click and lock.
//   No drilling, no screws.

clip_pin_spacing = 25;    // centre-to-centre of the two pins / barrels
clip_body_r      = 9;     // end-cap radius of the stadium body
clip_body_t      = 5;     // clip body thickness (Z)
clip_pin_d       = 4.8;   // pin diameter (fits 5mm panel holes with clearance)
clip_pin_h       = 7;     // pin protrusion height
clip_barrel_clr  = 0.35;  // barrel radius clearance over pin
kallax_wall_t    = 16.5;  // Kallax shelf/wall thickness (for hook sizing)
clip_hook_len    = 10;    // how far hook wraps behind shelf edge
clip_hook_t      = 2.5;   // hook arm wall thickness
clip_hook_lip    = 4;     // hook retaining lip length

// =====================================================================
// BRACKET / SLIDE-IN SYSTEM  (mount_style = "bracket")
// =====================================================================
// Four holders screwed to the Kallax back wall.
// Panel slides straight DOWN from above into all four channels.
//   holder_bottom — U-channel WITH a floor: panel bottom RESTS here
//   holder_top    — open channel, NO floor: panel slides through freely
//
// Install order:
//   1. Screw all 4 holders to back wall (bottom pair lower, top pair higher).
//   2. Lower panel straight down from above.
//   3. Panel bottom edge hits the floor of the bottom holders → stops.
//   4. Panel top edge sits in the open top holders → can't tip forward.
//
// PRINT ORIENTATION: rotate 90° around X so the channel opens face-up.

brk_w      = 25;                    // bracket width (parallel to wall, X)
brk_h      = 25;                    // bracket height (parallel to wall, Z)
brk_bt     = 4;                     // base plate thickness (into wall, Y)
brk_ch     = panel_thickness + 0.5; // channel width (fits panel edge)
brk_wt     = 3;                     // channel wall thickness
brk_ch_ht  = 14;                    // channel height
brk_ft     = 3;                     // floor thickness (bottom holder only)
brk_scr_d  = 4.5;                   // M4 screw clearance hole

// =====================================================================
// PRINT-SPLIT SETTINGS
// =====================================================================
split_cols = 2;   // columns (horizontal)
split_rows = 2;   // rows (vertical)

// Tongue-and-groove snap joint (no screws, no glue — just press-fit)
tongue_h        = 2.2;   // tongue height above panel face
tongue_w        = 3.0;   // tongue width
tongue_len      = 7.0;   // tongue length along edge
tongue_gap      = 0.25;  // clearance between tongue and groove
tongue_per_edge = 3;     // joints per shared edge
bead_r          = 0.5;
bead_gap        = 0.35;

// =====================================================================
// INTERNALS
// =====================================================================
$fn = 32;
eps = 0.01;

hole_area_x = margin_left;
hole_area_y = margin_bottom;
hole_area_w = panel_width  - margin_left - margin_right;
hole_area_h = panel_height - margin_top  - margin_bottom;

part_w = panel_width  / split_cols;
part_h = panel_height / split_rows;

snap_h   = 0.5;
snap_len = 3.0;

// Mounting hole positions (auto-generated at corner + junction points)
// Outer corners are inset by mh_inset; inner junctions land at split lines.
function mh_xs() = [
    for (c = [0 : split_cols])
        c == 0             ? mh_inset
      : c == split_cols    ? panel_width - mh_inset
      :                      c * part_w
];
function mh_ys() = [
    for (r = [0 : split_rows])
        r == 0             ? mh_inset
      : r == split_rows    ? panel_height - mh_inset
      :                      r * part_h
];

// =====================================================================
// MODULES — SKADIS HOLE PATTERN
// =====================================================================

module skadis_hole() {
    hull() {
        translate([0,  (hole_h - hole_w)/2, 0]) cylinder(d=hole_w, h=panel_thickness + 2*eps);
        translate([0, -(hole_h - hole_w)/2, 0]) cylinder(d=hole_w, h=panel_thickness + 2*eps);
    }
}

module hole_pattern() {
    ox = hole_area_x + hole_offset_x;
    oy = hole_area_y + hole_offset_y;
    cols = ceil(hole_area_w / hole_spacing_x) + 2;
    rows = ceil(hole_area_h / hole_spacing_y) + 2;
    for (row = [0 : rows]) {
        row_y  = oy + row * hole_spacing_y;
        stagger = (row % 2 == 0) ? 0 : hole_stagger;
        for (col = [-1 : cols]) {
            hx = ox + col * hole_spacing_x + stagger;
            hy = row_y;
            if (hx >= hole_area_x + hole_w/2 &&
                hx <= hole_area_x + hole_area_w - hole_w/2 &&
                hy >= hole_area_y + hole_h/2 &&
                hy <= hole_area_y + hole_area_h - hole_h/2)
            {
                translate([hx, hy, -eps]) skadis_hole();
            }
        }
    }
}

// =====================================================================
// MODULES — MOUNTING HOLES IN PANEL
// =====================================================================

// One countersunk mounting hole through the panel
module panel_mount_hole() {
    // Through hole
    translate([0, 0, -eps])
        cylinder(d=mh_d, h=panel_thickness + 2*eps);
    // Countersink on front face
    translate([0, 0, panel_thickness - mh_csink_h])
        cylinder(d1=mh_d, d2=mh_csink_d, h=mh_csink_h + eps);
}

// All mounting holes subtracted from the panel
module all_mount_holes() {
    xs = mh_xs();
    ys = mh_ys();
    for (x = xs) for (y = ys)
        translate([x, y, 0]) panel_mount_hole();
}

// =====================================================================
// MODULES — CLIP SYSTEM
// =====================================================================

// Stadium (oblong) base body — the shared shape for both clip halves
module clip_stadium_body() {
    hull() {
        translate([-clip_pin_spacing/2, 0, 0])
            cylinder(r=clip_body_r, h=clip_body_t);
        translate([ clip_pin_spacing/2, 0, 0])
            cylinder(r=clip_body_r, h=clip_body_t);
    }
}

// MALE clip — pins go through the panel holes from the FRONT face.
// Print flat (body on bed, pins pointing up).
// Countersink side goes against the panel front face.
module clip_male() {
    difference() {
        union() {
            clip_stadium_body();
            // Two pins
            for (dx = [-clip_pin_spacing/2, clip_pin_spacing/2])
                translate([dx, 0, clip_body_t])
                    cylinder(d=clip_pin_d, h=clip_pin_h);
        }
        // Small countersink on front (body) face so pin holes are flush to panel
        for (dx = [-clip_pin_spacing/2, clip_pin_spacing/2])
            translate([dx, 0, -eps])
                cylinder(d=mh_csink_d, h=mh_csink_h + eps);
    }
}

// FEMALE clip — barrel holes receive the male pins; hook grips Kallax shelf.
// Print flat (body on bed, hook bridges up).
// Kallax shelf thickness assumed ≈ 16.5mm.
module clip_female() {
    barrel_r = clip_pin_d/2 + clip_barrel_clr;
    hook_gap = kallax_wall_t + 0.5;  // gap inside hook = shelf thickness + clearance

    difference() {
        union() {
            clip_stadium_body();
            // Kallax-edge hook extending from one side of the body
            // The hook wraps over the Kallax shelf edge: arm → shelf gap → lip
            translate([0, clip_body_r, 0]) {
                // Outer arm (away from body, going "up" when mounted)
                cube([brk_wt, clip_hook_len, clip_body_t], center=false);
                // Horizontal return creating the shelf gap
                translate([0, clip_hook_len, 0])
                    cube([clip_body_r * 2, brk_wt, clip_body_t]);
                // Inner retaining lip that presses against the back of the shelf
                translate([0, clip_hook_len + brk_wt - hook_gap, 0])
                    // The "jaw": distance from outer arm inner face to inner face = hook_gap
                    // Inner arm (closes the hook)
                    translate([clip_body_r*2 - brk_wt, 0, 0])
                        cube([brk_wt, clip_hook_lip + hook_gap, clip_body_t]);
            }
        }
        // Barrel holes (receive male pins)
        for (dx = [-clip_pin_spacing/2, clip_pin_spacing/2])
            translate([dx, 0, -eps])
                cylinder(r=barrel_r, h=clip_body_t + 2*eps);
        // Open hook channel (the gap the shelf fits into)
        translate([-clip_body_r + brk_wt, clip_body_r + brk_wt, -eps])
            cube([clip_body_r*2 - 2*brk_wt, hook_gap, clip_body_t + 2*eps]);
    }
}

// =====================================================================
// MODULES — SLIDE-IN BRACKET SYSTEM
// =====================================================================
// Defined in MOUNTED orientation:
//   X = along wall, horizontal
//   Y = into room (away from wall)
//   Z = vertical (up)
//
// PRINT: rotate the bracket so the channel opens upward on the build plate.
//        In slicer: rotate −90° around X axis, then it sits flat with
//        the channel opening facing up (no supports needed).

// Internal bracket body — channel faces +Y, screw in X direction
// has_floor = true for holder_bottom, false for holder_top
module _bracket(has_floor) {
    difference() {
        union() {
            // Base plate (against Kallax back wall)
            cube([brk_w, brk_bt, brk_h]);
            // Inner channel wall (back wall of channel, flush with base inner face)
            translate([0, brk_bt, 0])
                cube([brk_w, brk_wt, brk_ch_ht]);
            // Outer channel wall (front wall of channel)
            translate([0, brk_bt + brk_ch + brk_wt, 0])
                cube([brk_w, brk_wt, brk_ch_ht]);
            // Channel floor — BOTTOM HOLDER ONLY, stops panel from sliding down
            if (has_floor)
                translate([0, brk_bt, 0])
                    cube([brk_w, brk_ch + 2*brk_wt, brk_ft]);
        }
        // M4 screw hole through base plate (Y direction)
        translate([brk_w/2, -eps, brk_h/2])
            rotate([-90, 0, 0])
                cylinder(d=brk_scr_d, h=brk_bt + 2*eps);
    }
}

// Bottom holder: panel bottom edge RESTS on the floor — provides vertical stop.
module holder_bottom() { _bracket(has_floor=true); }

// Top holder: channel guides the panel top edge — NO floor, panel slides through.
// The bottom holders stop the downward travel.
module holder_top()    { _bracket(has_floor=false); }

// =====================================================================
// MODULES — SNAP JOINTS FOR SPLIT PARTS
// =====================================================================

module joint_tongues(edge_len) {
    spacing = edge_len / tongue_per_edge;
    for (i = [0 : tongue_per_edge - 1]) {
        cy = (i + 0.5) * spacing;
        translate([0, cy - tongue_len/2, -eps]) {
            cube([tongue_w, tongue_len, tongue_h + eps]);
            translate([0, (tongue_len - snap_len)/2, tongue_h])
                cube([tongue_w, snap_len, snap_h + eps]);
        }
    }
}

module joint_grooves(edge_len) {
    spacing = edge_len / tongue_per_edge;
    tol = tongue_gap;
    for (i = [0 : tongue_per_edge - 1]) {
        cy = (i + 0.5) * spacing;
        translate([-eps, cy - tongue_len/2 - tol, 0]) {
            cube([tongue_w + tol + eps, tongue_len + 2*tol, tongue_h + tol]);
            translate([0, tol, tongue_h + tol])
                cube([tongue_w + tol + eps, snap_len, snap_h + bead_gap]);
        }
    }
}

// =====================================================================
// MODULES — PANEL BODY
// =====================================================================

// Full assembled panel (preview)
module full_panel() {
    difference() {
        cube([panel_width, panel_height, panel_thickness]);
        hole_pattern();
        all_mount_holes();
    }
}

// Single print segment at grid position (col, row)
module split_part(col, row) {
    x0 = col * part_w;
    y0 = row * part_h;
    xs = mh_xs();
    ys = mh_ys();

    difference() {
        union() {
            translate([x0, y0, 0]) cube([part_w, part_h, panel_thickness]);

            // RIGHT edge tongue (not rightmost col)
            if (col < split_cols - 1)
                translate([x0 + part_w - eps, y0, panel_thickness])
                    joint_tongues(part_h);

            // TOP edge tongue (not topmost row)
            if (row < split_rows - 1)
                translate([x0 + part_w, y0 + part_h - eps, panel_thickness])
                    rotate([0, 0, 90])
                        joint_tongues(part_w);
        }

        // Skadis holes clipped to this part's footprint
        intersection() {
            hole_pattern();
            translate([x0 + eps, y0 + eps, -eps])
                cube([part_w - 2*eps, part_h - 2*eps, panel_thickness + 2*eps]);
        }

        // Mounting holes that fall within or on this segment's footprint
        for (x = xs) for (y = ys)
            if (x >= x0 - eps && x <= x0 + part_w + eps &&
                y >= y0 - eps && y <= y0 + part_h + eps)
                translate([x, y, 0]) panel_mount_hole();

        // LEFT edge groove (not leftmost col)
        if (col > 0)
            translate([x0, y0, panel_thickness])
                joint_grooves(part_h);

        // BOTTOM edge groove (not bottommost row)
        if (row > 0)
            translate([x0 + part_w, y0, panel_thickness])
                rotate([0, 0, 90])
                    joint_grooves(part_w);
    }
}

// =====================================================================
// RENDER DISPATCH
// =====================================================================

if (render_part == "full") {
    full_panel();

} else if (render_part == "clip_male") {
    clip_male();

} else if (render_part == "clip_female") {
    clip_female();

} else if (render_part == "holder_bottom") {
    holder_bottom();

} else if (render_part == "holder_top") {
    holder_top();

} else {
    // Panel segment: render_part is "COL_ROW", e.g. "0_0", "1_2"
    part_map = [
        ["0_0",0,0],["0_1",0,1],["0_2",0,2],["0_3",0,3],
        ["1_0",1,0],["1_1",1,1],["1_2",1,2],["1_3",1,3],
        ["2_0",2,0],["2_1",2,1],["2_2",2,2],["2_3",2,3],
        ["3_0",3,0],["3_1",3,1],["3_2",3,2],["3_3",3,3],
    ];
    found_col = [for (e = part_map) if (e[0] == render_part) e[1]][0];
    found_row = [for (e = part_map) if (e[0] == render_part) e[2]][0];
    split_part(found_col, found_row);
}
