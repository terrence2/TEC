use <../logo.scad>
use <../components/cable.scad>
use <../components/espruino.scad>
use <../components/pir.scad>
use <../components/threaded_inserts.scad>

module case_outer() {
    difference() {
        union() {
            __case_base();
            __case_eye_popout();
            __case_top_logo();
        }
        __case_texturing();
    }
}

case_split_height = 10;
module case_bottom() {
    difference() {
        case_outer();
        translate([-10, -10, case_split_height])
            cube([case_width * 2, case_height * 2, case_depth * 2]);
    }
}

module case_top(show_components = false) {
    difference() {
        __case_top_shell();
        __case_top_pir_cutout();
        __case_top_indicator_cutout();
        __case_top_closure_mounts();
        __case_top_espruino_cutout();
        __case_strain_relief();
        __case_led_wire_guide();
    }
    __case_top_pir_supports();
    if (show_components) {
        pir_component();
        __case_top_espruino_cutout(show_components = true);
    }
}

module __case_strain_relief() {
    rotate(90, [1, 0, 0])
        translate([25, 37, -41])
            cable_strain_relief();
}

module __case_led_wire_guide() {
    w = 15;
    translate([case_width - w - 15, 30, 0])
        cube([w, 5, 15]);
}

module __case_top_espruino_cutout(show_components = false) {
    pad = 1;

    sz = espruino_wifi_board_size();
    board_w = sz[0];
    board_h = sz[1];
    board_d = sz[2];

    ovh_w = espruino_wifi_overhang_width();
    offset_d = espruino_wifi_offset_depth();

    translate([board_h + pad + 10, board_w + ovh_w + pad + 18.4, 22])
        rotate(-90, [0, 0, 1])
            rotate(180, [1, 0, 0]) {
                if (!show_components) {
                    espruino_wifi_cutout(extra_depth = 10, pad = pad);
                } else {
                    espruino_wifi();
                }
            }
}

case_wall = 5;
module __case_inside_chamber() {
    // Figure out fractional scales to get a fixed size padding around the thing.
    sw = (case_width - 2 * case_wall) / case_width;
    sh = (case_height - 2 * case_wall) / case_height;
    sd = (case_depth - 2 * case_wall) / case_depth;

    translate([case_wall, case_wall, case_wall])
        scale([sw, sh, sd])
            __case_base();
}

module case_indicator_plug() {
    __case_indicator_plug();
}

module __case_top_shell() {
    difference() {
        case_outer();
        translate([-10, -10, -2 * case_depth + case_split_height])
            cube([case_width * 2, case_height * 2, case_depth * 2]);
    }
}

case_standoff_r = 2 * m3_insert_diameter() / 2;
function case_closure_positions() = [
    [
        case_wall + case_standoff_r,
        case_wall + case_standoff_r
    ],
    [
        case_width /*- case_standoff_r*/ - case_wall,
        case_wall /*+ case_standoff_r*/
    ],
    [
        case_wall + case_standoff_r,
        case_height - case_standoff_r - case_wall
    ],
    [
        case_width - case_standoff_r - case_wall,
        case_height - case_standoff_r - case_wall
    ]
];

module __case_top_closure_mounts() {
    z_off = case_split_height;
    xy = case_closure_positions();
    for (i = [0:3]) {
        translate([xy[i][0], xy[i][1], case_split_height + 0.1 - 1])
            m3_insert_cutout();
    }
}

module __case_top_pir_cutout() {
    pir_w = adafruit_pir_board_width() + 2;
    pir_h = adafruit_pir_board_height() + 2;
    translate([(eye_po_h - pir_w) / 2, case_height - eye_po_offset - eye_po_h / 2 - pir_h / 2, 0])
        cube([pir_w, pir_h, case_depth + eye_filet - 2]);
    translate([(eye_po_h - adafruit_pir_board_width()) / 2, case_height - eye_po_offset - eye_po_h / 2 - adafruit_pir_board_height() / 2, case_depth - 2])
        adafruit_pir_cutout();
}

module __case_top_pir_supports() {
    /*
    pir_w = adafruit_pir_board_width() + 2;
    pir_h = adafruit_pir_board_height() + 2;
    translate([(eye_po_h - pir_w) / 2, case_height - eye_po_offset - eye_po_h / 2 - pir_h / 2, 0])
        cylinder(r=2, h=2, $fn=10);
    */
}

case_width = 60;
case_height = 100;
case_depth = 30;
case_filet = 4;
module __case_base() {
    filet = case_filet;
    fn = 30;
    color("DarkGrey")
    hull() {
        translate([filet, filet, case_depth - filet])
            sphere(filet, $fn=fn);
        translate([filet, filet, filet])
            sphere(filet, $fn=fn);
        translate([filet, case_height - filet, case_depth - filet])
            sphere(filet, $fn=fn);
        translate([filet, case_height - filet, filet])
            sphere(filet, $fn=fn);
        translate([case_width - filet, filet, case_depth - filet])
            sphere(filet, $fn=fn);
        translate([case_width - filet, filet, filet])
            sphere(filet, $fn=fn);
        translate([case_width - filet, case_height - filet, case_depth - filet])
            sphere(filet, $fn=fn);
        translate([case_width - filet, case_height - filet, filet])
            sphere(filet, $fn=fn);
    }
}

