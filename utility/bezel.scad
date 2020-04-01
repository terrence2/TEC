module bcube(v, r = 1, fn = 10) {
    hull() {
        bcube_p(v, r=r, fn = fn);
    }
}

module bcube_p(v, r = 1, fn = 10) {
    echo("fn: ", fn);
    translate([r, r, r])
        sphere(r=r, $fn=fn);
    translate([v[0] - r, r, r])
        sphere(r=r, $fn=fn);
    translate([r, v[1] - r, r])
        sphere(r=r, $fn=fn);
    translate([v[0] - r, v[1] - r, r])
        sphere(r=r, $fn=fn);
    translate([r, r, v[2] - r])
        sphere(r=r, $fn=fn);
    translate([v[0] - r, r, v[2] - r])
        sphere(r=r, $fn=fn);
    translate([r, v[1] - r, v[2] - r])
        sphere(r=r, $fn=fn);
    translate([v[0] - r, v[1] - r, v[2] - r])
        sphere(r=r, $fn=fn);
}

$fn = 15;
bcube([10, 10, 10], r=1);
