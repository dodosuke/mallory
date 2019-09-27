/* set output quality */
$fn = 50;

// constants
width = 351.30;
height = 132.91;
case_hole_distance = 114.0996;
m3_r = 1.75;
pcb_screw_insert_r = 1.75;
switch_hole_size = 20.1;
switch_distance = 19.05;

// variables
switch_plate_height = 5;
mid_plate_height = 10;


module base_plate(xyz, edge_r) {
    positions = [
        [xyz[0]-edge_r, xyz[1]-edge_r],
        [       edge_r,        edge_r],
        [xyz[0]-edge_r,        edge_r],
        [       edge_r, xyz[1]-edge_r]
    ];
    
    hull() {
        if (xyz[2]==0) {
            for (p=positions) {
                translate(p) circle(r=edge_r);
            }
        } else {
            for (p=positions) {
                translate(p) cylinder(r=edge_r, h=xyz[2]);
            }
        }
    }
}

module plate(xyz, edge_r, center=false) {
    if (center) {
        translate([-xyz[0]/2, -xyz[1]/2, -xyz[2]/2]) base_plate(xyz, edge_r);
    } else {
        base_plate(xyz, edge_r);
    }
}

module screw_hole(position, depth, r=m3_r) {
    if (depth==0) {
        translate(position) circle(r=r);
    } else {
        translate(position) cylinder(r=r, h=50, center=true);
    }
}

case_screw_positions = [
    [width/2+case_hole_distance*0.5, 4.5],
    [width/2+case_hole_distance*1.5, 4.5],
    [width/2-case_hole_distance*0.5, 4.5],
    [width/2-case_hole_distance*1.5, 4.5],
    [width/2+case_hole_distance*0.5, height-4.5],
    [width/2+case_hole_distance*1.5, height-4.5],
    [width/2-case_hole_distance*0.5, height-4.5],
    [width/2-case_hole_distance*1.5, height-4.5],
];

module case_screw_holes(depth) {
    for (i=case_screw_positions) {
        screw_hole([i[0], i[1], 0], depth=depth);
    }
}

module pcb_hole() {
    top_wall=8.5;
    side_wall=5.5;
    bottom_wall=25;    
    l = 200;
    w = -l*tan(12)/2;
    
    translate([side_wall, bottom_wall, -10]) {
        plate([width-side_wall*2, height-top_wall-bottom_wall, 50], 1.5);
    }
    
    // triangle part
    translate([width/2+(72.64-73.1387)/2, bottom_wall-w-20.1355, -10]) {
        linear_extrude(height=50, slices=20, twist=0) 
        polygon(points=[[l/2,0], [-l/2,0], [0,w]]);
    }
}

pcb_screw_positions = [
    [width/2-151.38935, 126.4143, -90],
    [width/2+151.38935, 126.4143, -90],
    [width/2-151.38935,  22.5143,  90],
    [width/2+151.38935,  22.5143,  90],
    [width/2-41.38165,  117.1262, -102],
    [width/2-48.25285,   12.759 ,  78],
    [width/2+47.75415,   12.759 , 102],
    [width/2+39.56365,  118.8066, -78],
];

module mv(r, a) {
    translate([
        r * cos(a),
        r * sin(a), 
        0
    ]) { children(); }
}

