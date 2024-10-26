include <parallelograms.scad>

/* [Parallelogram Shape] */
Rise = 9;
Run = 2;
ShapeW = 10.2;
ShapeH = 9.6;
riseOverRun = Rise/Run;

/* [Parallelogram Array & Grid] */
PanelW = 183;
PanelH = 60;
SpaceX = 2;
SpaceY = 2;

/* [Panel Frame] */
Border = 2;

/* [Preview] */
Select = 0; // [0:parallelogram, 1:parallelogram array, 2:parallelogram grid, 3:parallelogram frame, 4:grid with frame]

if (Select==0) {
    parallelogram(ShapeW, ShapeH, riseOverRun);
} else if (Select==1) {
    parallelogramArray(PanelW, PanelH, ShapeW, ShapeH, riseOverRun, SpaceX, SpaceY);
} else if (Select==2) {
    parallelogramGrid(PanelW, PanelH, ShapeW, ShapeH, riseOverRun, SpaceX, SpaceY);
} else if (Select==3) {
    parallelogramFrame(PanelW, PanelH, riseOverRun, Border);
} else if (Select==4) {
    parallelogramPanelWithFrame(PanelW, PanelH, ShapeW, ShapeH, riseOverRun, SpaceX, SpaceY, Border);
}
