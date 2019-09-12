/* set output quality */
$fn = 50;

width = 351.2987;
height = 132.9143;
depth = 10;

hole_distance = 114.0996;
m3_r = 1.75;

module plate(w, h, d, edge_r) {
    hull() {
        translate([ w/2-edge_r, h-edge_r, 0]) cylinder(r=edge_r, h=d, center=true);
        translate([-w/2+edge_r,   edge_r, 0]) cylinder(r=edge_r, h=d, center=true);
        translate([ w/2-edge_r,   edge_r, 0]) cylinder(r=edge_r, h=d, center=true);
        translate([-w/2+edge_r, h-edge_r, 0]) cylinder(r=edge_r, h=d, center=true);
    }
}

module pcb_hole() {
    l = 200;
    w = -l*cos(90-12);
    
    translate([0, 26.0443, 0]) plate(width-6.53*2, height-9.53-26.0443, depth+2, 1.5);
    translate([(72.64-73.1387)/2, 26.0443-w-20.1355, -10]) linear_extrude(height=20, slices=20, twist=0) polygon(points=[[l/2,0], [-l/2,0], [0,w]]);
}

screw_positions = [
    [hole_distance*0.5, 4.5],
    [hole_distance*1.5, 4.5],
    [hole_distance*-0.5, 4.5],
    [hole_distance*-1.5, 4.5],
    [hole_distance*0.5, height-4.5],
    [hole_distance*1.5, height-4.5],
    [hole_distance*-0.5, height-4.5],
    [hole_distance*-1.5, height-4.5],
];

module screw_holes() {
    for (i=screw_positions) {
        translate([i[0], i[1], 0]) cylinder(r=m3_r, h=50, center=true);
    }
}


module base() {
    difference() {
        plate(width, height, depth, 2); 
        pcb_hole();
        screw_holes();
    }
}

translate([0,0,depth/2]) base();

