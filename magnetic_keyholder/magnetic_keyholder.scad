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

use <../lib/extrude_directional.scad>

tol = 0.02;
fragments = 300;

magnet_diameter = 10.0;
magnet_height = 3.0;
shaft_diameter = 5.6;
thickness = 1.0;

box_x = magnet_diameter + 2 * thickness;
box_y = box_x;
box_z = magnet_height + shaft_diameter + 3 * thickness;


module magnet()
{
    cylinder(h=magnet_height, d=magnet_diameter, $fn=fragments, center=true);
}


module shaft()
{
  color("Black", 1.0)
    translate([0, 0, shaft_diameter/2 + magnet_height/2 + thickness])
    rotate([0, 90, 0])
    cylinder(h=20, d=shaft_diameter, $fn=fragments, center=true);
}

module shaft_gap()
{
  color("Black", 1.0)
    translate([0, 0, shaft_diameter + magnet_height/2 + thickness])
    cube([20, shaft_diameter * 0.9, shaft_diameter], center=true);
}

difference(){
  color("Blue", 1.0)
    translate([0, 0, box_z/2 - (magnet_height/2 + thickness)])
    cube([box_x, box_y, box_z], center=true);

  
  union(){
    shaft();
    shaft_gap();
    
    extrude_along_y(length=1.1*box_x/2)
      magnet();
  }
}

