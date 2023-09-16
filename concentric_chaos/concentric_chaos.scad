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
include <peg_and_hole.scad>
include <rings.scad>

alpha = 1;

max_diameter = 150;
circle_count = 7;
thickness = 3;
height = 8;

concentric_offset = thickness + height;
for (i = [0: circle_count-1]) {
    rotation_axis = i%2==0 ? "x" : "y";
    diameter = max_diameter - i * 2 * concentric_offset; // x2 because offset corresponds to radius

    color(color_names[1+5*i], alpha)
    add_peg_hole(
        diameter=diameter,
        height=height,
        thickness=thickness,
        rotation_axis=rotation_axis,      
        concentric_offset=concentric_offset)
    square_ring(diameter=diameter, height=height, thickness=thickness);
}
