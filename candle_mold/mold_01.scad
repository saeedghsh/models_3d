use <../lib/shapes.scad>
use <../lib/splitter.scad>

tol = 0.2;
thickness = 5;
height = 60;
radius = 20;
slices = 5; // number of intermediate points along the Z axis of the extrusion
num_faces = 20; // no effect when slice is specified!?
twist = 45;
convexity = 10;
s = 1; // will scale the top of the extrude wrt bottom (making cone or funnel shapes)

color_alpha = 0.9;

split_along_yz(max_size=2*height, offset=5)
rotate([0,0,90])
split_along_yz(max_size=2*height, offset=5)
difference(){
     // mold body
     color("Blue", color_alpha)
          translate([0, 0, -thickness])
          cube([2*(radius+thickness), 2*(radius+thickness), height+thickness-tol], center=true);
     
     // candle shape
     color("Red", color_alpha)
     linear_extrude(
          height=height,
          center=true,
          convexity=convexity,
          twist=twist,
          slices=slices,
          scale=s,
          $fn=num_faces
          )
          regularPolygon(order=8, radius=radius);
}
