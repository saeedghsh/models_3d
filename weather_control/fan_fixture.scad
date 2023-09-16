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

tol = 0.05;
cylinder_fragments = 300;
color_alpha = 0.9;
thickness = 2;
screw_diameter = 4;
screw_to_screw = 35;
intake_gap_diameter = 28;
opening_gap_height = 30;
dimension = 40;
width = 20 + thickness; // because the plate on the inside will cover part of it

union(){

     /* // top plate */
     /* color("Cyan", color_alpha) */
     /*      translate([-dimension/2, (width+thickness)/2, (dimension+thickness)/2]) */
     /*      cube([dimension, width+thickness, thickness], center=true); */
     
     /* // bottom plate */
     /* color("Cyan", color_alpha) */
     /*      translate([-dimension/2, (width+thickness)/2, -(dimension+thickness)/2]) */
     /*      cube([dimension, width+thickness, thickness], center=true); */

     // inside plate
     color("Magenta", color_alpha)
          translate([-dimension/2, +thickness/2, 0])
          difference(){     
          cube([dimension, thickness, dimension+2*thickness], center=true);
     
          // take out screw holes
          translate([screw_to_screw/2, 0, -screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);

          // take out screw holes
          translate([-screw_to_screw/2, 0, -screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);

          // take out screw holes
          translate([-screw_to_screw/2, 0, screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
     }

     // outside plate
     color("Magenta", color_alpha)
          translate([-dimension/2, +thickness/2 + width, 0])
          difference(){
          cube([dimension, thickness, dimension+2*thickness], center=true);

          // take out intake hole
          rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=intake_gap_diameter, center=true, $fn=cylinder_fragments);

          // take out screw holes
          translate([screw_to_screw/2, 0, -screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);

          // take out screw holes
          translate([-screw_to_screw/2, 0, -screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);

          // take out screw holes
          translate([-screw_to_screw/2, 0, screw_to_screw/2])
               rotate([90,0,0])
               cylinder(h=thickness+2*tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
     }
     
     union(){
          // cylinder part
          difference(){
               union(){
                    // cylinder
                    difference()
                    {
                         color("Green", color_alpha)
                              cylinder(h=dimension, d=(width+thickness)*2, center=true, $fn=cylinder_fragments);
                         color("Green", color_alpha)
                              cylinder(h=dimension+tol, d=width*2, center=true, $fn=cylinder_fragments);
                    }
                    // top cover
                    color("Red", color_alpha)
                         translate([0, 0, (dimension+thickness)/2 - tol])
                         cylinder(h=thickness, d=(width+thickness)*2, center=true, $fn=cylinder_fragments);
                    // bottom cover
                    color("Red", color_alpha)
                         translate([0, 0, -( (dimension+thickness)/2 - tol)])
                         cylinder(h=thickness, d=(width+thickness)*2, center=true, $fn=cylinder_fragments);
               }

               // cut two cubes out to leave only a qauter of the cylinder
               color("Yellow", color_alpha)
                    translate([-(1.5 * dimension)/2, 0, 0])
                    cube(1.5 * dimension, center=true);
               color("Yellow", color_alpha)
                    translate([0, -(1.5 * dimension)/2, 0])
                    cube(1.5 * dimension, center=true);
          }

          // fill up to opening gap
          color("Magenta", color_alpha)
               translate([thickness/2, (width+thickness)/2, +(-opening_gap_height)/2])
               cube([thickness, width+thickness, dimension-opening_gap_height], center=true);
     }
}
