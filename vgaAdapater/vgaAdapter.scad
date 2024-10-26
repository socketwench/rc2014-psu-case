include <../util/util.scad>
include <..//rectangles/rectangles.scad>

module vgaCutout() {
    hull() {
        square([17.4,9.4], center=true);

        translate([24/2,0,0])       
            circle(d=6.6, $fn=50);

        translate([-24/2,0,0]) 
            circle(d=6.6, $fn=50);
    }
}

module vgaCover(adapterW=31.4, adapterH=13) {
    let(sideW = Threaded_insert_width+.8*2, lidD = 9.6-8) {
        difference() {
            linear_extrude(lidD) difference() {
                chamferRect(adapterW+4,adapterH+4+sideW*2, 4.1);
                
                vgaCutout();
            }
                        
            translate([(adapterW/2)-(Threaded_insert_width/2),(adapterH/2)+(Threaded_insert_width/2)+1.8])
                cylinder(h=lidD, d1=boltThreadD, d2=boltThreadD*2, $fn=50);

            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,(adapterH/2)+(Threaded_insert_width/2)+1.8])
                cylinder(h=lidD, d1=boltThreadD, d2=boltThreadD*2, $fn=50);

            translate([(adapterW/2)-(Threaded_insert_width/2),((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1])
                cylinder(h=lidD, d1=boltThreadD, d2=boltThreadD*2, $fn=50);
            
            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1])
                cylinder(h=lidD, d1=boltThreadD, d2=boltThreadD*2, $fn=50);
        }
        
    }
}

module vgaBackBracket(adapterW=32, adapterH=13.4, adapterD=6.6) {
    let(sideW = Threaded_insert_width+.8*2) {
        difference() {
            translate([0,0,-(adapterD+1.4)/2])
                linear_extrude(adapterD+1.4)
                    chamferRect(adapterW+4,adapterH+4+sideW*2, 4.1);
            
            translate([0,0,0.8])
                cube([adapterW,adapterH,adapterD], center=true);
            
            translate([0,0,-(adapterD+2)/2])
                linear_extrude(adapterD+2)
                    vgaCutout();

            translate([(adapterW/2)-(Threaded_insert_width/2),(adapterH/2)+(Threaded_insert_width/2)+1.8,-1])
                threadedInsert();

            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,(adapterH/2)+(Threaded_insert_width/2)+1.8,-1])
                threadedInsert();

            translate([(adapterW/2)-(Threaded_insert_width/2),((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1,-1])
                threadedInsert();
            
            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1,-1])
                threadedInsert();
        }
    }    
}