
module rectFrame(panelW, panelH, border) {
    difference() {
        square([panelW, panelH]);
        offset(delta=border*-1)
            square([panelW, panelH]);
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