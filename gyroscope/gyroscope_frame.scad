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


ALPHA = 1;
TOL = 0.01;
FRAGMENTS = 300;

BALLBEARING_HEIGHT = ballbearing_height_2;
BALLBEARING_OUTER_RADIUS = ballbearing_outer_radius_2;
BALLBEARING_INNER_RADIUS = ballbearing_inner_radius_2;

THICKNESS = 2; // TODO: split this to part specific thickness
RING_THICKNESS = 0.8 * BALLBEARING_HEIGHT; /// ring thickness
BALLBEARING_HOLDER_THICKNESS = 2; // ball bearing holder thickness

RING_COUNT = 5; // Including the center one that holds the motors
RING_HEIGHT = BALLBEARING_OUTER_RADIUS + BALLBEARING_HOLDER_THICKNESS;

// outward: iteration goes from inner ring outward
// For the version that holds two flat coin battery operated at cross bars //
// This was implemented because I wanted the inner ring to have a certain size to fit motor+propeller //
INNER_RING_DIAMETER = 2 * small_propeller_length;

// inward: iteration goes from outter ring inward
// For the version that holds small coin battery operated at the inner ring //
// This was implemented because I already had few rings and want to start from their size and redesign inner ring //
OUTER_RING_DIAMETER = 145.4;

ITERATION_DIRECTION = "inward";
SHOW_BALLBEARINGS = false;
SHOW_ACCESSORIES = false;

ACCESSORY = [
    "none",
    "led_on_ring",
    "led_on_cross",
    "motor_on_cross"
][0];

// -------------------------------------------------------------------------------- //
concentric_offset = 0.5 * (
    max(RING_THICKNESS, BALLBEARING_HEIGHT) + 
    max(2*(BALLBEARING_OUTER_RADIUS+BALLBEARING_HOLDER_THICKNESS), RING_HEIGHT)
);
led_design_thickness = 2; // this is the setting of the printed version of the led flash light I have
led_hole_diameter = led_body_diameter + 2 * led_design_thickness;
led_grip_diameter = led_hole_diameter + 2 * THICKNESS;

aaa_holder_offset = 11;

// -------------------------------------------------------------------------------- //
function ring_index_to_color_name(i) = color_names[26]; // color_names[1 + 10*i];
function inner_ring_index(direction) = direction=="outward" ? 1 : RING_COUNT;
function ring_diameter_outward(ring_index) = INNER_RING_DIAMETER + 2 * (ring_index-1) * concentric_offset;
function ring_diameter_inward(ring_index) = OUTER_RING_DIAMETER -  2 * (ring_index-1) * concentric_offset;
function get_ring_diameter(direction, ring_index) = direction=="outward" ? ring_diameter_outward(ring_index) : ring_diameter_inward(ring_index);
function rotation_axis_inward(ring_index) = ring_index%2==0 ? "y" : "x";
function rotation_axis_outward(ring_index) = ring_index%2==0 ? "x" : "y";
function get_rotation_axis(direction, ring_index) = direction=="outward" ? rotation_axis_outward(ring_index) : rotation_axis_inward(ring_index);

module ring(diameter, height, thickness){
	difference(){
	    cylinder(h=height, d=diameter+thickness, center=true, $fn=FRAGMENTS);
	    cylinder(h=height+TOL, d=diameter-thickness, center=true, $fn=FRAGMENTS);
	}
}

module ring_with_shaft(ring_diameter, rotation_axis, ring_thickness, ring_height) {
    // make a ring
    // - add outward shaft to fit to the ballbearing outer ring
    add_shaft_for_ballbearing(
        ring_diameter=ring_diameter,
        ballbearing_height=BALLBEARING_HEIGHT,
        ballbearing_inner_radius=BALLBEARING_INNER_RADIUS,
        rotation_axis=rotation_axis,
        concentric_offset=concentric_offset)
    ring(diameter=ring_diameter, height=ring_height, thickness=ring_thickness);
}

module ring_with_shaft_and_ballbearing_hole(ring_diameter, rotation_axis, ring_thickness, ring_height) {
    // make a ring
    // - add outward shaft to fit to the ballbearing outer ring
    // - remove a place for ballbearing
    remove_ballbearing_place(
        ring_diameter=ring_diameter,
        ballbearing_height=BALLBEARING_HEIGHT,
        ballbearing_outer_radius=BALLBEARING_OUTER_RADIUS,
        thickness=BALLBEARING_HOLDER_THICKNESS,
        rotation_axis=rotation_axis)
    ring_with_shaft(ring_diameter, rotation_axis, ring_thickness, ring_height);
}

module center_cross(ring_diameter, ring_height){
    union(){
        cube([ring_diameter+TOL, THICKNESS, ring_height-TOL], center=true);
        cube([THICKNESS, ring_diameter+TOL, ring_height-TOL], center=true);
    }
}

