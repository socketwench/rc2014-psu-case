module keystoneCutout() {
    linear_extrude(14.8) polygon([
        [0,2.4],
        [1.4,2],
        [1.4,0],    
        [7.6,0],
        [9.5,2],
        [9.5,18.4],
        [4.6,24.6],
        [1.4,24.6],
        [1.4,22.2],
        [0,22.2],
    ]);
}

module keystonePort(border=4.1) {
    translate([4,4,0]) difference() {
        linear_extrude(9.5)
            offset(delta=border, chamfer=true)
                square([14.8,24.6]);
        
        translate([14.8,0,0])
            rotate([0,-90,0])
                keystoneCutout();
    }
}
