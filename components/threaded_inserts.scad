// Note: drill bit size in inches
function m2_5_insert_diameter() = 9/64 * 25.4; // mm
function m2_5_insert_length() = 5.6; // mm
module m2_5_insert_cutout() {
    insert_diam = m2_5_insert_diameter();
    insert_len = m2_5_insert_length();
    cylinder(r = insert_diam / 2, h = insert_len + 1, $fn=20);
}

function m3_insert_diameter() = 4.699; // mm (#13 drill bit
function m3_insert_length() = 6.4; // mm
module m3_insert_cutout() {
    color("Red", 0.25)
        cylinder(r = m3_insert_diameter() / 2, h = m3_insert_length() * 1.5);
}
m2_5_insert_cutout();
