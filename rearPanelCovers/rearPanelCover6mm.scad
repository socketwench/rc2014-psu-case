include <rearPanelCoverBlank.scad>;
include <../keystone/keystone.scad>

module rearPanelCover6mm(holes=4, basePlate=[42,22,3], tab=[4,7,2.5]) {
    BasePlateX = basePlate[0];
    BasePlateY = basePlate[1];
    BasePlateZ = basePlate[2];
    difference() {
        rearPanelCoverBlank(basePlate,tab);
        
        Spaces = holes+1;
        HoleTotalX = (BasePlateX);
        HoleDeltaX = (HoleTotalX/Spaces);
        HoleStartX = HoleTotalX*-0.5;
        
        for (i = [1:1:holes]) {
            translate([HoleStartX+(HoleDeltaX*i),0,BasePlateZ/2])
                cylinder(BasePlateZ, d=7, center=true, $fn=25);
        }
    }
}
