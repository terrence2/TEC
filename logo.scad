module tec_logo_t(th = 20) {
    square([th, 5 * th]);
    translate([-2 * th, th * 5])
        square([5 * th, th]);
}

module tec_logo_c(th = 20) {
    square([th, 6 * th]);
    translate([th, 0])
        square([3 * th, th]);
    translate([th, 5 * th])
        square([3 * th, th]);
}

module tec_logo_d(th = 20) {
    square([th, 6 * th]);
    translate([th, 0])
        square([2.5 * th, th]);
    translate([th, 5 * th])
        square([2.5 * th, th]);
    translate([2 * th, 3.5 * th])
        rotate(-90, [0, 0, 1])
            square([th, 2.5 * th]);
}

function tec_logo_advance(th = 20) = [
    4 * th,
    5.5 * th,
    5 * th,
];

function tec_logo_width(th = 20) = 13.5 * th;

module tec_logo(line_thickness = 20) {
    th = line_thickness;
    tec_logo_t(th);
    translate([tec_logo_advance(th)[0], 0])
        tec_logo_d(th);
    translate([tec_logo_advance(th)[0] + tec_logo_advance(th)[1], 0])
        tec_logo_c(th);
}

tec_logo();
