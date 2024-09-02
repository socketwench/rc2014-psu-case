bezelDepth=15;
holeX = 31.5;
holeY = 25.4+bezelDepth;
Threaded_insert_width=4.8;
Threaded_insert_height=5;
boltThreadD=3.8;
boltHeadD=Threaded_insert_width+2;

rise = 9;
run = 2;
riseOverRun = rise/run;

module threadedInsert() {
    cylinder(h=Threaded_insert_height, d=Threaded_insert_width, $fn=50);
}

module vgaCutout() {
    hull() {
        square([17.4,9.4], center=true);

        translate([24/2,0,0])       
            circle(d=6.6, $fn=50);

        translate([-24/2,0,0]) 
            circle(d=6.6, $fn=50);
    }
}

module vgaCutoutWithBackMount(adapterW=31.4, adapterH=13) {
    union() {
        vgaCutout();
        
        translate([(adapterW/2)-(Threaded_insert_width/2),(adapterH/2)+(Threaded_insert_width/2)+1.8])
            circle(d=boltThreadD, $fn=50);

        translate([((adapterW/2)-(Threaded_insert_width/2))*-1,(adapterH/2)+(Threaded_insert_width/2)+1.8])
            circle(d=boltThreadD, $fn=50);

        translate([(adapterW/2)-(Threaded_insert_width/2),((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1])
            circle(d=boltThreadD, $fn=50);
        
        translate([((adapterW/2)-(Threaded_insert_width/2))*-1,((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1])
            circle(d=boltThreadD, $fn=50);
    }
}

module vgaBackBracket(adapterW=32, adapterH=13.4, adapterD=6.6) {
    let(sideW = 0.2) {
        difference() {
            translate([0,0,-(adapterD+1.4)/2])
                linear_extrude(adapterD+1.4)
                    chamferRect(adapterW+4,adapterH+4+sideW*2, 4.1);
            
            translate([0,0,0.8])
                cube([adapterW,adapterH,adapterD], center=true);
            
            translate([0,0,-(adapterD+2)/2])
                linear_extrude(adapterD+2)
                    vgaCutout();
/*
            translate([(adapterW/2)-(Threaded_insert_width/2),(adapterH/2)+(Threaded_insert_width/2)+1.8,-1])
                threadedInsert();

            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,(adapterH/2)+(Threaded_insert_width/2)+1.8,-1])
                threadedInsert();

            translate([(adapterW/2)-(Threaded_insert_width/2),((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1,-1])
                threadedInsert();
            
            translate([((adapterW/2)-(Threaded_insert_width/2))*-1,((adapterH/2)+(Threaded_insert_width/2)+1.8)*-1,-1])
                threadedInsert();
                */
        }
    }    
}

module roundedRect(rectW, rectH, rectR) {
    hull() {
        translate([rectR, rectR])
            circle(r=rectR, $fn=50);

        translate([rectW-rectR, rectR])
            circle(r=rectR, $fn=50);

        translate([rectR, rectH-rectR])
            circle(r=rectR, $fn=50);

        translate([rectW-rectR, rectH-rectR])
            circle(r=rectR, $fn=50);
    }
}

module chamferRect(rectW, rectH, rectC) {
    offset(delta=rectC, chamfer=true)
        square([rectW-rectC*2, rectH-rectC*2], center=true);
}

vgaBackBracket();