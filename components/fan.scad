$fn = 40;

module fan120() {
    fan(size = 120, hole_spacing = 105, thickness = 25, hub_r = 20);
}

module fan140() {
    fan(size = 140, hole_spacing = 124.5, thickness = 25, hub_r = 20);
}

module fan80() {
    fan(size = 80, hole_spacing = 71.5, thickness = 15, hub_r = 15);
}

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
                            __plate(s, thickness);
                        }
                        __plate(s, 2);
                        translate([0, 0, thickness - 2])
                            __plate(s, 2);
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

module __plate(s, thickness) {
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

translate([-160, 0, 0])
    fan140();

fan120();

translate([140, 0, 0])
    fan80();
