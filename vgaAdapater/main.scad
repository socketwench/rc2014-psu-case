include <vgaAdapter.scad>

/* [Threaded inserts & hardware] */
Threaded_insert_width=4.8;
Threaded_insert_height=5;
boltThreadD=3.8;
boltHeadD=Threaded_insert_width+2;

/* [Preview] */
Select = 0; // [0:vgaCutout, 1:vgaCover, 2:vgaBackBracket]

if (Select==0) {
    vgaCutout();
} else if (Select==1) {
    vgaCover();
} else if (Select==2) {
    vgaBackBracket();
}