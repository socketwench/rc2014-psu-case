include <../util/util.scad>

module panelThreadedInsertLeft(panelDepth, panelHeight, riseOverRun, bossDiameter) {
    
    translate([((panelHeight/3)*2)/riseOverRun,(panelHeight/3)*2,panelDepth/2])
        rotate([0,90,0])
            union() {
                translate([0,0,(bossDiameter/riseOverRun)/2])
                    threadedInsert();
                translate([0,0,-1*(bossDiameter/riseOverRun)/2])
                    cylinder(h=bossDiameter/riseOverRun, d=bossDiameter, $fn=50);
            }

    translate([(panelHeight/3)/riseOverRun,panelHeight/3,panelDepth/2])
        rotate([0,90,0])
            union() {
                translate([0,0,(bossDiameter/riseOverRun)/2])
                    threadedInsert();
                translate([0,0,-1*(bossDiameter/riseOverRun)/2])
                    cylinder(h=bossDiameter/riseOverRun, d=bossDiameter, $fn=50);
            }
}

module panelThreadedInsertRight(panelDepth, panelHeight, riseOverRun, bossDiameter) {
    translate([((panelHeight/3)*2)/riseOverRun,(panelHeight/3)*2,panelDepth/2])
        rotate([0,-90,0])
            union() {
                translate([0,0,(bossDiameter/riseOverRun)/2])
                    threadedInsert();
                translate([0,0,-1*(bossDiameter/riseOverRun)/2])
                    cylinder(h=bossDiameter/riseOverRun, d=bossDiameter, $fn=50);
            }
    
    translate([(panelHeight/3)/riseOverRun,panelHeight/3,panelDepth/2])
        rotate([0,-90,0])
            union() {
                translate([0,0,(bossDiameter/riseOverRun)/2])
                    threadedInsert();
                translate([0,0,-1*(bossDiameter/riseOverRun)/2])
                    cylinder(h=bossDiameter/riseOverRun, d=bossDiameter, $fn=50);
            }
}


module parallelogramFrustum(width, height, depth, riseOverRun, outset) {
    hull() {
        translate([0,0,depth])
            linear_extrude(0.01)
                parallelogram(width, height, riseOverRun);

        linear_extrude(0.01)
            offset(delta=outset)
        parallelogram(width, height, riseOverRun);
    }
}

module panelBase(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY, border, panelD) {
    union() {
        translate([border,0,0])
            linear_extrude(panelD)
                parallelogram(shapeW, panelH, riseOverRun);

        linear_extrude(panelD)
        parallelogramPanelWithFrame(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY, border);

        translate([panelW-border-shapeW,0,0])
            linear_extrude(panelD)
                parallelogram(shapeW, panelH, riseOverRun);
    }
}

module panel(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY, border, panelD) {
    
    difference() {
        panelBase(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY, border, panelD);
        
        // This is complicated because we have to match the slope on the X axis, not just the boarder.
        translate([border+border*2/(panelH/riseOverRun),border,2])
        parallelogramFrustum(panelW-border*2, panelH-border*2, panelD-2, riseOverRun, -1*shapeH*2);
        
        panelThreadedInsertLeft(panelD, panelH, riseOverRun, panelD*0.75);

        translate([panelW,0,0])
            panelThreadedInsertRight(panelD, panelH, riseOverRun, panelD*0.75);
    }
} 