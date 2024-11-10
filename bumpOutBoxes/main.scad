include <bumpOutBoxes.scad>;
include <../rearPanelCovers/rearPanelCoverKeystone.scad>;

Select = 0; // [0:preview, 1:box, 2:flange]

Threaded_insert_width=4.8;
Threaded_insert_height=5;

if (Select==0) {
    bumpOutBox_Flange();

    translate([0,0,4])
        bumpOutBox_Box();

    translate([(RearPanelHoleX/2)*-1+11,0,40])
        rotate([180,0,90])
            rearPanelCoverBlank();

    translate([0,0,40])
        rotate([180,0,90])
            rearPanelCoverKeystone();

    translate([(RearPanelHoleX/2)-11,0,40])
        rotate([180,0,90])
            rearPanelCoverBlank();
    
} else if (Select==1) {
    bumpOutBox_Box();
} else if (Select==2) {
    bumpOutBox_Flange();
}