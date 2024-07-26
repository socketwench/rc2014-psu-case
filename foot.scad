holeX = 30.5;
holeY = 25.4;
Threaded_insert_width=4.8;
Threaded_insert_height=5;

module threadedInsert() {
    cylinder(h=Threaded_insert_height, d=Threaded_insert_width, $fn=50);
}

module basePlate() {
    union() {
        difference() {
            cube([holeX+10, holeY+10, Threaded_insert_height]);
            translate([holeX+5,holeY+5,0]) cube([5,5,Threaded_insert_height]);
            translate([holeX, holeY, 0]) threadedInsert();
        }
        translate([holeX+5,holeY+5,0]) cylinder(h=5, r=5, $fn=50);
    }
}

module baseColumn() {
    points = [
        [0,0],
        [30,0],
        [20,10],
        [20,20],
        [30,30],
        [30,40],
        [0,40],
    ];
    rotate([90,0,0]) linear_extrude(20) polygon(points);
    
    /*
    difference() {
        union() {
            cube([20,20,40]);
            cube([holeX+10,20,10]);
            translate([0,0,40-15]) cube([holeX+10,20,15]);
        }
        translate([10,10,40-Threaded_insert_height]) cylinder(h=Threaded_insert_height, d=Threaded_insert_width, $fn=50);
    }
    */
}

module column () {
    difference() {
        union() {
            translate([0,20,0]) baseColumn();
            rotate([0,0,90]) baseColumn();
            
        }
        translate([20-Threaded_insert_height,7.5,15]) rotate([0,90,0]) threadedInsert();
        translate([7.5, 25-Threaded_insert_height,15]) rotate([90,0,0]) threadedInsert();
        translate([10,10,40-Threaded_insert_height]) threadedInsert();
    }
}

union() {
    basePlate();
    translate([0,0,Threaded_insert_height]) column();
}