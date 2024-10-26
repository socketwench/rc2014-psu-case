module parallelogram(w, h, riseOverRun) {
    slant = h/riseOverRun;
    polygon([
        [0,0],
        [slant,h],
        [w+slant,h],
        [w,0],
    ]);
}

module parallelogramArray(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY) {
    offsetX = shapeW+spaceX;
    offsetY = shapeH+spaceY;
    for(y = [0:offsetY:panelH+offsetY]) {
        translate([y/riseOverRun,0,0]) {
            for(x = [0:offsetX:panelW+offsetX]) {
                translate([x, y, 0]) parallelogram(shapeW, shapeH, riseOverRun);
            }
        }
    }
}

module parallelogramGrid(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY) {
    difference() {
        parallelogram(panelW, panelH, riseOverRun);
        
        parallelogramArray(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY);
    }
}

module parallelogramFrame(panelW, panelH, riseOverRun, border) {
    difference() {
        parallelogram(panelW, panelH, riseOverRun);
        
        offset(delta=border*-1)
            parallelogram(panelW, panelH, riseOverRun);
    }
}

module parallelogramPanelWithFrame(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY, border) {
    
    union() {
        parallelogramFrame(panelW, panelH, riseOverRun, border);
        
        translate([border, border])
            parallelogramGrid(panelW-border, panelH-border, shapeW, shapeH, riseOverRun, spaceX, spaceY);
    }
}