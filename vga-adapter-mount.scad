Select = 0; // [0:Preview, 1:Bottom, 2:Top]

module m3BoltHole(height=6) {
    // Threads
    cylinder(h=height, d = 3.4, $fn = 50);
    
    // Print relief
    translate([0,0,2.5]) {
        intersection() {
            cylinder(h = 0.2, d = 6.2, $fn = 50);
            cube([6.2,3.4,0.2], center=true);
        }
    }
    
    // Socket head
    cylinder(h = 2.5, d = 6.2, $fn = 50);
}

module m3ThreadedInsert() {
    union () {
        cylinder(h=5, d=4.8, $fn=50);

        translate([0,0,5-0.01])
            intersection() {
                cylinder(h=5, d=4.8, $fn=50);
                
                cube([5,4.8/2,0.4], center=true);
            }
    }
}

module baseOutline() {
    points = [
       [20,0],
       [0,25],
       [0,40],
       [70,40],
       [70,25],
       [50,0],
    ];
    
    polygon(points);
}

module baseShape() {
    difference() {
        union() {
            linear_extrude(5) baseOutline();
            translate([20,3,0]) cylinder(h = 5, d=6, $fn=50);
            translate([50,3,0]) cylinder(h = 5, d=6, $fn=50);
        }
        union() {
            translate([22,4,5]) rotate([180,0,0]) m3BoltHole();
            translate([48,4,5]) rotate([180,0,0]) m3BoltHole();
        }
    }
}

module basePost() {
    difference() {
        cube([7.5,10,10]);
        translate([7.5/2,5,0]) cylinder(h = 11, d = 4.8, $fn = 50);
    }
}

module part_bottom() {
    interior_width = 55;
    interior_depth = 62;
    post_width = 7.5;
    post_depth = 10;
    post_height = 10;
    width = interior_width + (post_width * 2);
    depth = interior_depth;
    cutout_width = 15;
    cutout_depth = 10;
    top_height = 6;
    
    insert_offset = ((depth+(4*2))-55)/2;
    
    difference() {
        hull() {
            translate([0,4,0]) cube([width,depth,top_height]);
            translate([20,0,0]) cube([30,2,top_height]);
            translate([20,depth+6,0]) cube([30,2,top_height]);
        }
        
        translate([insert_offset,depth/2+4,0]) m3ThreadedInsert();

        translate([55+insert_offset,depth/2+4,0]) m3ThreadedInsert();
        
        translate([cutout_width, cutout_depth+4, 0])
            cube([width-cutout_width*2, depth-cutout_depth*2, 6]);

    }
    
    translate([20,0,6]) cube([30,2,2]);
    translate([20,depth+6,6]) cube([30,2,2]);
    
    translate([0,4,top_height]) basePost();
            translate([width-post_width,4,top_height]) basePost();
            translate([width-post_width,4+depth-post_depth,top_height]) basePost();
            translate([0,4+depth-post_depth,top_height]) basePost();
}

module topPost() {
    difference() {
        cube([7.5,10,10]);
        translate([7.5/2,5,0]) cylinder(h = 11, d = 3.2, $fn = 50);
    }
}

module part_top() {
    interior_width = 55;
    interior_depth = 62;
    post_width = 7.5;
    post_depth = 10;
    post_height = 10;
    width = interior_width + (post_width * 2);
    depth = interior_depth;
    cutout_width = 10;
    cutout_depth = 10;
    top_height = 5;
    
    difference() {
        union() {
            // Top with cutout.
            difference() {
                cube([width,depth,top_height]);
                translate([cutout_width,cutout_depth,0]) cube([width-cutout_width*2,depth-cutout_depth*2,top_height]);
            }
            
            // Posts. This could probably be a for loop.
            translate([0,0,top_height]) cube([post_width,post_depth,post_height]);
            translate([width-post_width,0,top_height]) cube([post_width,post_depth,post_height]);
            translate([width-post_width,depth-post_depth,top_height]) cube([post_width,post_depth,post_height]);
            translate([0,depth-post_depth,top_height]) cube([post_width,post_depth,post_height]);
        }
        
        translate([post_width/2,post_depth/2,0]) m3BoltHole(height=top_height+post_height);
        translate([width-post_width/2,post_depth/2,0]) m3BoltHole(height=top_height+post_height);
        translate([width-post_width/2,depth-post_depth/2,0]) m3BoltHole(height=top_height+post_height);
        translate([post_width/2,depth-post_depth/2,0]) m3BoltHole(height=top_height+post_height);
    }
}

if (Select==0) {
    part_bottom();
    translate([70,4,32]) rotate([0,180,0]) part_top();
} else if (Select==1) {
    part_bottom();
} else if (Select==2) {
    part_top();
}
