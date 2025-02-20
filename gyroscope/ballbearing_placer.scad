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

include <../lib/color_names.scad>

tol = 0.1;
fragments = 100;


module remove_ballbearing_place(
    ring_diameter,
    ballbearing_height,
    ballbearing_outer_radius,
    thickness,
    rotation_axis)
{
    hole_diameter = 2* ballbearing_outer_radius;
    ballbearing_holder_radius = ballbearing_outer_radius + thickness;
    angle = rotation_axis=="x" ? 0 : 90;
    union(){
    difference(){
        union(){
            // the ring on which the operation is applied to
  	        children();
            rotate([0, 0, angle])
            {
                // add two disks for holding ball bearing
                translate([0.99*ring_diameter/2, 0, 0])
                rotate([0, 90, 0])
                cylinder(h=ballbearing_height, r=ballbearing_holder_radius, center=true, $fn=fragments);
                translate([-0.99*ring_diameter/2, 0, 0])
                rotate([0, 90, 0])
                cylinder(h=ballbearing_height, r=ballbearing_holder_radius, center=true, $fn=fragments);
            }
        }
        // remove holes from the ballbearing holding disk
        rotate([0, 0, angle])
  	    rotate([0, 90, 0])
  	    cylinder(h=ring_diameter+2*thickness+tol, d=hole_diameter, center=true, $fn=fragments);
    }
    }
}

module add_shaft_for_ballbearing(
    ring_diameter,
    ballbearing_height,
    ballbearing_inner_radius,
    rotation_axis,
    concentric_offset)
{
    peg_height = concentric_offset + ballbearing_height / 2;
    peg_diameter = 2* ballbearing_inner_radius;
    angle = rotation_axis=="x" ? 0 : 90;
    union(){
         // the ring on which the operation is applied to
        children();
        rotate([0, 0, angle])
        {
            // peg to positive sides (+x and +y)
            translate([0, (ring_diameter + peg_height) / 2, 0])
            rotate([90, 0, 0])
            cylinder(h=peg_height, d=peg_diameter, center=true, $fn=fragments);
            // peg to negative sides (-x and -y)
            translate([0, -(ring_diameter + peg_height) / 2, 0])
            rotate([90, 0, 0])
            cylinder(h=peg_height, d=peg_diameter, center=true, $fn=fragments);
        }
    }
}
