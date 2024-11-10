include <rearPanelCoverBlank.scad>;
include <rearPanelCoverKeystone.scad>;

Select = 0; // [0:rearPanelCoverBlank, 1:rearPanelCoverKeystone, 2:rearPanelCoverCutout]

Threaded_insert_width=4.8;
Threaded_insert_height=5;

if (Select==0) {
    rearPanelCoverBlank();
} else if (Select==1) {
    rearPanelCoverKeystone();
} else if (Select==2) {
    rearPanelCoverCutout();
}