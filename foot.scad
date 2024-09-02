holeX = 31.5;
holeY = 25.4;
Threaded_insert_width=4.8;
Threaded_insert_height=5;

module threadedInsert() {
    cylinder(h=Threaded_insert_height, d=Threaded_insert_width, $fn=50);
}

module parallelgram(w=10, h=9, slant=2) {
    polygon([
        [0,0],
        [slant,h],
        [w+slant,h],
        [w,0],
    ]);
}

module basePlate() {
    difference() {
        linear_extrude(Threaded_insert_height) union() {
            hull() {
                translate([holeX, holeY])
                    circle(d=10+Threaded_insert_width);
                    
                    polygon([
                        [30,0],
                        [15, 15],
                        [15,0]
                    ]);
                }
                translate([0,-15])
                    square([30,30]);
        }
        translate([holeX, holeY, 0]) threadedInsert();
    }
}

module baseColumnShape() {
    points = [
        [0,0],
        [30,0],
        [30,41],
        [0,41],
    ];
    difference() {
        polygon(points);
        translate([21.4,5.8]) parallelgram(w=16, h=9*2+2*3+.2, slant=5.3);
    }
}

module baseColumnShape2() {
    points = [
        [0,0],
        [30,0],
        [30,41],
        [0,41],
    ];
    difference() {
        polygon(points);
        
        translate([21.2+21.1,5.8])
            mirror([1,0,0])
                parallelgram(w=16, h=9*2+2*3+.2, slant=5.3);
    }
}

module baseColumn() {
    rotate([90,0,0]) linear_extrude(15) baseColumnShape();
}

module baseColumn2() {
    rotate([90,0,0]) linear_extrude(15) baseColumnShape2();
}

module columnScrewCutoutForPanels() {
    union() {
        cylinder(h=18, d=Threaded_insert_width+2, $fn=50);
        cylinder(h=30, d=3.8, $fn=50);
        translate([0,0,18])
            intersection() {
                cylinder(h=0.4, d=Threaded_insert_width+2, $fn=50);
                cube([Threaded_insert_width+2,3.8,0.4], center=true);
            }
    }
}

module leftFrontColumn() {
    difference() {
        
        union() {
            translate([22.5,-15,0])
                rotate([0,0,180])
                    baseColumn2();
            
            translate([7.5,-15,0]) 
                rotate([0,0,90]) 
                    baseColumn();
        }
        
        translate([15,-15,17.5])
            rotate([90,0,180])        
                columnScrewCutoutForPanels();
        
        translate([15,-7.5,41-Threaded_insert_height]) 
            threadedInsert();
        
        translate([22.5,-7.5,17.5]) 
            rotate([180,90,0])        
                columnScrewCutoutForPanels();
    }
}

module rightFrontColumn() {
    difference() {
        union() {
            baseColumn();
            translate([0,-15,0]) 
                rotate([0,0,90]) 
                    baseColumn2();
        }
        
        translate([7.5,-15,17.5])
            rotate([90,0,180])        
                columnScrewCutoutForPanels();
        
        translate([7.5,-7.5,41-Threaded_insert_height]) 
            threadedInsert();
        
        translate([0,-7.5,17.5]) 
            rotate([0,90,0])        
                columnScrewCutoutForPanels();
    }
}

module bezelCutout(length=30) {
    linear_extrude(length)
        polygon([
            [0,0],
            [5.4,0],
            [5,1],
            [0.4,1]
        ]);
}

module leftFrontFoot() {
    difference() {
        union() {
            translate([22.5,0,0])
                mirror([1,0,0]) 
                    basePlate();

            translate([0,0,Threaded_insert_height]) 
                leftFrontColumn();
        }
        translate([-7.5,-5,0])
            rotate([90,0,90])
                bezelCutout(length=30);
    }
}

module rightFrontFoot() {
    difference() {
        union() {
            basePlate();
            translate([0,0,Threaded_insert_height]) 
                rightFrontColumn();
        }
        translate([0,-5,0])
            rotate([90,0,90])
                bezelCutout(length=30);
    }
}

module frame(width, length, height, thickness) {
    difference() {
        cube([width,length,height]);
        translate([thickness, thickness, 0]) cube([width-thickness*2,length-thickness*2,height]);
    }
}

module parallelgramArray(width=140,length=46) {
    for(y = [0:11:length+11]) {
        translate([y/5,0,0]) {
            for(x = [0:12:width+12]) {
                translate([x, y, 0]) parallelgram();
            }
        }
    }
}

module parallelgramPanel(width=140,length=46,height=1,thickness=2) {
    union() {
        difference() {
            cube([width,length,height]);
            translate([length/12*-(11/5),2,0]) 
                linear_extrude(height) 
                    parallelgramArray(width,length);
            translate([0,height/2+thickness,height])
                rotate([0,90,0])
                    hull() {
                        cylinder(d=height, h=width);
                        translate([0,length-height-thickness*2,0])
                            cylinder(d=height, h=width);
                    }
        }
        frame(width, length, height, thickness);
    }
}

module leftPanel(width=140,length=46,height=15,thickness=3) {
    difference() {
        union() {
            translate([8.6,0,0]) 
                parallelgramPanel(width=width-11,length=46,height=15,thickness=3);

            translate([0,11,0])
                linear_extrude(15) 
                    parallelgram(w=12, h=9*2+1.9*3, slant=5.3);
        }
        translate([0,0,5])
            rotate([0,90,0])
                bezelCutout(width);
    }
}

module centerPanel(width=140,length=46,height=15,thickness=3) {    
    difference() {
        union() {
            translate([8.6,0,0]) 
                parallelgramPanel(width=width-5.3-12,length=46,height=15,thickness=3);

            translate([0,11,0])
                linear_extrude(15) 
                    parallelgram(w=12, h=9*2+1.9*3, slant=5.3);

            translate([width-5.3-12,11,0])
                linear_extrude(15) 
                    parallelgram(w=12, h=9*2+1.9*3, slant=5.3);
        }
        translate([0,0,5])
            rotate([0,90,0])
                bezelCutout(width);        
    }
}

translate([161,0,0]) leftFrontFoot();
rightFrontFoot();

translate([21.8,0,0])
    rotate([90,0,0])
        centerPanel();


//foot();
//translate([15,22.5,0]) rotate([0,-90,0]) linear_extrude(15) 
//panelShapeRight(55);
//translate([0,100,0]) mirror([0,1,0]) foot();