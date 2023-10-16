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
thickness = 3;
fragments = 300;

// the measured dimensions of the "floatie", the water vaporizer
floatie_diameter = 51;
floatie_height = 20;
floatie_leeway = 5;

// the measured dimensions of the bottle thread
thread_height = 19.9;
thread_diameter = 27.6;

// The dimensions of the inner hallow section
inner_hallow_x = 135; //  floatie_diameter/2  + floatie_leeway + thickness + 45 (half of pet bottle) + 35 (box lid offset)
inner_hallow_y = thread_diameter;
inner_hallow_z = 25; // the height of water channel, defines the height of witer in reservior
inner_hallow_z = 40; // for the bigger "smoke machine"

// trigger to release the bottle cap lock
trigger_height = inner_hallow_z + 7;
trigger_diameter = 5;

// The size of the rectangular part (body) of the outer shell
outer_shell_x = inner_hallow_x;
outer_shell_y = inner_hallow_y + thickness;
outer_shell_z = thread_height + inner_hallow_z + thickness - 1;

// splash gaurd
splash_gaurd_arm_count = 3;
splash_gaurd_arm_width = 5;
splash_gaurd_arm_height = 180;

splash_gaurd_radius = 1.5 * floatie_diameter;
splash_gaurd_height = 25;

// coloring
outer_shell_color = "Green";
inner_hallow_color = "Blue";
bottle_thread_color = "Red";
color_alpha=0.995;

/* use <../lib/splitter.scad> */
/* #split_along_yz(max_size=400, offset=10) */
/* translate([thickness+0.01, 0, 0]) */
/* rotate([0, -90, 0]) */
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
          // from https://www.thingiverse.com/thing:2693686
          import("../thingiverse.com/thing:2693686/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
}

// trigger to release the bottle cap lock
color("magenta")
translate([0, 0, trigger_height/2 + thickness - 10* tol])
cylinder(h=trigger_height, r1=2.0*trigger_diameter, r2=0.5*trigger_diameter, center=true, $fn=fragments);

// splash gaurd
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

translate([100, 0, 0])
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

d = floatie_diameter+ 2*(floatie_leeway);
translate([outer_shell_x, 0, 100])
let(
     r = 0.5 * d,
     sg_r = splash_gaurd_radius
)
{
     union(){
          // cone
          difference(){
               cylinder(h=5, r1=r, r2=sg_r, center=true, $fn=fragments);
               // middle hole
               cylinder(h=10, r=r-thickness, center=true, $fn=fragments);
               // make it cone
               translate([0, 0, thickness/2])
               cylinder(h=5, r1=r, r2=1.2*sg_r, center=true, $fn=fragments);
               // arm holes
               translate([-outer_shell_x, 0, -10]) 
               splash_gaurd_arms(scale=1.02);
          }
          // make a small wall to fit inside the reservoir
          translate([0, 0, -(2*6/3)])
          difference(){
               cylinder(h=6, r=r-1, center=true, $fn=fragments);
               cylinder(h=6+tol, r=r-thickness, center=true, $fn=fragments);
          }
     }          
     
}
