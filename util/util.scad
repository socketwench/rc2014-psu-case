module threadedInsert() {
    cylinder(h=Threaded_insert_height, d=Threaded_insert_width, $fn=50);
}

module bezelCutout(length, width) {    
    linear_extrude(length)
        polygon([
            [0,0],
            [width+.4,0],
            [width,1],
            [0.4,1]
        ]);
}

module columnScrewCutout(totalLength, shankLength) {
    union() {
        cylinder(h=shankLength, d=boltHeadD, $fn=50);
        cylinder(h=totalLength, d=boltThreadD, $fn=50);
        
        // The fudge number here is required, otherwise the
        // shank face gets rendered and the relief is hidden.
        translate([0,0,shankLength-0.01])
            intersection() {
                cylinder(h=shankLength, d=boltHeadD, $fn=50);
                
                cube([boltHeadD,boltThreadD,0.4], center=true);
            }
    }
}

module columnScrewCutoutPair(columnDepth, columnHeight, riseOverRun, shankDepth) {
    
    translate([0,0,(columnHeight/3)*2])
        rotate([0,90,0])
            columnScrewCutout(columnDepth+(columnHeight/riseOverRun),shankDepth+(((columnHeight/3)*2)/riseOverRun));

    translate([0,0,columnHeight/3])
        rotate([0,90,0])
            columnScrewCutout(columnDepth+(columnHeight/riseOverRun),shankDepth+((columnHeight/3)/riseOverRun));
}