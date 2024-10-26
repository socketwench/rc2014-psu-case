include <../parallelograms/parallelograms.scad>
include <basePanels.scad>

/* [Parallelogram Shape] */
Rise = 9;
Run = 2;
ShapeW = 10.2;
ShapeH = 9.6;
riseOverRun = Rise/Run;

/* [Panel] */
PanelW = 183;
PanelH = 60;
SpaceX = 2;
SpaceY = 2;
Border = 2;
PanelZ = 15;

/* [Threaded inserts & hardware] */
Threaded_insert_width=4.8;
Threaded_insert_height=5;
boltThreadD=3.8;
boltHeadD=Threaded_insert_width+2;

/* [Preview] */
Select = 0; // [0:parallelogramFrustum, 1:panelBase, 2:panel]

if (Select==0) {
    parallelogramFrustum(PanelW-Border*2, PanelH-Border*2, PanelZ-2, riseOverRun, -1*ShapeH*2);
} else if (Select==1) {
    panelBase(PanelW, PanelH, ShapeW, ShapeH, riseOverRun, SpaceX, SpaceY, Border, PanelZ);
} else if (Select==2) {
    panel(PanelW, PanelH, ShapeW, ShapeH, riseOverRun, SpaceX, SpaceY, Border, PanelZ);
} else if (Select==3) {
    
} else if (Select==4) {
    
}
