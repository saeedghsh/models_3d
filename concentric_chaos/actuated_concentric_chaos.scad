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

use <../lib/formfactor/battery.scad>
include <../lib/formfactor/battery_measurement.scad>
use <../lib/formfactor/motor_propeller.scad>
include <../lib/formfactor/motor_propeller_measurement.scad>
include <../lib/color_names.scad>
include <peg_and_hole.scad>
include <rings.scad>

//
alpha = 1;
tol = 0.01;
fragments = 300;

circle_count = 5; // Including the center one that holds the motors
height = 5;
thickness = 2;
concentric_offset = 2*(thickness + height)/3;

inner_circle_diameter = 2 * small_propeller_length;
outer_circle_diameter = inner_circle_diameter + (circle_count-1) * 2*concentric_offset;

module cross(){
    union(){
        cube([inner_circle_diameter+tol, thickness, height-tol], center=true);
        cube([thickness, inner_circle_diameter+tol, height-tol], center=true);
    }
}

aaa_holder_offset = 11;

color("red")
{
    aaa_holder_grip(tran=[0, -aaa_holder_offset, +(height/2 -thickness)], rot=[0, 0, 0], thickness=thickness);
    aaa_holder_grip(tran=[-aaa_holder_offset, 0, -(height/2 -thickness)], rot=[180, 0, 90], thickness=thickness);
}

union()
{
    formfactor_motor_and_propeller(tran=[0, small_propeller_length/2, 0], rot=[0, 0, 0]);
    formfactor_motor_and_propeller(tran=[small_propeller_length/2, 0, 0], rot=[180, 0, 0]);
    formfactor_aaa_holder(tran=[-aaa_holder_offset, 0, -(aaa_holder_height+height-tol)/2], rot=[180, 0, 90]);
    formfactor_aaa_holder(tran=[0, -aaa_holder_offset, +(aaa_holder_height+height-tol)/2], rot=[0, 0, 0]);
}

add_dc_motor_holder(motor_body_diameter=motor_body_diameter,
                    motor_body_length=motor_body_length,
                    dx=0,
                    dy=small_propeller_length/2,
                    thickness=thickness)
add_dc_motor_holder(motor_body_diameter=motor_body_diameter,
                    motor_body_length=motor_body_length,
                    dx=small_propeller_length/2,
                    dy=0,
                    thickness=thickness)
cross();

for (i = [0: circle_count-1]) {
    rotation_axis = i%2==0 ? "x" : "y";
    diameter = outer_circle_diameter - i * 2 * concentric_offset; // x2 because offset corresponds to radius

    color(color_names[1+5*i], alpha)
    add_peg_hole(
        diameter=diameter,
        height=height,
        thickness=thickness,
        rotation_axis=rotation_axis,      
        concentric_offset=concentric_offset)
    circle_ring(diameter=diameter, height=height, thickness=thickness);
}

