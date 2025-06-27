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

plate_size = 25;
cutout_height = 10;
cutout_width = 20;
screw_diameter = 2;
screw_to_side_offset = 2;
screw_to_screw_vertical = 21;
screw_to_screw_horizontal = 13;
module camera_plate()
{
     difference(){
          // camera hold plate
          cube([plate_size, plate_size, thickness], center=true);
          // camera cut out
          translate([(plate_size-cutout_width)/2 + tol, 0, 0])
               cube([cutout_width, cutout_height, thickness+tol], center=true);
          // screws cut out
          translate([plate_size/2 - screw_to_side_offset, screw_to_screw_vertical/2, 0])
               cylinder(h=thickness+tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
          // screws cut out
          translate([plate_size/2 - screw_to_side_offset, -screw_to_screw_vertical/2, 0])
               cylinder(h=thickness+tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
          // screws cut out
          translate([plate_size/2 - screw_to_side_offset - screw_to_screw_horizontal, screw_to_screw_vertical/2, 0])
               cylinder(h=thickness+tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
          // screws cut out
          translate([plate_size/2 - screw_to_side_offset - screw_to_screw_horizontal, -screw_to_screw_vertical/2, 0])
               cylinder(h=thickness+tol, d=screw_diameter, center=true, $fn=cylinder_fragments);
     }
}

head_diameter = 6;
head_thickness = 2;
shaft_diameter = 3;
shaft_thickness = 2;
module screw_head_holder()
{
     union(){
          translate([0, 0, shaft_thickness+head_thickness/2])
               cylinder(h=head_thickness, d=head_diameter, center=true, $fn=cylinder_fragments);
          translate([0, 0, shaft_thickness/2])
               cylinder(h=shaft_thickness+tol, d=shaft_diameter, center=true, $fn=cylinder_fragments);
     }
}

holder_plate_height = 40;
holder_plate_width = 70;
holder_head_to_top = 35;
holder_head_to_head = 35;
color("Green", color_alpha)
union(){
     translate([0, 0, -thickness/2])
          cube([holder_plate_width, holder_plate_height, thickness], center=true);

     translate([0, -(holder_head_to_top-(holder_plate_height/2)), 0])
     union(){
          translate([holder_head_to_head/2, 0, 0])
               screw_head_holder();
          translate([-holder_head_to_head/2, 0, 0])
               screw_head_holder();
     }
}

bridge_width = 60-(holder_plate_width-holder_head_to_head)/2;
bridge_height = plate_size;
// translate([(bridge_width+holder_plate_width)/2, (holder_plate_height-bridge_height)/2, -thickness/2])
// cube([bridge_width+tol, bridge_height, thickness], center=true);

color("Red", color_alpha)
translate([(plate_size+holder_plate_width)/2+bridge_width-tol, (holder_plate_height-bridge_height)/2, -thickness/2])
camera_plate();
