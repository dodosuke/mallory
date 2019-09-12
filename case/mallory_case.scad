/* set output quality */
$fn = 50;

width = 351.2987;
height = 132.9143;

hole_distance = 114.0996;
m3_r = 1.75;

switch_hole_size = 20.06;
switch_distance = 19.05;
switch_plate_height = 5;

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
    w = -l*tan(12)/2;
    
    translate([0, 26.0443, 0]) plate(width-6.53*2, height-9.53-26.0443, 50, 1.5);
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


module mid_plate() {
    difference() {
        plate(width, height, 10, 2); 
        pcb_hole();
        screw_holes();
    }
}

switch_positions_1 = [
    [0, 0, 1],
    [-0.2183727, 1, 1],
    [-0.432021, 2, 1],
    [1.20839895, 0.11233596, 1],
    [2.20839895, 0.11233596, 1.2], // For filling the gap
    [1.23989501, 1.11233596, 1.5],
    [2.48976378, 1.11233596, 1],
    [1.15130184, 2.11233596, 1.75],
    [2.52650919, 2.11233596, 1],
    [1.18267717, 3.11233596, 2.25],
    [2.80734908, 3.11233596, 1.2], // For filling the gap
    [0.80787402, 3.6, 1.5], // For filling the gap
    [0.80787402, 4.11233596, 1.5],
    [3.18687664, 0, 1],
];

switch_positions_2 = [
    [0, 0, 1.8], // For filling the gap
    [1, 0, 1.2], // For filling the gap
    [2, 0, 1.2], // For filling the gap
    [3, 0, 1],
    [-0.5, 1, 1.8], // For filling the gap
    [0.5, 1, 1],
    [1.5, 1, 1],
    [2.5, 1, 1],
    [-0.25, 2, 1.8], // For filling the gap
    [0.75, 2, 1],
    [1.75, 2, 1],
    [2.75, 2, 1],
    [0.25, 3, 1.9], // For filling the gap
    [1.25, 3, 1],
    [2.25, 3, 1],
    [3.25, 3, 1],
    [0.25, 4.07929134, 1.5],
    [0.25, 4, 1.5],  // dummy
    [2.125, 4, 2.25],
    [3.625, 4, 1.25],
    [3.75, 4, 1],
];

switch_positions_3 = [
    [0, 0, 1],
    [1, 0, 1.2], // For smoothing
    [2, 0, 1.2], // For smoothing
    [3, 0, 1.05], // For smoothing
    [-0.5, 1, 1],
    [0.5, 1, 1],
    [1.5, 1, 1],
    [2.5, 1, 1.9], // For filling the gap
    [-0.25, 2, 1],
    [0.75, 2, 1],
    [1.75, 2, 1],
    [2.75, 2, 1.9], // For filling the gap
    [-0.75, 3, 1],
    [0.25, 3, 1],
    [1.25, 3, 1],
    [2.25, 3, 1.9], // For filling the gap
    [-0.75, 3.5, 1], // dummy
    [0.125, 4, 2.75],
    [2.25, 4.07929134, 1.5],
    [2.25, 4, 1.5],  // dummy
];

switch_positions_4 = [
    [-0.1, 0, 1.2], // For filling the gap
    [0, 0.11233596, 1], // dummy
    [0.97795276, 0.11233596, 1.2], // For smoothing
    [2.47795276, 0.11233596, 2],
    [-0.28136483, 1.05669291, 1],
    [-0.28136483, 1.2, 1], // dummy
    [0.69658793, 1.11233596, 1],
    [1.69658793, 1.11233596, 1],
    [2.94658793, 1.11233596, 1.5],
    [0.17112861, 2.11233596, 1],
    [1.17112861, 2.11233596, 1],
    [2.79580052, 2.11233596, 2.25],
    [-0.11023622, 3.11233596, 1],
    [0.88976378, 3.11233596, 1.2], // For smoothing
    [2.26476378, 3.11233596, 1.75],
    [3.63976378, 3.11233596, 1],
    [3.19661417, 4.11233596, 1.5],
];

module switch_hole(u=1) {
    translate([0, -switch_hole_size/2, 0]) {
        plate(switch_hole_size+switch_distance*(u-1), switch_hole_size, 50, 1.5);
    }
}

module switch_holes() {
    for (i=switch_positions_1) {
        translate([
            -width/2 + i[0]*switch_distance + 24.26, 
            height - i[1]*switch_distance - 19.03, 
            0
        ]) { switch_hole(i[2]);}
    }
    for (i=switch_positions_2) {
        translate([
            -width/2 + (i[0]*cos(12)-i[1]*cos(78))*switch_distance + 105.47, 
            height - (i[0]*sin(12)+i[1]*sin(78))*switch_distance - 22.99, 
            0
        ]) { rotate([0,0,-12]) switch_hole(i[2]);}
    }
    for (i=switch_positions_3) {
        translate([
            -width/2 + (i[0]*cos(12)+i[1]*cos(78))*switch_distance + 189.5289, 
            height - (i[0]*sin(-12)+i[1]*sin(78))*switch_distance - 32.8933, 
            0
        ]) { rotate([0,0,12]) switch_hole(i[2]);}
    }
    for (i=switch_positions_4) {
        translate([
            -width/2 + i[0]*switch_distance + 265.93, 
            height - i[1]*switch_distance - 19.03, 
            0
        ]) { switch_hole(i[2]);}
    }
}


module switch_plate() {
    difference() {
        plate(width, height, switch_plate_height, 2); 
        switch_holes();
        screw_holes();
    }
}



translate([0,0,-5]) mid_plate();
translate([0,0,switch_plate_height/2]) switch_plate();

