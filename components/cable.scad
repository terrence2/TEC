module cable_strain_relief() {
    color("red")
    translate([-5, -29, 40]) {
        h = 3.5;
        r = 5;
        d = 4.5;
        translate([d+0.5, h, 0])
            cylinder(d=d, h=20);
        for (i = [0 : -5 : -90]) {
            translate([r*cos(i), h, r*sin(i)])
                sphere(d=d);
        }
        for (i = [0 : -5 : -270]) {
            translate([r*cos(i), h, -2*r+r*sin(i)])
                sphere(d=d);
        }
        for (i = [180 : -5 : 0]) {
            translate([1.9*r+r/1.1*cos(i), h, -2*r+r*sin(i)])
                sphere(d=d);
        }
        translate([r+9.1, h, -3*r])
            cylinder(d=d, h=5);
        translate([5, 0, -18])
            scale([12, 14, 7])
                cube(1);
    }
}

