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
use <../formfactors/battery.scad>
include <../formfactors/battery_measurement.scad>
use <../formfactors/motor_propeller.scad>
include <../formfactors/motor_propeller_measurement.scad>
use <../formfactors/ballbearing.scad>
include <../formfactors/ballbearing_measurement.scad>
use <../formfactors/led.scad>
include <../formfactors/led_measurement.scad>
include <ballbearing_placer.scad>


alpha = 1;
tol = 0.01;
fragments = 300;

ballbearing_height = ballbearing_height_2;
ballbearing_outer_radius = ballbearing_outer_radius_2;
ballbearing_inner_radius = ballbearing_inner_radius_2;
ballbearing_brearing_radius = ballbearing_brearing_radius_2;

circle_count = 3; // Including the center one that holds the motors
height = ballbearing_outer_radius; // ring height
thickness = 2 ; //ballbearing_height;
concentric_offset = 2*(thickness + height)/2;

inner_circle_diameter = 2 * small_propeller_length;

function ring_index_to_color_name(i) = color_names[26]; // color_names[1 + 10*i];

module circle_ring(diameter, height, thickness){
	  difference(){
	      cylinder(h=height, d=diameter+thickness, center=true, $fn=fragments);
	      cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fragments);
	  }
}
module cross(){
    union(){
        cube([inner_circle_diameter+tol, thickness, height-tol], center=true);
        cube([thickness, inner_circle_diameter+tol, height-tol], center=true);
    }
}

module add_ballbearing(rotation_axis, ring_diameter){
    angle = rotation_axis=="x" ? 0 : 90;
    rotate([0, 0, angle])
    {
        translate([0.99*ring_diameter/2, 0, 0])
        rotate([0, 90, 0])
        ballbearing(model = "2");
        translate([-0.99*ring_diameter/2, 0, 0])
        rotate([0, 90, 0])
        ballbearing(model = "2");
    }
}

for (i = [1: circle_count]) {
    rotation_axis = i%2==0 ? "x" : "y";
    ring_diameter = inner_circle_diameter + 2 * (i-1) * concentric_offset; // x2 because offset corresponds to radius

    if (i == 1)
    {
        color(ring_index_to_color_name(i), alpha)
        add_shaft_for_ballbearing(
            ring_diameter=ring_diameter,
            ballbearing_height=ballbearing_height,
            ballbearing_inner_radius=ballbearing_inner_radius,
            ballbearing_outer_radius=ballbearing_outer_radius,
            thickness=thickness,
            rotation_axis=rotation_axis,
            concentric_offset=concentric_offset)
        circle_ring(diameter=ring_diameter, height=height, thickness=thickness);
    }
    else {
        add_ballbearing(rotation_axis, ring_diameter);
        color(ring_index_to_color_name(i), alpha)
        remove_ballbearing_place(
            ring_diameter=ring_diameter,
            ballbearing_height=ballbearing_height,
            ballbearing_inner_radius=ballbearing_inner_radius,
            ballbearing_outer_radius=ballbearing_outer_radius,
            thickness=thickness,
            rotation_axis=rotation_axis,
            concentric_offset=concentric_offset)
        add_shaft_for_ballbearing(
            ring_diameter=ring_diameter,
            ballbearing_height=ballbearing_height,
            ballbearing_inner_radius=ballbearing_inner_radius,
            ballbearing_outer_radius=ballbearing_outer_radius,
            thickness=thickness,
            rotation_axis=rotation_axis,
            concentric_offset=concentric_offset)
        circle_ring(diameter=ring_diameter, height=height-10*tol, thickness=thickness);
    }
}


// center_ring = "motor";
center_ring = "leds";

// center ring: with motor and propeller
if (center_ring == "motor"){
    aaa_holder_offset = 11;
    color(ring_index_to_color_name(1), alpha)
    let(thickness=2){
        aaa_holder_grip(
            tran=[0, -aaa_holder_offset, +(height/2 -thickness -tol)],
            rot=[0, 0, 0],
            thickness=thickness);
        add_dc_motor_holder(motor_body_diameter=motor_body_diameter,
                        motor_body_length=motor_body_length,
                        dx=0,
                        dy=small_propeller_length/2,
                        thickness=thickness)
        cross();
    }
    formfactor_motor_and_propeller(tran=[0, small_propeller_length/2, 0], rot=[0, 0, 0]);
    formfactor_aaa_holder(tran=[0, -aaa_holder_offset, +(aaa_holder_height+height-tol)/2], rot=[0, 0, 0]);
}


color(ring_index_to_color_name(1), alpha)
if (center_ring == "leds"){
    inner_circle_radius = inner_circle_diameter/2;
    difference(){
        aaa_holder_offset = 0;
        let(thickness=2){
            cross();
        }
        translate([-inner_circle_radius/2, 0, 0])
        hull(){
            scale([0.98, 1, 1.5])
            mock_ballbearing(model="1");
        }

        translate([+inner_circle_radius/2, 0, 0])
        hull(){
            scale([0.98, 1, 1.5])
            mock_ballbearing(model="1");
        }
    }
    translate([-inner_circle_radius/2, 0, 0])
    mock_ballbearing(model="1");

    translate([+inner_circle_radius/2, 0, 0])
    mock_ballbearing(model="1");
}

