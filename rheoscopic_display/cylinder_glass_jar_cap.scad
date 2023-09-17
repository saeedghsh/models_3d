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

tol = 0.01;
fragments = 300;

jar_thickness = 2.6;
jar_inner_diameter = 91.6;
jar_outer_diameter = 96;

thickness = 1;
height = 10;
hole_diameter = 10;

module plug(){

     peg_height = height/4;
     translate([0, 0, -peg_height/2 - 3*height/4 + peg_height/4 +tol]) 
     cylinder(h=peg_height, r1=hole_diameter/2, r2=0.8*hole_diameter/2, center=true, $fn=fragments);

     translate([0, 0, -height/16 -7*height/8 - 2*tol])
     cylinder(h=height/8, d=2*hole_diameter, center=true, $fn=fragments);
}

// cap
difference(){
     translate([0, 0, -height/2])
     cylinder(h=height, d=jar_outer_diameter +2*thickness, center=true, $fn=fragments);

     // remove the inner part
     translate([0, 0, -height/4 + tol])
     cylinder(h=height/2, d=jar_inner_diameter -2*thickness, center=true, $fn=fragments);

     // remove the gap for jar fitting
     translate([0, 0, -3*height/8 + tol])
     difference(){
          cylinder(h=3*height/4, d=jar_outer_diameter, center=true, $fn=fragments);
          cylinder(h=3*height/4+tol, d=jar_inner_diameter, center=true, $fn=fragments);
     }
     
     // remove the ramped part
     translate([0, 0, -height/8 -height/2 + 2*tol])
     cylinder(h=height/4, r1=0, r2=jar_inner_diameter/2 -thickness, center=true, $fn=fragments);

     plug();
}

translate([0, 0, +height])
plug();