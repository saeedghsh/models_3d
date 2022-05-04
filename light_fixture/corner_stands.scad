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
tol = 0.02;

/*
      __
     /  |
B   /   |
   /   /
  |   /
C |__/
   C   A
*/

/// 863:  long edge of the inside of the wooden frame
/// 120: short edge of the inside of the wooden frame
/// 667: long edge of the plexiglass
/// 55: short edge of the plexiglass
/// height is the space between two plexiglass

height = 15;
A = (120 - 55) / 2;
B = (863 - 667) / 2;

thickness = 10; // desired_thickness of the profile
C = sqrt(thickness * thickness / 2);
screw_diameter=2;
nut_diameter=5;
points = [
     [0, 0], // 1
     [C, 0], // 2
     [A+C, B], // 3
     [A+C, B+C], // 4
     [A, B+C], // 5
     [0, C], // 6
     ];

{
     difference(){
          // extrude the cross-section of the profile
          color("Green", 1.0)
          linear_extrude(height = height)
          polygon(points);

          // remove screw that goes through plexiglass
          color("Red", 1.0)
          translate([A+C/2, B+C/2, height/2 + tol])
          cylinder(h=height+3*tol, d=screw_diameter, $fn= 30, center=true);

          // remove screw that attaches to wooden part (screw body)
          color("Red", 1.0)
          translate([3.5, C/2, height/2])
          rotate([0, 90, 0])
          cylinder(h=7+tol, d=screw_diameter, $fn= 30, center=true);

          // remove screw that attaches to wooden part (nut cap holder)
          color("Blue", 1.0)
          translate([7, C/2, height/2])
          rotate([0, 90, 0])
          cylinder(h=7+tol, d=nut_diameter, $fn=6, center=true);

     }
}

