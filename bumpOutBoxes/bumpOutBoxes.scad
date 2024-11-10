include <../util/util.scad>
include <../rearPanelCovers/rearPanelCoverBlank.scad>
include <../rectangles/rectangles.scad>

RearPanelHoleX = 78.5;
RearPanelHoleY = 46.5;
Threaded_insert_width=4.8;
Threaded_insert_height=5;
boltThreadD=3.8;

module bumpOutBox_Flange() {
    difference() {
        union() {
            linear_extrude(2)
                centeredRoundedRect(RearPanelHoleX+6, RearPanelHoleY+6,2);
            linear_extrude(12)
                centeredRoundedRect(RearPanelHoleX, RearPanelHoleY,2);
        }
        
        translate([0,0,6])
            cube([RearPanelHoleX-10, RearPanelHoleY-10,12], center=true);

        translate([(RearPanelHoleX/2)*-1+8,RearPanelHoleY/2,8])
            rotate([90,0,0])
                threadedInsert();

        translate([(RearPanelHoleX/2)-8,RearPanelHoleY/2,8])
            rotate([90,0,0])
                threadedInsert();

        translate([(RearPanelHoleX/2)*-1+8,RearPanelHoleY/2*-1,8])
            rotate([-90,0,0])
                threadedInsert();

        translate([(RearPanelHoleX/2)-8,RearPanelHoleY/2*-1,8])
            rotate([-90,0,0])
                threadedInsert();
    }
}

module bumpOutBox_Box() {
    difference() {
        linear_extrude(30)
            centeredRoundedRect(RearPanelHoleX+6.8, RearPanelHoleY+6.8, 2);

        translate([0,0,25/2])
            cube([RearPanelHoleX+0.8, RearPanelHoleY+0.8,25], center=true);
    
        translate([(RearPanelHoleX/2)*-1+8,(RearPanelHoleY+6.8)/2,4])
            rotate([90,0,0])
                bumpOutBox_Box_boltCutout();

        translate([(RearPanelHoleX/2)-8,(RearPanelHoleY+6.8)/2,4])
            rotate([90,0,0])
                bumpOutBox_Box_boltCutout();

        translate([(RearPanelHoleX/2)*-1+11,0,30])
            rotate([180,0,90])
                rearPanelCoverCutout();

        translate([0,0,30])
            rotate([180,0,90])
                rearPanelCoverCutout();

        translate([(RearPanelHoleX/2)-11,0,30])
            rotate([180,0,90])
                rearPanelCoverCutout();
    }
}

module bumpOutBox_Box_boltCutout() {
    union() {
        cylinder(d=boltThreadD, h=RearPanelHoleY+6.8, $fn=25);

        translate([0,0,RearPanelHoleY+6.8-1.6])
            cylinder(h=1.6, d1=boltThreadD, d2=boltThreadD*2, $fn=50);

        cylinder(h=1.6, d1=boltThreadD*2, d2=boltThreadD, $fn=50);
    }
}