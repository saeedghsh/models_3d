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
include <water_reservoir_measurements.scad>

tol = 0.01;
fragments = 300;

module splash_gaurd_arms(scale) {
     for (i=[0:splash_gaurd_arm_count-1]){
          angle = i * 360/splash_gaurd_arm_count;
          r = (floatie_diameter+ 2*(floatie_leeway+thickness))/2;
          dx = r * cos(angle);
          dy = r * sin(angle);

          translate([outer_shell_x +dx, dy, splash_gaurd_arm_height/2])
          rotate([0, 0, angle])
          scale([scale, scale, 1])
          cube([splash_gaurd_arm_width, splash_gaurd_arm_width, splash_gaurd_arm_height], center=true);
     }
}

// splash gaurd and its legs
*translate([100, 0, 0])
union(){
     difference(){
          translate([outer_shell_x, 0, splash_gaurd_arm_height-splash_gaurd_height/2])
          cylinder(h=splash_gaurd_height, r1=0, r2=splash_gaurd_radius, center=true, $fn=fragments);

          translate([0, 0, +0.1])
          splash_gaurd_arms(scale=1.1);
     }
     translate([0, 0, -20])
     splash_gaurd_arms(scale=1);
}

module reservoir(){
     difference(){
          // outer shell
          union()
          {
               // body
               color(outer_shell_color, color_alpha)
                    translate([outer_shell_x/2, 0, outer_shell_z/2])
                    cube(size=[outer_shell_x, outer_shell_y, outer_shell_z], center=true);
               // humidifier side
               color(outer_shell_color, color_alpha)
                    translate([outer_shell_x, 0, outer_shell_z/2])
                    cylinder(h=outer_shell_z, d=floatie_diameter+ 2*(floatie_leeway+thickness), center=true, $fn=fragments);
               // threaded side
               color(outer_shell_color, color_alpha)
                    translate([0, 0, outer_shell_z/2])
                    cylinder(h=outer_shell_z, d=outer_shell_y, center=true, $fn=fragments);
          }

          // inner hallow
          union()
          {
               // body
               color(inner_hallow_color, color_alpha)
                    translate([outer_shell_x/2, 0, inner_hallow_z/2 + thickness])
                    cube(size=[outer_shell_x, inner_hallow_y, inner_hallow_z], center=true);
               // humidifier side
               color(inner_hallow_color, color_alpha)
                    translate([outer_shell_x, 0, outer_shell_z/2 + thickness])
                    cylinder(h=outer_shell_z, d=floatie_diameter+2*floatie_leeway, center=true, $fn=fragments);
               // threaded side
               color(inner_hallow_color, color_alpha)
                    translate([0, 0, inner_hallow_z/2 + thickness])
                    cylinder(h=inner_hallow_z, d=inner_hallow_y, center=true, $fn=fragments);
          }
          // bottle thread
          color(bottle_thread_color, color_alpha)
               translate([0, 0, outer_shell_z-thread_height])
               import("../thingiverse.com/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
     }
     // trigger to release the bottle cap lock
     color("magenta")
     translate([0, 0, trigger_height/2 + thickness - 10* tol])
     cylinder(h=trigger_height, r1=2.0*trigger_diameter, r2=0.5*trigger_diameter, center=true, $fn=fragments);
}

// /* translate([thickness+0.01, 0, 0]) */
// /* rotate([0, -90, 0]) */
reservoir();

