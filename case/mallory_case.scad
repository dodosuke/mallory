/* set output quality */
$fn = 50;

// constants
width = 351.30;
height = 132.91;
case_hole_distance = 114.0996;
m3_r = 1.75;
pcb_screw_insert_r = 1.75;
switch_hole_size=14;
key_spacing = 20.1;
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

switch_offsets=[
    [24.260, 113.88, 0], // x, y, key angle
    [105.47, 109.92, -12],
    [189.5289, 100.22, 12],
    [265.93, 113.88, 0]
];

switch_positions=[
    [
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
    ],
    [
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
    ],
    [
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
        [2.275, 4.07929134, 1.5],
        [2, 4, 2],  // dummy
    ],
    [
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
    ],
];

module switch_hole(depth) {
    notch_width  = 3.5001;
    notch_offset = 4.2545;
    notch_depth  = 0.8128;
    
    if (depth==0) {
        square([switch_hole_size, switch_hole_size], center=true);
        translate([0, notch_offset]) {
            square([switch_hole_size+2*notch_depth, notch_width], center=true);
        }
        translate([0, -notch_offset]) {
            square([switch_hole_size+2*notch_depth, notch_width], center=true);
        }
    } else {
        cube([switch_hole_size, switch_hole_size, depth*4], center=true);
        translate([0, notch_offset]) {
            cube([switch_hole_size+2*notch_depth, notch_width, depth*4], center=true);
        }
        translate([0, -notch_offset]) {
            cube([switch_hole_size+2*notch_depth, notch_width, depth*4], center=true);
        }
    }
}

module key_hole(position, u=1, depth, angle=0, switch) {
    translate([position[0], position[1]]) {
        rotate([0, 0, angle]) {
            if (switch) {
                switch_hole(depth);
            } else {
                plate([
                    key_spacing+switch_distance*(u-1), 
                    key_spacing, 
                    depth
                ], 1.5, center=true);
            }
        }
    }
}

module key_holes(depth, switch=false) {
    for (i=[0:3]) {
        for (j=switch_positions[i]) {
            a=switch_offsets[i][2];
            key_hole([
                switch_offsets[i][0] + (j[0]*cos(a)+j[1]*sin(a))*switch_distance, 
                switch_offsets[i][1] + (j[0]*sin(a)-j[1]*cos(a))*switch_distance
            ], j[2], depth=depth*4, angle=a, switch=switch);
        }
    }
}

module pro_micro_hole(depth=50) {
    key_hole([
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

module left() {
    difference() {
        children();
        border();
    }
}

module right() {
    intersection() {
        children();
        border();
    }
}

// 2D or 3D draw for top plate
module top_plate(depth=switch_plate_height) {
    difference() {
        plate([width, height, depth], 2); 
        key_holes(depth);
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

module switch_plate(depth=0) {
    difference() {
        plate([width, height, 0], 2); 
        key_holes(depth, switch=true);
    }
}

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
    translate([0,0,mid_plate_height]) top_plate();
    translate([0,0,switch_plate_height+mid_plate_height-0.1]) top_plate(depth=0.2);
}

module case_with_battery() {
    difference() {
        case();
        translate([width/2-113, 10, 0]) battery();
        translate([8, 15, 0]) power_switch();
    }
}

module foot() {
    rad = 12;
    dist = 90;
    
    difference() {
        rotate([0, 90, 0]) {
            translate([0, 0, dist/2]) sphere(r=rad);
            translate([0, 0, -dist/2]) sphere(r=rad);
            cylinder(r=rad, h=dist, center=true);   
        }
        translate([0, 0, 15]) cube([120, 30, 30], center=true);
        translate([dist/2, 0, 0]) cylinder(r=1.75, h=10, center=true);
        translate([-dist/2, 0, 0]) cylinder(r=1.75, h=10, center=true);
    }
}

module washer() {
    hex=5.8;
    difference() {
        cylinder(d=8, h=3.2);
        cylinder(d=3.5, h=10, center=true);
        translate([0,0,6.6]) {
            intersection() {
                cube([10, hex, 12], center=true);
                rotate([0, 0, 60]) cube([10, hex, 10], center=true);
                rotate([0, 0, 120]) cube([10, hex, 10], center=true);
            }
        }
    }
}

module cover() {
    difference() {
        union() {
            cube([24, 50, 2]); 
            translate([6, 0, 0]) cube([12, 46, 2.5]);
            intersection() {
                translate([2,0,0]) cube([20, 50, 15]);
                translate([0, 9, 0]) rotate([0, 0, -78]) cube([24, 50, 15]);
            }   
            translate([2, 0, 10]) cube([20, 16, 5]); 
        }
        rotate([0, 0, -78]) cube([24, 50, 20]);
        translate([2, 16, 1.5]) cube([4, 46, 1]);
        translate([18, 16, 1.5]) cube([4, 46, 1]);
        
    }

}

//case_with_battery();
//left() case_with_battery();
//right() case_with_battery();

//switch_plate();

//foot();
//washer();
//cover();

color([0, 0.5, 0.5]) translate([0, 0, 20]) difference() {
    plate([width, height, 3], 3); 
    key_holes(3);
    case_screw_holes();
}

case_with_battery();

color([0, 0.3, 0.7]) translate([0, 0, -7]) difference() {
    plate([width, height, 3], 3); 
    case_screw_holes();
}

