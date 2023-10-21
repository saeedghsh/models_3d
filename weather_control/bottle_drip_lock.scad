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

thickness = 3;
cylinder_fragments = 300;
tol = 0.2;

// the measured dimensions of the bottle thread
thread_height = 19.9;
thread_diameter = 27.6;

// coloring
color_alpha=0.995;
union(){

     // bottle gripping thread
     scale([1.1, 1.1, 1]) // turned out the thread doesnt fit normal pet bootle, needs adjustment
     difference(){
          color("Red", color_alpha)
               translate([0, 0, (thread_height+tol)/2])
               cylinder(h=thread_height-tol, d=thread_diameter+thickness, center=true, $fn=cylinder_fragments);
          color("Red", color_alpha)
               import("../thingiverse.com/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
     }

     // bottle reservoir screwing thread
     translate([0, 0, -thread_height])
     difference(){
          color("Green", color_alpha)
               import("../thingiverse.com/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
          color("Green", color_alpha)
               translate([0, 0, (thread_height+tol)/2])
               cylinder(h=thread_height+2*tol, d=thread_diameter-2*thickness, center=true, $fn=cylinder_fragments);
     }

     // the ring at the center connecting all
     difference(){
          color("Orange", color_alpha)
               cylinder(h=thickness, d=thread_diameter+2*thickness, center=true, $fn=cylinder_fragments);
          color("Orange", color_alpha)
               cylinder(h=thickness+tol, d=thread_diameter-4*thickness, center=true, $fn=cylinder_fragments);
     }

     // water blocker cylinder
     translate([0, 0, thread_height/2])
          difference(){
          color("Indigo", color_alpha)
               cylinder(h=thread_height, d=thread_diameter-3*thickness, center=true, $fn=cylinder_fragments);
          color("Indigo", color_alpha)
               cylinder(h=thread_height+tol, d=thread_diameter-4*thickness, center=true, $fn=cylinder_fragments);
     }

     // cross and lock holder at center
     difference(){
          union(){
               // cross hold at center
               color("Yellow", color_alpha)
                    cube(size=[thread_diameter-thickness, thickness, thickness], center=true);
               color("Yellow", color_alpha)
                    rotate([0, 0, 90])
                    cube(size=[thread_diameter-thickness, thickness, thickness], center=true);
               color("Yellow", color_alpha)
                    cylinder(h=5*thickness, d=3*thickness, center=true, $fn=cylinder_fragments);
          }
          color("Yellow", color_alpha)
               cylinder(h=5*thickness+tol, d=2*thickness, center=true, $fn=cylinder_fragments);
     }

     // water lock
     translate([0, 0, thickness*2/3])
          union()
     {
          // shaft
          color("Blue", color_alpha)
               cylinder(h=2*thread_height, d=2*(thickness-tol), center=true, $fn=cylinder_fragments);
          // top disk (water blocker)
          color("Blue", color_alpha)
               translate([0, 0, +thread_height])
               cylinder(h=thickness, d=thread_diameter-3*thickness, center=true, $fn=cylinder_fragments);
          // bottom disk (fall out lock)
          color("Blue", color_alpha)
               translate([0, 0, -thread_height])
               cylinder(h=thickness, d=3*thickness, center=true, $fn=cylinder_fragments);
     }
     
}