module add_motor_on_cross(ring_height){
    let(thickness=2){
        aaa_holder_grip(
            tran=[0, -aaa_holder_offset, +(ring_height/2 -thickness -TOL)],
            rot=[0, 0, 0],
            thickness=thickness);
        add_dc_motor_holder(motor_body_diameter=motor_body_diameter,
                        motor_body_length=motor_body_length,
                        dx=0,
                        dy=small_propeller_length/2,
                        thickness=thickness)
        children();
    }
}

module add_led_holder_on_cross(ring_index){
    ring_diameter = get_ring_diameter(ITERATION_DIRECTION, ring_index);
    difference(){
        let(thickness=2){
            center_cross(ring_diameter, ring_height);
        }
        translate([-ring_diameter/4, 0, 0])
        hull(){
            scale([0.98, 1, 1.5])
            mock_ballbearing(model="1");
        }
        translate([+ring_diameter/4, 0, 0])
        hull(){
            scale([0.98, 1, 1.5])
            mock_ballbearing(model="1");
        }
    }
    translate([-ring_diameter/4, 0, 0])
    mock_ballbearing(model="1");
    translate([+ring_diameter/4, 0, 0])
    mock_ballbearing(model="1");
}

module add_led_holder_on_ring(count, ring_index, ring_thickness) {
    total_count = 2* count; // count is the number on each side of the ring
    ring_diameter = get_ring_diameter(ITERATION_DIRECTION, ring_index);
    rotation_axis = get_rotation_axis(ITERATION_DIRECTION, ring_index);
    angle_period = 360 / total_count;
    // this offset make sure no led holder coincides with the ballbearing shaft
    angle_offset = rotation_axis=="x" ? angle_period / 2 : 0;

    function theta(index) = angle_offset + index * angle_period;
    module grip(angle){
        rotate([0, 0, angle])
        translate([0, ring_diameter/ 2 , 0])
        rotate([90, 0, 0])
        cylinder(h = ring_thickness, d = led_grip_diameter, center=true, $fn=FRAGMENTS);
    }
    module hole(angle){
        rotate([0, 0, angle])
        translate([0, ring_diameter/ 2  , 0])
        rotate([90, 0, 0])
        cylinder(h = 2*ring_thickness, d = led_hole_diameter, center=true, $fn=FRAGMENTS);
    }
    difference(){
        union(){
            children();
            for (led_index = [1: total_count]) {
                grip(theta(led_index));
            }
        }
        for (led_index = [1: total_count]) {
                hole(theta(led_index));
        }
    }
}

// main loop creating the rings
for (ring_index = [1: RING_COUNT]) {
    rotation_axis = get_rotation_axis(ITERATION_DIRECTION, ring_index);
    ring_diameter = get_ring_diameter(ITERATION_DIRECTION, ring_index);
    if (ring_index == inner_ring_index(ITERATION_DIRECTION))
    {
        if (ACCESSORY == "led_on_ring"){
            add_led_holder_on_ring(2, ring_index, RING_THICKNESS)
            ring_with_shaft(ring_diameter, rotation_axis, RING_THICKNESS, RING_HEIGHT);
        }
        else if (ACCESSORY == "led_on_cross"){
            add_led_holder_on_cross(ring_index)
            center_cross(ring_diameter, RING_HEIGHT);
            ring_with_shaft(ring_diameter, rotation_axis, RING_THICKNESS, RING_HEIGHT);
        }
        else if (ACCESSORY == "motor_on_cross"){
            add_motor_on_cross(RING_HEIGHT)
            center_cross(ring_diameter, RING_HEIGHT);
            ring_with_shaft(ring_diameter, rotation_axis, RING_THICKNESS, RING_HEIGHT);
        }
        else if (ACCESSORY == "none"){
            ring_with_shaft(ring_diameter, rotation_axis, RING_THICKNESS, RING_HEIGHT);
        }
    }
    else {
        ring_with_shaft_and_ballbearing_hole(ring_diameter, rotation_axis, RING_THICKNESS, RING_HEIGHT);
    }
}


////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// additional visualization
////////////////////////////////////////////////////////////////////////////////
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

if (SHOW_BALLBEARINGS==true){
    for (ring_index = [1: RING_COUNT]) {
        rotation_axis = get_rotation_axis(ITERATION_DIRECTION, ring_index);
        ring_diameter = get_ring_diameter(ITERATION_DIRECTION, ring_index);
        if (ring_index != inner_ring_index(ITERATION_DIRECTION)){
            add_ballbearing(rotation_axis, ring_diameter);
        }
    }
}
if (ACCESSORY == "motor_on_cross" && SHOW_ACCESSORIES == true){
    formfactor_motor_and_propeller(tran=[0, small_propeller_length/2, 0], rot=[0, 0, 0]);
    formfactor_aaa_holder(tran=[0, -aaa_holder_offset, +(aaa_holder_height+RING_HEIGHT-TOL)/2], rot=[0, 0, 0]);
}
if (ACCESSORY == "led_on_cross" && SHOW_ACCESSORIES == true){
    echo("nothing to see here");
}