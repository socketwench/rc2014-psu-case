Select = 0; // [0:Preview, 1:leftFrontFoot, 2:rightFrontFoot, 3:leftRearFoot, 4:rightRearFoot,5:frontPanel,6:rearPanel,7:leftPanel,8:rightPanel,9:vgaCover]

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

//////////////////////////////////////////////////////////////
// Utility Shapes
//////////////////////////////////////////////////////////////

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

module keystonePort() {
    translate([4,4,0]) difference() {
        linear_extrude(9.5)
            offset(delta=4.1, chamfer=true)
                square([15.2,24.6]);
        
        translate([15.2,0,0])
            rotate([0,-90,0])
                keystoneCutout();
    }
}

//////////////////////////////////////////////////////////////
// parallelograms
//////////////////////////////////////////////////////////////

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

module parallelogramPanel(panelW, panelH, shapeW, shapeH, riseOverRun, spaceX, spaceY) {
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
            parallelogramPanel(panelW-border, panelH-border, shapeW, shapeH, riseOverRun, spaceX, spaceY);
    }
}

//////////////////////////////////////////////////////////////
// IEC power inlet
//////////////////////////////////////////////////////////////

module iecInletCutoutShape() {
    polygon([
        [-28/2,-49/2],
        [28/2,-49/2],
        [28/2,49/2-4.8],
        [28/2-4.8,49/2],
        [-28/2+4.8,49/2],
        [-28/2,49/2-4.8]
    ]);
}

module iecInletCutout() {
    union() {
        /*
        linear_extrude(0.4)
            polygon([
                [-28/2,-59/2],
                [-49/2,0],
                [-28/2,59/2],
                [28/2,59/2],
                [49/2,0],
                [28/2,-59/2],
            ]);
        */
        translate([-40/2,0,0]) threadedInsert();
        translate([40/2,0,0]) threadedInsert();
        
        translate([0,1.6,0])
            linear_extrude(35)
                iecInletCutoutShape();
    }
}

module iecInletShield(h) {
    translate([0,1.6,0]) difference() {
        linear_extrude(h)
            offset(delta=2) 
                iecInletCutoutShape();
        
        linear_extrude(h) 
            iecInletCutoutShape();
    }
}

//////////////////////////////////////////////////////////////
// Rectangles
//////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////
// Base plates
//////////////////////////////////////////////////////////////

module leftBasePlate(columnWidthX, columnDepthX, columnWidthY, columnDepthY, columnHeight, riseOverRun) {
    
    difference() {
        linear_extrude(Threaded_insert_height) hull() {
            translate([holeX, holeY])
                circle(d=10+Threaded_insert_width, $fn=50);
            
            translate([65, 55])
                circle(d=10+Threaded_insert_width, $fn=50);
            
            polygon([
                [columnDepthY, columnWidthY*1.5],
                [columnWidthX*1.5+(columnHeight/riseOverRun), columnDepthY],
                [columnDepthY, columnWidthY]
            ]);
        }
        
        translate([holeX, holeY, 0]) 
            threadedInsert();
        
        translate([65, 55, 0]) 
            threadedInsert();
    }
}

module rightBasePlate(columnWidthX, columnDepthX, columnWidthY, columnDepthY,columnHeight, riseOverRun) {
    
    mirror([1,0,0]) difference() {
        linear_extrude(Threaded_insert_height) hull() {
            translate([holeX, holeY])
                circle(d=10+Threaded_insert_width, $fn=50);
            
            translate([65, 55])
                circle(d=10+Threaded_insert_width, $fn=50);
            
            polygon([
                [columnDepthX, columnDepthY],
                [columnDepthX, columnDepthY*1.5+(columnHeight/riseOverRun)],
                [columnDepthX*1.5, columnDepthY]
            ]);
        }
        
        translate([holeX, holeY, 0]) 
            threadedInsert();
        
        translate([65, 55, 0]) 
            threadedInsert();
    }
}

//////////////////////////////////////////////////////////////
// Panels
//////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////
// VGA
//////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////
// Feet
//////////////////////////////////////////////////////////////

