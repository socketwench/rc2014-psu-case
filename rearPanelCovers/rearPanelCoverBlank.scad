module rearPanelCoverTab(tab=[4,7]) {
    tabID=tab[0];
    tabOD=tab[1];
    difference() {
        union() {
            difference() {
                circle(d=tabOD, $fn=24);
                translate([tabOD/4,0])
                    square([tabOD/2,tabOD], center=true);
            }
            translate([tabID/4,0])
                square([tabID/2,tabOD], center=true);
        }
        circle(d=tabID, $fn=24);
    }
}

module rearPanelCoverBlankOutline(basePlate=[42,22], tab=[4,7,2.5]) {
    
    BasePlateX=basePlate[0];
    BasePlateY=basePlate[1];
    tabID=tab[0];
    tabOD=tab[1];
    tabYInset=tab[2];
    
    union() {
        square([BasePlateX, BasePlateY], center=true);
        
        translate([BasePlateX/2*-1-tabID/2,BasePlateY/2*-1+tabOD/2+tabYInset])
            rearPanelCoverTab(tab);
        
        translate([BasePlateX/2+tabID/2,BasePlateY/2-tabOD/2-tabYInset])
            rotate([0,0,180])
                rearPanelCoverTab(tab);
    }
}

module rearPanelCoverBlank(basePlate=[42,22,3], tab=[4,7,2.5]) {
    
    BasePlateX=basePlate[0];
    BasePlateY=basePlate[1];
    BasePlateZ=basePlate[2];
    tabID=tab[0];
    tabOD=tab[1];
    tabYInset=tab[2];
    
    difference() {
        linear_extrude(BasePlateZ)
            rearPanelCoverBlankOutline(basePlate, tab);
        
        // Neat little one layer border to help with orientation.
        translate([0,0,BasePlateZ])
            difference() {
                cube([BasePlateX-1, BasePlateY-1,0.4], center=true);
                cube([BasePlateX-2, BasePlateY-2,0.4], center=true);
            }
    }
}
