$fn=40;

function raspberry_pi4_pcb_size() = [85, 56, 1.5];
function raspberry_pi4_hole_offsets() = [3.5, 3.5 + 58, 3.5, 3.5 + 49];

module __pcb() {
    sz = raspberry_pi4_pcb_size();
    w = sz[0];
    h = sz[1];
    d = sz[2];

    color("MediumSeaGreen")
    linear_extrude(height = d) {
        hull() {
            translate([3, 3, 0])
                circle(r=3);
            translate([w - 3, 3, 0])
                circle(r=3);
            translate([w - 3, h - 3, 0])
                circle(r=3);
            translate([3, h - 3, 0])
                circle(r=3);
        }
    }
}

module __drill_mask() {
    hole_diam = 2.7;

    offsets = raspberry_pi4_hole_offsets();
    x0 = offsets[0];
    x1 = offsets[1];
    y0 = offsets[2];
    y1 = offsets[3];

    sz = raspberry_pi4_pcb_size();
    d = sz[2];

    translate([x0, y0, -d])
        cylinder(d=hole_diam, h=3 * d);
    translate([x1, y0, -d])
        cylinder(d=hole_diam, h=3 * d);
    translate([x0, y1, -d])
        cylinder(d=hole_diam, h=3 * d);
    translate([x1, y1, -d])
        cylinder(d=hole_diam, h=3 * d);
}

/**
 * Generate standoffs to mount the raspberry pi 4.
 * Assumes use of https://www.mcmaster.com/94180a321
 */
module raspberry_pi4_standoffs() {
    offsets = raspberry_pi4_hole_offsets();
    x0 = offsets[0];
    x1 = offsets[1];
    y0 = offsets[2];
    y1 = offsets[3];

    insert_length = 3.4;
    hole_diam = 4.2;
    hole_depth = insert_length * 1.5;
    standoff_diameter = hole_diam * 1.75;
    standoff_height = insert_length * 2;

    difference() {
        translate([x0, y0, -standoff_height])
            cylinder(d=standoff_diameter, h=standoff_height);
        translate([x0, y0, -hole_depth])
            cylinder(d=hole_diam, h=hole_depth+0.1);
    }
    difference() {
        translate([x1, y0, -standoff_height])
            cylinder(d=standoff_diameter, h=standoff_height);
        translate([x1, y0, -hole_depth])
            cylinder(d=hole_diam, h=hole_depth + 0.1);
    }
    difference() {
        translate([x0, y1, -standoff_height])
            cylinder(d=standoff_diameter, h=standoff_height);
        translate([x0, y1, -hole_depth])
            cylinder(d=hole_diam, h=hole_depth + 0.1);
    }
    difference() {
        translate([x1, y1, -standoff_height])
            cylinder(d=standoff_diameter, h=standoff_height);
        translate([x1, y1, -hole_depth])
            cylinder(d=hole_diam, h=hole_depth + 0.1);
    }
}


module __connectors(make_cutouts) {
    if (make_cutouts) {
        __connectors_inner("Red", 0.25, -0.4, 0.8);
    } else {
        __connectors_inner("LightGrey", 1, 0, 0);
    }
}

module __connectors_inner(clr, opacity, d_adj, ext) {
    sz = raspberry_pi4_pcb_size();
    w = sz[0];
    h = sz[1];
    d = sz[2] + d_adj;

    ovh = 2 + 5 * ext;

    color(clr, opacity) {
        // Ethernet jack
        ew = 21.3 + ext;
        eh = 16.26 + ext;
        ed = 13.5 + ext;
        translate([w - ew + ovh, 45.75 - eh / 2, d])
            cube([ew, eh, ed]);

        // USB
        uw = 17 + ext;
        uh = 12.5 + ext;
        ud = 16 + ext;
        translate([w - uw + ovh, 27 - uh / 2, d])
            cube([uw, uh, ud]);
        translate([w - uw + ovh, 9 - uh / 2, d])
            cube([uw, uh, ud]);

        // USB-C
        ucw = 9 + ext;
        uch = 10.5 + ext;
        ucd = 3.2 + ext;
        translate([3.5 + 7.7 - ucw / 2, -ovh, d])
            cube([ucw, uch, ucd]);

        // Micro-HDMI ports
        mhdiw = 6.5 + ext;
        mhdih = 7.5 + ext;
        mhdid = 3 + ext;
        translate([3.5 + 7.7 + 14.8 - mhdiw / 2, -ovh, d])
            cube([mhdiw, mhdih, mhdid]);
        translate([3.5 + 7.7 + 14.8 + 13.5 - mhdiw / 2, -ovh, d])
            cube([mhdiw, mhdih, mhdid]);

        // Audio plug port
        aw = 8 + ext;
        ah = 12 + ext;
        ad = 6 + ext;
        adia = 6 + ext;
        translate([3.5 + 7.7 + 14.8 + 13.5 + 7 + 7.5 - aw / 2, 0, d]) {
            rotate(90, [1, 0, 0])
                translate([aw / 2, adia / 2, 0])
                    cylinder(d=adia, h=ovh);
            cube([aw, ah, ad]);
        }
    }
}

module __chips() {
    sz = raspberry_pi4_pcb_size();
    w = sz[0];
    h = sz[1];
    d = sz[2];

    // Pin bank
    pw = 20 * 0.1 * 25.4; // 20 pins wide at 0.1 spacing (half around edge)
    ph = 2 * 0.1 * 25.4; // 2 pins across
    translate([3.5 + 29 - pw / 2, h - ph - 3.5 + ph / 2, d])
        cube([pw, ph, 8.5]);

    // CPU
    cw = 12.6;
    ch = 12.6;
    cd = 2.4;
    translate([3.5 + 25.75 - cw / 2, 32.5 - ch / 2, d])
        cube([cw, ch, cd]);
}

/**
 * Origin is the lower left corner, at the bottom of the pcb,
 * with the USB oriented to the right.
 */
module raspberry_pi4() {
    difference() {
        union() {
            __pcb();
            __chips();
            __connectors(false);
        }
        __drill_mask();
    }
}

module raspberry_pi4_cutouts() {
    __connectors(true);
}

raspberry_pi4();
raspberry_pi4_cutouts();
raspberry_pi4_standoffs();