module column(widthX, depthX, widthY, depthY, height, riseOverRun) {
    difference() {
        union() {
            translate([0,depthX,0])
                rotate([90,0,0])
                    linear_extrude(depthX)
                        parallelogram(widthX*1.5, height, riseOverRun);

            translate([0,depthY*1.5+(height/riseOverRun),0])
            rotate([90,0,90])
                linear_extrude(depthY)
                    mirror([1,0,0])
                        parallelogram(widthY*1.5, height, riseOverRun);


            cube([depthX,depthY,height]);
        }
    }
}

module leftFrontFoot() {
    difference() {
        union() {
            translate([0,0,60-Threaded_insert_height])
                leftBasePlate(15,15,15,15,60,riseOverRun);
            column(15,15,15,15,60,riseOverRun);
        }
        
        // Insert for the rubber foot.
        translate([15/2,15/2])
            threadedInsert();
        
        // Screw cutouts
        translate([0,15/2,0])
            columnScrewCutoutPair(15*1.5,60,riseOverRun,15-4);
        translate([15/2,0,60])
            rotate([180,0,90])
                    columnScrewCutoutPair(15*1.5,60,riseOverRun,15-4);
        
        // Cutout for the bezel.
        translate([15*2+(60/riseOverRun),9.4,60])
            rotate([-90,0,90])
                bezelCutout(15*2+(60/riseOverRun), 6);
        
        // Front decoration
        translate([-10.6,0.4,2])
            rotate([90,0,0])
                linear_extrude(0.4) 
                    parallelogramArray(15*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
        
        // Side decoration
        translate([0.4,35.4,2])
            rotate([90,0,-90])
                linear_extrude(0.4) 
                    parallelogramArray(15*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
    }
}

module rightFrontFoot() {    
    difference() {
        union() {
            translate([0,0,60-Threaded_insert_height])
                rightBasePlate(15,15,15,15,60,riseOverRun);
            
            rotate([0,0,90])
            column(15,15,15,15,60,riseOverRun);
        }

        rotate([0,0,90]) {
            // Insert for the rubber foot.
            translate([15/2,15/2])
                threadedInsert();
                
            // Screw cutouts
            translate([0,15/2,0])
                columnScrewCutoutPair(15*1.5,60,riseOverRun,15-4);
            translate([15/2,0,60])
                rotate([180,0,90])
                        columnScrewCutoutPair(15*1.5,60,riseOverRun,15-4);
        }
        
        // Bezel cutout
        translate([(60/riseOverRun),9.4,60])
            rotate([-90,0,90])
                bezelCutout(15*2+(60/riseOverRun), 6);
    
        // Front decoration
        translate([-35,0.4,2])
            rotate([90,0,0])
                linear_extrude(0.4) 
                    parallelogramArray(15*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
        
        // Side decoration
        translate([-0.4,-10.2,2])
            rotate([90,0,90])
                linear_extrude(0.4) 
                    parallelogramArray(15*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
    }
    
}

module leftRearFoot() {
    rotate([0,0,180])
        rightFrontFoot();
}

module rightRearFoot() {
    rotate([0,0,180]) difference() {
        union() {
            translate([0,0,60-Threaded_insert_height])
                leftBasePlate(40,15,15,15,60,riseOverRun);
            column(40,15,15,15,60,riseOverRun);
            
            translate([(15*1.5)+(28/2)+3,35,59/2+0.5])
            rotate([90,180,0])
                iecInletShield(35);
        }
        // Insert for the rubber foot.
        translate([15/2,15/2])
            threadedInsert();
                
        // Screw cutouts
        translate([0,15/2,0])
            columnScrewCutoutPair(40*1.5,60,riseOverRun,40*1.5-4);
        translate([15/2,0,60])
            rotate([180,0,90])
                columnScrewCutoutPair(15*1.5,60,riseOverRun,15-4);
        
        
        // Cutout for the bezel.
        translate([40*1.5+(60/riseOverRun),9.4,60])
            rotate([-90,0,90])
                bezelCutout(40*1.5+(60/riseOverRun), 6);

        // Front decoration
        translate([-10.6,0.4,2])
            rotate([90,0,0])
                linear_extrude(0.4) 
                    parallelogramArray(40*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
        
        // Side decoration
        translate([0.4,35.4,2])
            rotate([90,0,-90])
                linear_extrude(0.4) 
                    parallelogramArray(15*1.5, 60, 10.2, 9.6, riseOverRun, 2, 2);
    
        translate([(15*1.5)+(28/2)+3,0,59/2+0.5])
            rotate([90,180,180])
                iecInletCutout();
    }
    
}

module frustum(width, height, depth, riseOverRun, outset) {
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
        frustum(panelW-border*2, panelH-border*2, panelD-2, riseOverRun, -1*shapeH*2);
        
        panelThreadedInsertLeft(panelD, panelH, riseOverRun, panelD*0.75);

        translate([panelW,0,0])
            panelThreadedInsertRight(panelD, panelH, riseOverRun, panelD*0.75);
    }
} 

module frontPanel() {
    difference() {
        panel(183,60,10.2,9.6,riseOverRun,2,2,2,15);
        translate([184.2+60/riseOverRun,60,6])
            rotate([0,90,180])
                bezelCutout(184.2, 6);
    }
}

module rearPanel() {
    difference() {
        union() {
            difference() {
                panel(146.6,60,10.2,9.6,riseOverRun,2,2,2,15);
                translate([146.6+60/riseOverRun,60,6])
                    rotate([0,90,180])
                        bezelCutout(146.6, 6);
                
                translate([32+(25*3)+15,60/2,0])
                    rotate([0,0,90])
                        linear_extrude(9.6)
                            chamferRect(31.4+4,13+4+(Threaded_insert_width+.8*2)*2, 4.1);
                
            }

            for(i = [0:1:2]) {
                translate([32+(25*i),60/2-32.5/2,0])
                    keystonePort();
            }
            
            translate([32+(25*3)+15,60/2,4])
                rotate([0,0,90])
                    vgaBackBracket();
        }
        
        for(i = [0:1:2]) {
            translate([15.2+32+(25*i)+4.1,60/2-32.5/2+4.1,0])
                rotate([0,-90,0])
                    keystoneCutout();
        }
    }
}

module leftPanel() {
    panel(133,60,10,9.6,riseOverRun,2,2,2,15);
    
    translate([(10.4+4)*2-.4,60/2-25/2,0])
        linear_extrude(4.4)
            parallelogram(79+25/riseOverRun, 25, riseOverRun);
}

module rightPanel() {
    panel(133,60,10,9.6,riseOverRun,2,2,2,15);
}

module preview() {
    leftFrontFoot();
    translate([holeX*2+180,0,0]) rightFrontFoot();
    translate([0,holeY*2+110,0]) leftRearFoot();
    translate([holeX*2+180,holeY*2+110,0]) rightRearFoot();

    // Front panel
    translate([15*1.5+0.2,15,0])
        rotate([90,0,0])
            frontPanel();

    // Right panel
    translate([holeX*2+180-15,15*1.5-0.2,0])
        rotate([90,0,90])
            rightPanel();
               
    // Left panel 
    translate([15,110+(15*1.5)*2+13,0])
        rotate([90,0,-90])
            leftPanel();

    // Rear panel
    translate([183-0.2,191-15,0])
        rotate([90,0,180])
            rearPanel();
}

if (Select==0) {
    preview();
} else if (Select==1) {
    leftFrontFoot();
} else if (Select==2) {
    rightFrontFoot();
} else if (Select==3) {
    leftRearFoot();
} else if (Select==4) {
    rightRearFoot();
} else if (Select==5) {
    frontPanel();
} else if (Select==6) {
    rearPanel();
} else if (Select==7) {
    leftPanel();
} else if (Select==8) {
    rightPanel();
} else if (Select==9) {
    vgaCover();
}

//translate([0,0,60]) cube([243,190,110]);