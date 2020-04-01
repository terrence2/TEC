function adafruit_pir_board_width() = 32;
function adafruit_pir_board_height() = 24;
function adafruit_pir_board_depth() = 1;
function adafruit_pir_screw_hole_to_side() = 0.1;
function adafruit_pir_screw_hole_radius() = 1;
function adafruit_pir_diffuser_square_size() = 23;
function adafruit_pir_diffuser_square_depth() = 2.5;
function adafruit_pir_diffuser_sphere_circumference() = 22;
function adafruit_pir_diffuser_sphere_height() = 12;

module adafruit_pir() {
    board_h = adafruit_pir_board_height();
    board_w = adafruit_pir_board_width();
    board_d = adafruit_pir_board_depth();

    difference() {
        union() {
            // board
            color("DarkGreen")
            cube([board_w, board_h, board_d]);

            // top part
            base_s = adafruit_pir_diffuser_square_size();
            base_d = adafruit_pir_diffuser_square_depth();
            sphere_c = adafruit_pir_diffuser_sphere_circumference();
            sphere_h = adafruit_pir_diffuser_sphere_height();
            translate([(board_w - base_s) / 2, (board_h - base_s) / 2, board_d])
                cube([base_s, base_s, base_d]);
            difference() {
                translate([board_w / 2, board_h / 2, board_d + base_d + 2])
                    sphere(r=sphere_c / 2);
                translate([0, 0, -sphere_c + 1])
                    cube([board_w, board_h, sphere_c]);
            }
        }

        // through holes
        hole_radius = adafruit_pir_screw_hole_radius();
        hole_to_side = adafruit_pir_screw_hole_to_side();
        translate([hole_radius + hole_to_side, board_h / 2, -0.1])
            cylinder(r = hole_radius, h = board_d * 2, $fn=50);
        translate([board_w - hole_radius - hole_to_side, board_h / 2, -0.1])
            cylinder(r = hole_radius, h = board_d * 2, $fn=50);
    }
}

module adafruit_pir_standoffs(extra_depth = 0) {
    board_h = adafruit_pir_board_height();
    board_w = adafruit_pir_board_width();
    board_d = adafruit_pir_board_depth();
    hole_radius = adafruit_pir_screw_hole_radius();
    so_radius = 2 * hole_radius;
    so_height = adafruit_pir_diffuser_square_depth() + extra_depth;
    hole_to_side = adafruit_pir_screw_hole_to_side();
    predrill_radius = 0.4;
    difference() {
        union() {
            translate([hole_radius + hole_to_side, board_h / 2, board_d])
                cylinder(r = so_radius, h = so_height, $fn=50);
            translate([board_w - hole_radius - hole_to_side, board_h / 2, board_d])
                cylinder(r = so_radius, h = so_height, $fn=50);
        }
        translate([hole_radius + hole_to_side, board_h / 2, board_d - 1])
            cylinder(r = predrill_radius, h = so_height, $fn=50);
        translate([board_w - hole_radius - hole_to_side, board_h / 2, board_d - 1])
            cylinder(r = predrill_radius, h = so_height, $fn=50);
    }

}

module adafruit_pir_cutout() {
    board_h = adafruit_pir_board_height();
    board_w = adafruit_pir_board_width();
    board_d = adafruit_pir_board_depth();
    base_d = adafruit_pir_diffuser_square_depth();
    sphere_c = adafruit_pir_diffuser_sphere_circumference() + 1;

    color("Red", 0.5) {
        translate([board_w / 2, board_h / 2, board_d + base_d + 2])
            sphere(r=sphere_c / 2);
    }
}

adafruit_pir();
adafruit_pir_standoffs();
adafruit_pir_cutout();
