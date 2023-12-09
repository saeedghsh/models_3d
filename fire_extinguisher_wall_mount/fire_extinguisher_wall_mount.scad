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
thickness = 2.0;
fragments = 300;

screw_d = 3.7;

// back_wall
back_wall_height = 200;
back_wall_width = 20;
let(x = back_wall_width,
    y = thickness,
    z = back_wall_height,
    screw_d = screw_d)
{
    difference(){
        translate([0, y/2, z/2])
        cube([x, y, z], center=true);
        
        translate([0, 0, z-(x/2)])
        rotate([90, 0, 0])
        cylinder(h=2*thickness + tol, d=screw_d, center=true, $fn=fragments);
    }
}

// bottom_shelf
bottom_shelf_length = 10;
bottom_shelf_width = 20;
let(x = bottom_shelf_width,
    y = bottom_shelf_length,
    z = thickness)
{
    translate([0, -y/2, z/2])
    cube([x, y, z], center=true);
}

// bottom_hook
bottom_hook_height = 12;
bottom_hook_width = 20;
let(x = bottom_hook_width,
    y = thickness,
    z = bottom_hook_height,
    dy = bottom_shelf_length)
{
    translate([0, -dy-y/2, z/2])
    cube([x, y, z], center=true);
}

// body_grab
body_grab_diameter = 86;
body_grab_height = 20;
let(inner_d = body_grab_diameter,
    outer_d = body_grab_diameter + 2* thickness,
    screw_d = screw_d,
    h = body_grab_height,
    dy = -outer_d/2,
    dz = back_wall_height - back_wall_width / 2)
{
    translate([0, dy, dz])
    difference(){
        union(){
            difference(){
                cylinder(h=h, d=outer_d, center=true, $fn=fragments);
                cylinder(h=h+tol, d=inner_d, center=true, $fn=fragments);
                translate([0, -0.7 * outer_d, 0])
                cube([outer_d+tol, outer_d+tol, h+tol], center=true);
            }
            translate([0, (inner_d+thickness)/2, 0])
            cube([h, thickness, h], center=true);
        }
        rotate([90, 0, 0])
        cylinder(h=1.1*outer_d, d=screw_d, center=true, $fn=fragments);
    }
}

