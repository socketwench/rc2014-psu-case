include <keystone.scad>

Select = 0; // [0:keystoneCutout, 1:keystonePort]

if (Select==0) {
    keystoneCutout();
} else if (Select==1) {
    keystonePort();
}