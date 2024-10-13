include <rearPanelCoverBlank.scad>;
include <rearPanelCoverKeystone.scad>;

Select = 0; // [0:rearPanelCoverBlank, 1:rearPanelCoverKeystone]

if (Select==0) {
    rearPanelCoverBlank();
} else if (Select==1) {
    rearPanelCoverKeystone();
}