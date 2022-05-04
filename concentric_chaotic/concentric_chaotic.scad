include <../lib/color_names.scad>

tol = 0.1;
fn = 300;
alpha = 0.9;

module ring(diameter, height, thickness, rotation_axis, hole_diameter, concentric_offset){
     peg_height = concentric_offset + thickness / 2;
     peg_diameter = 0.9 * hole_diameter;
     
     angle = rotation_axis=="x" ? 0 : 90;
     rotate([0, 0, angle])

          union(){
          difference()
          {
               // the main ring
               difference(){
                    cylinder(h=height, d=diameter+thickness, center=true, $fn=fn);
                    cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fn);
               }
               // holes
               rotate([90, 0, 0])
                    cylinder(h=diameter+thickness+tol, d=hole_diameter, center=true, $fn=fn);
          }

          // pegs
          translate([(diameter + peg_height) / 2, 0, 0])
          rotate([0, 90, 0])
               cylinder(h=peg_height, d=peg_diameter, center=true, $fn=fn);
          translate([-(diameter + peg_height) / 2, 0, 0])
          rotate([0, 90, 0])
               cylinder(h=peg_height, d=peg_diameter, center=true, $fn=fn);

     }


}

// TODO: remember that for two consecutive rings to be able to rotate,
// the concentric_offset must be computed taking into account all the
// thickness, diameter and height.
thickness = 3;
height = 10;
hole_diameter = 5;
concentric_offset = thickness + 5;
max_diameter = 300;

for (i = [0: 8]) {
     rotation_axis = i%2==0 ? "x" : "y";
     diameter = max_diameter - i * 2 * concentric_offset; // x2 because offset corresponds to radius

     color(color_names[1+5*i], alpha)
          ring(
               diameter=diameter,
               height=height,
               thickness=thickness,
               rotation_axis=rotation_axis,
               hole_diameter=hole_diameter,
               concentric_offset=concentric_offset);     
}
