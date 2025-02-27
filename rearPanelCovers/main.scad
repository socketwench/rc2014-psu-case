include <rearPanelCoverBlank.scad>;
include <rearPanelCoverKeystone.scad>;
include <rearPanelCover6mm.scad>;


/* [6mm Switch panel] */
Switch_Panel_Hole_Count = 4;

/* [Preview] */
Select = 0; // [0:rearPanelCoverBlank, 1:rearPanelCoverKeystone, 2:rearPanelCoverCutout, 3:rearPanelCover6mm]

Threaded_insert_width=4.8;
Threaded_insert_height=5;

if (Select==0) {
    rearPanelCoverBlank();
} else if (Select==1) {
    rearPanelCoverKeystone();
} else if (Select==2) {
    rearPanelCoverCutout();
} else if (Select==3) {
    rearPanelCover6mm(Switch_Panel_Hole_Count);
}