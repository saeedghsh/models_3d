/*
Copyright (C) Saeed Gholami Shahbandi. All rights reserved.
Author: Saeed Gholami Shahbandi (saeed.gh.sh@gmail.com)

This file is part of Arrangement Library.
The of Arrangement Library is free software: you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>
*/

tol = 0.1;
cylinder_fragments = 300;
color_alpha = 0.9;

thickness = 3;
top = 25;
width = 20;

base = 100;
height = 90;
screw_diameter = 5;
leg_length = sqrt(height^2 + ((base-top)/2)^2);
leg_angle = 90 - acos(height / leg_length); // vertical leg has angle 90

difference(){
     union()
     {
          // leg in +x direction
          color("Blue", color_alpha)
               translate([top/2, 0, ])
               rotate([0, leg_angle, 0])
               translate([leg_length/2, 0, thickness/2])
               cube(size=[leg_length, width, thickness], center=true);
          
          // leg in -x direction
          color("Blue", color_alpha)
               rotate([0, 0, 180])
               translate([top/2, 0, ])
               rotate([0, leg_angle, 0])
               translate([leg_length/2, 0, thickness/2])
               cube(size=[leg_length, width, thickness], center=true);
          
          // top
          difference(){
               color("Red", color_alpha)
                    translate([0, 0, 0])
                    cube(size=[top+2*thickness, width, thickness], center=true);

               // screw hole
               color("Green", color_alpha)
                    cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
          }
     }
}
