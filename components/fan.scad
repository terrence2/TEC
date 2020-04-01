/** A typical 120mm fan */
module fan120() {
    fan(size = 120, hole_spacing = 105, thickness = 25, hub_r = 20);
}

/** Cutouts for a 120mm fan's holes. */
module fan120_cutout() {
    fan_cutout(size = 120, hole_spacing = 105);
}

/** A typical 140mm fan */
module fan140() {
    fan(size = 140, hole_spacing = 124.5, thickness = 25, hub_r = 20);
}

/** Cutouts for a 140mm fan's holes. */
module fan140_cutout() {
    fan_cutout(size = 140, hole_spacing = 124.5);
}

/** A typical 80mm fan */
module fan80() {
    fan(size = 80, hole_spacing = 71.5, thickness = 15, hub_r = 15);
}

/** Cutouts for an 80mm fan's holes. */
module fan80_cutout() {
    fan_cutout(size = 80, hole_spacing = 71.5);
}

/** A typical 60mm fan */
module fan60() {
    fan(size = 60, hole_spacing = 50, thickness = 25, hub_r = 13);
}

/** Cutouts for a 60mm fan's holes. */
module fan60_cutout() {
    fan_cutout(size = 60, hole_spacing = 50);
}

module fan60_keepout() {
    fan_keepout(60, 25, 2);
}

module fan40() {
    fan(size = 40, hole_spacing = 32, thickness = 20, hub_r = 10);
}

module fan40_cutout() {
    fan_cutout(size = 40, hole_spacing = 32);
}

module fan40_keepout() {
    fan_keepout(40, 20, 2);
}

/** Render a parameterized fan. */
module fan(size, hole_spacing, thickness, hub_r) {
    s = size;
    r = s / 2;
    plate_d = 2;

    difference() {
        union() {
            // Frame
            color("DimGray") {
                difference() {
                    // Frame
                    union() {
                        intersection() {
                            translate([r, r, 0])
                                cylinder(d = s + 10, h = thickness);
                            __fan_plate(s, thickness);
                        }
                        __fan_plate(s, 2);
                        translate([0, 0, thickness - 2])
                            __fan_plate(s, 2);
                    }
                    // Center
                    translate([s / 2, s / 2, -1])
                        cylinder(d = s - 4, h = thickness + 2);
                }
                translate([r, r, 0])
                    cylinder(r = hub_r, h = plate_d);

                w = 5;
                for (i = [0:4]) {
                    translate([r, r, 0])
                        rotate(i * 90, [0, 0, 1])
                            translate([0, -hub_r, 0])
                                cube([r, w, 2]);
                }
            }

            // Hub + Blades
            color("White") {
                translate([r, r, plate_d])
                    cylinder(r = hub_r - 1, h = thickness - plate_d);

                blade_cnt = 8;
                for (i = [0:blade_cnt]) {
                    translate([r, r, plate_d + 1])
                        rotate(i * 360 / blade_cnt, [0, 0, 1])
                            rotate(30, [1, 0, 0])
                                cube([r - 3, 0.5, thickness - plate_d]);
                }
            }
        }
        // hole punch
        color("red") {
            x0 = r - hole_spacing / 2;
            x1 = s - x0;
            translate([x0, x0, 0])
                cylinder(d = 4.3, h = thickness + 2);
            translate([x0, x1, 0])
                cylinder(d = 4.3, h = thickness + 2);
            translate([x1, x1, 0])
                cylinder(d = 4.3, h = thickness + 2);
            translate([x1, x0, 0])
                cylinder(d = 4.3, h = thickness + 2);
        }
    }
}

module fan_cutout(size, hole_spacing) {
    s = size;
    r = s / 2;
    hole_diam = 4.3;
    cutout_length = 10;

    color("red", 0.25) {
        x0 = r - hole_spacing / 2;
        x1 = s - x0;
        translate([x0, x0, -cutout_length])
            cylinder(d = hole_diam, h = cutout_length);
        translate([x0, x1, -cutout_length])
            cylinder(d = hole_diam, h = cutout_length);
        translate([x1, x1, -cutout_length])
            cylinder(d = hole_diam, h = cutout_length);
        translate([x1, x0, -cutout_length])
            cylinder(d = hole_diam, h = cutout_length);
        translate([s / 2, s / 2, -cutout_length])
            cylinder(d = s, h = cutout_length);
    }
}

module fan_keepout(size, thickness, pad) {
    color("red", 0.25) {
        translate([-pad, -pad, 0]) {
            cube([size + 2 * pad, size + 2 * pad, thickness + pad]);
        }
    }
}

module __fan_plate(s, thickness) {
    r = 4;
    hull() {
        translate([r, r, 0])
            cylinder(r=r, h=thickness);
        translate([s - r, r, 0])
            cylinder(r=r, h=thickness);
        translate([s - r, s - 4, 0])
            cylinder(r=r, h=thickness);
        translate([r, s - 4, 0])
            cylinder(r=r, h=thickness);
    }
}

// Demo
$fn = 40;

translate([-160, 0, 0]) {
    fan140();
    fan140_cutout();
}

fan120();
fan120_cutout();

translate([140, 0, 0]) {
    fan80();
    fan80_cutout();
}

translate([240, 0, 0]) {
    fan60();
    fan60_cutout();
    fan60_keepout();
}

translate([320, 0, 0]) {
    fan40();
    fan40_cutout();
    fan40_keepout();
}
