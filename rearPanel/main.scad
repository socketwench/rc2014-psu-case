include <rearPanelBlank.scad>;
include <rearPanelKeystone.scad>;

Select = 0; // [0:rearPanelBlank, 1:rearPanelKeystone]

if (Select==0) {
    rearPanelBlank();
} else if (Select==1) {
    keyStonePlate();
}