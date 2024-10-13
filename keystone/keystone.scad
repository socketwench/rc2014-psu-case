module keystoneCutout() {
    linear_extrude(15.2) polygon([
        [0,2],
        [1.4,2],
        [1.4,0],    
        [7.6,0],
        [9.5,2],
        [9.5,18.8],
        [4.6,24.6],
        [1.4,24.6],
        [1.4,22.6],
        [0,22.6],
    ]);
}

module keystonePort(border=4.1) {
    translate([4,4,0]) difference() {
        linear_extrude(9.5)
            offset(delta=border, chamfer=true)
                square([15.2,24.6]);
        
        translate([15.2,0,0])
            rotate([0,-90,0])
                keystoneCutout();
    }
}
