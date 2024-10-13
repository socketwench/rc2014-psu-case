include <rearPanelCoverBlank.scad>;
include <../keystone/keystone.scad>

module rearPanelCoverKeystone(basePlate=[42,22,3], tab=[4,7,2.5]) {
    BasePlateY = basePlate[1];
    difference() {
        union() {
            rearPanelCoverBlank(basePlate,tab);
            translate([-2,0,0])
            linear_extrude(9.5)
                square([30,BasePlateY], center=true);
        }

        translate([24.6/2-2,-14.8/2,9.5])
            rotate([0,90,90])
                keystoneCutout();
    }
}