module pcb_screw_holes(extended=false) {
    if (extended) {
        for (i=pcb_screw_positions) {
            translate([i[0], i[1], 0]) {
                hull() {
                    cylinder(r=3.25, h=50, center=true);
                    mv(3, i[2]) cylinder(r=5, h=50, center=true);
                }
            }
        }
    } else {
        for (i=pcb_screw_positions) {
            screw_hole(position=[i[0], i[1], 0], r=pcb_screw_insert_r);
        }
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
    [0.225, 4.07929134, 1.5],
    [0.5, 4, 2],  // dummy
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
    //[2.3, 4.07929134, 1.55],
    [2.275, 4.07929134, 1.5],
    [2, 4, 2],  // dummy
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

module switch_hole(position, u=1, depth, angle=0) {
    translate([position[0], position[1]]) {
        rotate([0, 0, angle]) {
            plate([
                switch_hole_size+switch_distance*(u-1), 
                switch_hole_size, 
                depth
            ], 1.5, center=true);
        }
    }
}

//module switch_hole(position, notches=use_notched_holes) {
//    notch_width  = 3.5001;
//    notch_offset = 4.2545;
//    notch_depth  = 0.8128;
//    
//    translate(position) {
//        union() {
//            square([switch_hole_size, switch_hole_size], center=true);
//            if (notches == true) {
//                translate([0, notch_offset]) {
//                    square([switch_hole_size+2*notch_depth, notch_width], center=true);
//                }
//                translate([0, -notch_offset]) {
//                    square([switch_hole_size+2*notch_depth, notch_width], center=true);
//                }
//            }
//        }
//    }
//};

module switch_holes(depth) {
    for (i=switch_positions_1) {
        switch_hole([
            24.260 + i[0]*switch_distance, 
            113.88 - i[1]*switch_distance
        ], i[2], depth*4);
    }
    for (i=switch_positions_2) {
        switch_hole([
            105.47 + (i[0]*cos(12)-i[1]*cos(78))*switch_distance, 
            109.92 - (i[0]*sin(12)+i[1]*sin(78))*switch_distance
        ], i[2], depth*4, angle=-12);
    }
    for (i=switch_positions_3) {
        switch_hole([
            189.5289 + (i[0]*cos(12)+i[1]*cos(78))*switch_distance, 
            100.22 - (i[0]*sin(-12)+i[1]*sin(78))*switch_distance
        ], i[2], depth*4, angle=12);
    }
   for (i=switch_positions_4) {
        switch_hole([
            265.93 + i[0]*switch_distance, 
            113.88 - i[1]*switch_distance
        ], i[2], depth*4);
    }
}

module pro_micro_hole(depth=50) {
    switch_hole([
        (3*cos(12)+1*cos(78))*switch_distance + 105.47,
        109.92 - (3*sin(12)-1*sin(78))*switch_distance,
    ], 3, depth, angle=78);
}

module battery() {
    bs = 96;  // battery size
    pt = 1; // plate thickness
    

    cube([bs-5, 10.5, 10.5], center=true);
    cube([bs, 8, 10.5], center=true);
    translate([0, 0, 5.25]) rotate([0, 90, 0]) cylinder(d=10.5, h=bs-5, center=true);
    translate([0, 0, 5.25]) rotate([0, 90, 0]) cylinder(d=8, h=bs, center=true);
    
    // For plates
    translate([ (bs-pt)/2,  0, 5.25]) cube([pt, 10.5, 10.5], center=true);
    translate([-(bs-pt)/2,  0, 5.25]) cube([pt, 10.5, 10.5], center=true);
    
    translate([ (bs+6)/2, 5, 0]) cube([6, 20.5, 7.5], center=true);
    translate([-(bs+6)/2, 5, 0]) cube([6, 20.5, 7.5], center=true);
}

module power_switch() {
    cube([12, 8.6, 7.5], center=true);
    cube([17, 6, 7.5], center=true);
}

module border() {
    translate([width/2-35, 0, -5]) rotate([0, 0, -12]) {
        difference() {
            cube([250, 200, 100]);
            cube([23, 20, 200]);
        }
    }
}

module halve(left=true) {
    if (left) {
        difference() {
            children();
            border();
        }
    } else {
        intersection() {
            children();
            border();
        }
    }
}

module left() {
    halve(true) children();
}

module right() {
    halve(false) children();
}

// 2D or 3D draw for top plate
module switch_plate(depth=switch_plate_height) {
    difference() {
        plate([width, height, depth], 2); 
        switch_holes(depth);
        if (depth==0) {
            case_screw_holes(depth);
        } else if (depth==0.2) {
        } else {
            case_screw_holes();
            pcb_screw_holes();
        }
    }
}

// 3D draw for FDM mid plate
module mid_plate() {
    difference() {
        plate([width, height, mid_plate_height], 2); 
        pcb_hole();
        case_screw_holes();
        pcb_screw_holes(extended=true);
        pro_micro_hole();
    }
}

feet_screw_positions = [
    [width/2+case_hole_distance*0.5, height-30],
    [width/2-case_hole_distance*0.5, height-30],
    [width/2+case_hole_distance*0.5+90, height-30],
    [width/2-case_hole_distance*0.5-90, height-30],
];

// 2D draw for acrylic bottom plate
module bottom_plate() {
    difference() {
        plate([width, height, 0], 2); 
        pro_micro_hole(depth=0);
        for (i=case_screw_positions) {
            translate([i[0], i[1]]) circle(r=m3_r);
        }
        for (i=feet_screw_positions) {
            translate([i[0], i[1]]) circle(r=m3_r);
        }
    }
}

module case() {
    mid_plate();
    translate([0,0,mid_plate_height]) switch_plate();
    translate([0,0,switch_plate_height+mid_plate_height-0.1]) switch_plate(depth=0.2);
}

module case_with_battery() {
    difference() {
        case();
        translate([width/2-113, 10, 0]) battery();
        translate([8, 15, 0]) power_switch();
    }
}

case_with_battery();
//left() case_with_battery();
//right() case_with_battery();

//switch_plate();
//bottom_plate();

//switch_holes(20);