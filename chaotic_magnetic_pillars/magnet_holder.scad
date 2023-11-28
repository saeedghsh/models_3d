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
include <measurements.scad>

tol = 0.02;
fragments = 300;

module pipe(height, inner_d, outer_d){
    difference(){
        cylinder(h=height, d=outer_d, center=true, $fn=fragments);
        cylinder(h=height+tol, d=inner_d, center=true, $fn=fragments);
    }
}

magnet_count = 4;

// magnet_enclosure: inner height for for magnet_count+1
let(inner_d = 1.05 * magnet_diameter,
    outer_d = inner_d + 2* thickness,
    h = (magnet_count+1) * magnet_height_thin)
{
    translate([0, 0, h/2])
    pipe(h, inner_d, outer_d);
}
// wire holder
let(inner_d = spring_steel_wire_diameter,
    outer_d = inner_d + 4* thickness,
    h = wire_hold_height)
{
    translate([0, 0, -h/2])
    pipe(h, inner_d, outer_d);
}
// disk in between
let(d = 1.05 * magnet_diameter + 2* thickness,
    h = thickness)
{
    translate([0, 0, -h/2])
    cylinder(h=h, d=d, center=true, $fn=fragments);
}

// just a magnet
color("gray")
translate([0, 0, 15])
cylinder(h=magnet_height_thick, d=magnet_diameter, $fn=fragments);