tol = 0.1;
cylinder_fragments = 300;
color_alpha = 0.9;

thickness = 3;
base = 25;
width = 20;

height = 100;
screw_diameter = 5;
leg_angle = 60; // vertical leg has angle 90
leg_length = height / cos(90-leg_angle);

difference(){
     union()
     {
          // leg in +x direction
          color("Blue", color_alpha)
               translate([base/2, 0, ])
               rotate([0, leg_angle, 0])
               translate([leg_length/2, 0, thickness/2])
               cube(size=[leg_length, width, thickness], center=true);
          
          // leg in -x direction
          color("Blue", color_alpha)
               rotate([0, 0, 180])
               translate([base/2, 0, ])
               rotate([0, leg_angle, 0])
               translate([leg_length/2, 0, thickness/2])
               cube(size=[leg_length, width, thickness], center=true);
          
          // base
          difference(){
               color("Red", color_alpha)
                    translate([0, 0, 0])
                    cube(size=[base+2*thickness, width, thickness], center=true);

               // screw hole
               color("Green", color_alpha)
                    cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
          }
     }
}
