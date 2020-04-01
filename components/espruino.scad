function micro_usb_plug_size() = [35, 11, 6];
function micro_usb_receptical_size() = [6, 7.5, 3];

function espruino_wifi_board_size() = [28, 23, 1];
function espruino_wifi_overhang_width() = 6 + 23.5 - 28;
function espruino_wifi_offset_depth() = -micro_usb_receptical_size()[2];

module espruino_wifi() {
    // Base PCB
    sz = espruino_wifi_board_size();
    board_w = sz[0];
    board_h = sz[1];
    board_d = sz[2];
    color("DarkGreen")
    cube([board_w, board_h, board_d]);

    // SMT Wifi Module PCB
    wifi_module_w = 23.5;
    wifi_module_h = 16;
    wifi_module_d = 1;
    wifi_module_offset = 6;
    color("DarkGreen")
    translate([wifi_module_offset, (board_h - wifi_module_h) / 2, wifi_module_d])
        cube([wifi_module_w, wifi_module_h, wifi_module_d]);

    // Wifi module
    wifi_w = 15;
    wifi_h = 11;
    color("Snow")
    translate([wifi_module_offset + 0.5, (board_h - wifi_module_h) / 2 + (wifi_module_h - wifi_h) / 2, board_d + wifi_module_d])
        cube([wifi_w, wifi_h, 1.5]);

    // CPU
    cpu_s = 7;
    cpu_d = 0.2;
    cpu_off = 10;
    color("Black")
    translate([cpu_off, (board_h - cpu_s) / 2, -cpu_d])
        cube([cpu_s, cpu_s, cpu_d]);

    // USB receptical
    u_sz = micro_usb_receptical_size();
    usb_w = u_sz[0];
    usb_h = u_sz[1];
    usb_d = u_sz[2];
    usb_h_off = board_h - usb_h - 3;
    translate([0, usb_h_off, -usb_d])
        cube([usb_w, usb_h, usb_d]);

    // USB Plug
    pu_sz = micro_usb_plug_size();
    plug_ko_w = pu_sz[0];
    plug_ko_h = pu_sz[1];
    plug_ko_d = pu_sz[2];
    color("DimGrey")
    translate([-plug_ko_w, usb_h_off - (plug_ko_h - usb_h) / 2, -plug_ko_d / 2 - usb_d / 2])
        cube([plug_ko_w, plug_ko_h, plug_ko_d]);

    // Pin blocks
    pin_base_s = 2.5;
    pin_spacing = 0.1 * 25.4;
    pin_s = 0.4;
    pin_len = 6 + pin_base_s + board_d + 1;
    pin_off = 6;
    color("DimGray")
    translate([0, 0, board_d])
        cube([board_w, pin_base_s, pin_base_s]);
    for (i = [0:10]) {
        translate([pin_spacing / 2 - pin_s / 2 + pin_spacing * i, pin_base_s / 2 - pin_s / 2, -1])
            cube([0.4, 0.4, pin_len]);
    }
    color("DimGray")
    translate([0, board_h - pin_base_s, board_d])
        cube([board_w, pin_base_s, pin_base_s]);
    for (i = [0:10]) {
        translate([pin_spacing / 2 - pin_s / 2 + pin_spacing * i, board_h - pin_base_s + pin_base_s / 2 - pin_s / 2, -1])
            cube([0.4, 0.4, pin_len]);
    }
}

module espruino_wifi_cutout(extra_depth = 0, pad = 1) {
    sz = espruino_wifi_board_size();
    board_w = sz[0];
    board_h = sz[1];
    board_d = sz[2];

    ovh_w = espruino_wifi_overhang_width();
    offset_d = espruino_wifi_offset_depth();

    u_sz = micro_usb_receptical_size();
    usb_w = u_sz[0];
    usb_h = u_sz[1];
    usb_d = u_sz[2];

    pu_sz = micro_usb_plug_size();
    plug_ko_w = pu_sz[0];
    plug_ko_h = pu_sz[1];
    plug_ko_d = pu_sz[2];

    usb_h_off = board_h - usb_h - 3;

    color("Red", 0.25)
    union() {
        translate([-pad / 2, -pad / 2, offset_d - pad / 2])
            cube([board_w + ovh_w + pad, board_h + pad, board_d + 11.5 + extra_depth + pad]);
        translate([-plug_ko_w - pad / 2, usb_h_off - (plug_ko_h - usb_h) / 2 - pad / 2, -plug_ko_d / 2 - usb_d / 2 - pad / 2])
            cube([plug_ko_w + pad, plug_ko_h + pad, plug_ko_d + pad + 11.5 + extra_depth]);
    }

}

espruino_wifi();
espruino_wifi_cutout();
