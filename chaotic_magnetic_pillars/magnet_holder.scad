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
magnet_count = 5;

// magnet_enclosure: inner height for for magnet_count+1
function get_magnet_compartment_inner_d() = 1.02 * magnet_diameter;
function get_magnet_compartment_outer_d() = get_magnet_compartment_inner_d() + 2*thickness;
function get_magnet_compartment_height(_magnet_count) = (_magnet_count+2.5) * magnet_height_thin;
let(inner_d = get_magnet_compartment_inner_d(),
    outer_d = get_magnet_compartment_outer_d(),
    h = get_magnet_compartment_height(magnet_count))
{
    translate([0, 0, h/2])
    pipe(h, inner_d, outer_d);
}
// disk in between
let(outer_d = get_magnet_compartment_outer_d(),
    h = thickness)
{
    translate([0, 0, -h/2])
    cylinder(h=h, d=outer_d, center=true, $fn=fragments);
}
// wire holder
function get_wire_hold_inner_d() = spring_steel_wire_diameter / 0.8;
function get_wire_hold_outer_d() = get_wire_hold_inner_d() + 4*thickness;
function get_wire_hold_height() = 10;
let(inner_d = get_wire_hold_inner_d(),
    outer_d = get_wire_hold_outer_d(),
    h = get_wire_hold_height())
{
    translate([0, 0, -h/2])
    pipe(h, inner_d, outer_d);
}

// just a magnet
*color("gray")
translate([0, 0, 25])
cylinder(h=magnet_height_thick, d=magnet_diameter, $fn=fragments);