eye_po_offset = 8;
eye_po_h = 50;
eye_filet = 4;
module __case_eye_popout() {
    filet = eye_filet;
    fn = 30;
    color("DimGrey")
    hull() {
        translate([0, case_height - eye_po_offset - filet, case_depth])
            sphere(filet, $fn=fn);
        translate([0, case_height - eye_po_offset - filet, case_depth - 15])
            sphere(filet, $fn=fn);
        translate([0, case_height - eye_po_offset - eye_po_h + filet, case_depth])
            sphere(filet, $fn=fn);
        translate([0, case_height - eye_po_offset - eye_po_h + filet, case_depth - 15])
            sphere(filet, $fn=fn);

        cnt = 30;
        for (i = [0:cnt/2]) {
            a = i * 360 / cnt;
            x = sin(a) * (eye_po_h - 2 * filet) / 2;
            y = cos(a) * (eye_po_h - 2 * filet) / 2;
            translate([x + eye_po_h / 2, y + case_height - eye_po_offset - eye_po_h / 2, case_depth])
                sphere(filet, $fn=fn);
        }
    }
}

module __case_top_logo() {
    color("LightBlue")
    translate([eye_po_h / 2 - tec_logo_width(1), case_height - eye_po_h - eye_po_offset - 9, case_depth])
        linear_extrude(1)
            tec_logo(line_thickness = 1);
}

case_texture_lines = 4;
case_texture_base = 8;
case_texture_spacing = 6.5;
module __case_texturing() {
    for (i = [0:case_texture_lines - 1]) {
        __case_texture_cutout(offset = case_texture_base + case_texture_spacing * i);
    }
}

module __case_texture_cutout(offset = 0) {
    strip_width = 36;
    strip_height = 3;
    strip_depth = 13;
    cut_depth = 2;
    ovf = 8;
    fn = 10;

    union() {
        translate([-ovf + cut_depth, offset, case_depth - 2])
            cube([strip_width + ovf - 2, strip_height, ovf]);
        translate([-ovf + cut_depth, offset, case_depth - cut_depth - strip_depth])
            cube([ovf, strip_height, strip_depth]);
        difference() {
            translate([cut_depth, offset, case_depth - case_filet - cut_depth])
                cube([case_filet, strip_height, case_filet]);
            translate([cut_depth + case_filet, offset + strip_height, case_depth - case_filet - cut_depth])
                rotate(90, [1, 0, 0])
                    cylinder(r = case_filet, h = strip_height);
        }
        translate([strip_width, offset + strip_height / 2, case_depth - cut_depth])
            cylinder(r = strip_height / 2, h = ovf, $fn=fn);

        translate([-ovf + cut_depth, offset + strip_height / 2, case_depth - strip_depth - cut_depth])
            rotate(90, [0, 1, 0])
                cylinder(r = strip_height / 2, h = ovf, $fn=fn);

    }
}

indicator_width = 10;
indicator_height = 40;
indicator_lip = 3;
indicator_plug_y = case_wall + indicator_lip + case_wall;
indicator_radius_offset = 4;
module __case_top_indicator_cutout() {
    __case_top_indicator_cutout_hole();
    __case_top_indicator_cutout_lip();
}

module __case_top_indicator_cutout_hole() {
    color("Red")
    difference() {
        translate([case_width - case_wall - indicator_width - indicator_lip, indicator_plug_y, 0.5])
            cube([indicator_width, indicator_height, case_depth]);
        off = indicator_radius_offset;
        translate([off + eye_po_h / 2, case_height - eye_po_offset - eye_po_h / 2 - off, 0])
            cylinder(d = eye_po_h, h = case_depth * 2, $fn=100);
    }
}

module __case_top_indicator_cutout_lip() {
    color("Red")
    translate([case_width - case_wall - indicator_width - 2 * indicator_lip, indicator_plug_y - indicator_lip, -case_wall])
        cube([indicator_width + 2 * indicator_lip, indicator_height + 2 * indicator_lip, case_depth]);
}

indicator_plug_lip = 2;
indicator_plug_depth = case_depth - case_split_height - 2 * case_wall;
module __case_indicator_plug() {
    plug_x = case_width - case_wall - indicator_width - indicator_lip;
    plug_y = indicator_plug_y;
    difference() {
        translate([plug_x, plug_y, case_depth - 2 * case_wall])
            cube([indicator_width, indicator_height, 2 * case_wall]);
        off = indicator_radius_offset;
        translate([off + eye_po_h / 2, case_height - eye_po_offset - eye_po_h / 2 - off, 0])
            cylinder(d = eye_po_h, h = case_depth * 2, $fn=100);
        translate([plug_x, plug_y, case_depth + 1.3]) {
            base_x = 2.5;
            delta_x = 2.5;
            base_y = 3;
            delta_y = 2.75;
            for (i = [0:2]) {
                x = base_x + i * delta_x;
                for (j = [0:9]) {
                    y = base_y + j * delta_y;
                    translate([x, y, 0])
                        color("White")
                        sphere(r=1.5, $fn=20);
                }
            }
        }
    }
    translate([case_width - case_wall - indicator_width - indicator_lip - indicator_plug_lip,
               indicator_plug_y - indicator_plug_lip,
               case_depth - case_wall - indicator_plug_depth])
        cube([indicator_width + 2 * indicator_plug_lip, indicator_height + 2 * indicator_plug_lip, indicator_plug_depth]);
}


//case_bottom();
case_top(show_components=false);
//case_indicator_plug();
//cpu_component();

module cpu_component() {
    translate([2 * case_wall + m3_insert_diameter(), case_wall, 22])
        translate([0, 50, -5])
        rotate(180, [1, 0, 0])
            rotate(-90, [0, 0, 1])
                espruino_wifi();
}

module pir_component() {
    translate([(eye_po_h - adafruit_pir_board_width()) / 2, case_height - eye_po_offset - eye_po_h / 2 - adafruit_pir_board_height() / 2, case_depth - 2])
        adafruit_pir();
}
