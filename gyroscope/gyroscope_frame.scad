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

ring_count = 3; // Including the center one that holds the motors
height = ballbearing_outer_radius; // ring height
thickness = 2 ; //ballbearing_height;

// outward: iteration goes from inner ring outward
// For the version that holds two flat coin battery operated at cross bars //
// This was implemented because I wanted the inner ring to have a certain size to fit motor+propeller //
inner_ring_diameter = 2 * small_propeller_length;

// inward: iteration goes from outter ring inward
// For the version that holds small coin battery operated at the inner ring //
// This was implemented because I already had few rings and want to start from their size and redesign inner ring //
outer_ring_diameter = 145.4;

iteration_direction = "inward";
show_ballbearings = true;
show_accessories = true;

accessory = ["led_on_ring", "led_on_cross", "motor_on_cross"][0];

// -------------------------------------------------------------------------------- //
concentric_offset = 2*(thickness + height)/2;
led_design_thickness = 2; // this is the setting of the printed version of the led flash light I have
led_hole_diameter = led_body_diameter + 2 * led_design_thickness;
led_grip_diameter = led_hole_diameter + 2*thickness;

aaa_holder_offset = 11;

function ring_index_to_color_name(i) = color_names[26]; // color_names[1 + 10*i];
function inner_ring_index(direction) = direction=="outward" ? 1 : ring_count;
function ring_diameter_outward(ring_index) = inner_ring_diameter + 2 * (ring_index-1) * concentric_offset;
function ring_diameter_inward(ring_index) = outer_ring_diameter -  2 * (ring_index-1) * concentric_offset;
function get_ring_diameter(direction, ring_index) = direction=="outward" ? ring_diameter_outward(ring_index) : ring_diameter_inward(ring_index);
function rotation_axis_inward(ring_index) = ring_index%2==0 ? "y" : "x";
function rotation_axis_outward(ring_index) = ring_index%2==0 ? "x" : "y";
function get_rotation_axis(direction, ring_index) = direction=="outward" ? rotation_axis_outward(ring_index) : rotation_axis_inward(ring_index);

module circle_ring(diameter, height, thickness){
	  difference(){
	      cylinder(h=height, d=diameter+thickness, center=true, $fn=fragments);
	      cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fragments);
	  }
}

module center_cross(ring_diameter){
    union(){
        cube([ring_diameter+tol, thickness, height-tol], center=true);
        cube([thickness, ring_diameter+tol, height-tol], center=true);
    }
}

module ring_with_shaft(ring_diameter, rotation_axis) {
    // make a ring
    // - add outward shaft to fit to the ballbearing outer ring
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

module ring_with_shaft_and_ballbearing_hole(ring_diameter, rotation_axis) {
    // make a ring
    // - add outward shaft to fit to the ballbearing outer ring
    // - remove a place for ballbearing
    remove_ballbearing_place(
        ring_diameter=ring_diameter,
        ballbearing_height=ballbearing_height,
        ballbearing_inner_radius=ballbearing_inner_radius,
        ballbearing_outer_radius=ballbearing_outer_radius,
        thickness=thickness,
        rotation_axis=rotation_axis,
        concentric_offset=concentric_offset)
    ring_with_shaft(ring_diameter, rotation_axis);
}

module add_motor_on_cross(){
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
        children();
    }
}

module add_led_holder_on_cross(ring_index){
    ring_diameter = get_ring_diameter(iteration_direction, ring_index);
    difference(){
        let(thickness=2){
            center_cross(ring_diameter);
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

module add_led_holder_on_ring(count, ring_index) {
    total_count = 2* count; // count is the number on each side of the ring
    ring_diameter = get_ring_diameter(iteration_direction, ring_index);
    rotation_axis = get_rotation_axis(iteration_direction, ring_index);
    angle_period = 360 / total_count;
    // this offset make sure no led holder coincides with the ballbearing shaft
    angle_offset = rotation_axis=="x" ? angle_period / 2 : 0;

    function theta(index) = angle_offset + index * angle_period;
    module grip(angle){
        rotate([0, 0, angle])
        translate([0, ring_diameter/ 2 , 0])
        rotate([90, 0, 0])
        cylinder(h = thickness, d = led_grip_diameter, center=true, $fn=fragments);
    }
    module hole(angle){
        rotate([0, 0, angle])
        translate([0, ring_diameter/ 2 , 0])
        rotate([90, 0, 0])
        cylinder(h = 2*thickness, d = led_hole_diameter, center=true, $fn=fragments);
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
for (ring_index = [1: ring_count]) {
    rotation_axis = get_rotation_axis(iteration_direction, ring_index);
    ring_diameter = get_ring_diameter(iteration_direction, ring_index);
    if (ring_index == inner_ring_index(iteration_direction))
    {
        if (accessory == "led_on_ring"){
            add_led_holder_on_ring(count=2, ring_index=ring_index)
            ring_with_shaft(ring_diameter, rotation_axis);
        }
        if (accessory == "led_on_cross"){
            add_led_holder_on_cross(ring_index)
            center_cross(ring_diameter);
            ring_with_shaft(ring_diameter, rotation_axis);
        }
        if (accessory == "motor_on_cross"){
            add_motor_on_cross()
            center_cross(ring_diameter);
            ring_with_shaft(ring_diameter, rotation_axis);
        }
    }
    else {
        ring_with_shaft_and_ballbearing_hole(ring_diameter, rotation_axis);
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

if (show_ballbearings==true){
    for (ring_index = [1: ring_count]) {
        rotation_axis = get_rotation_axis(iteration_direction, ring_index);
        ring_diameter = get_ring_diameter(iteration_direction, ring_index);
        if (ring_index != inner_ring_index(iteration_direction)){
            add_ballbearing(rotation_axis, ring_diameter);
        }
    }
}
if (accessory == "motor_on_cross" && show_accessories == true){
    formfactor_motor_and_propeller(tran=[0, small_propeller_length/2, 0], rot=[0, 0, 0]);
    formfactor_aaa_holder(tran=[0, -aaa_holder_offset, +(aaa_holder_height+height-tol)/2], rot=[0, 0, 0]);
}
if (accessory == "led_on_cross" && show_accessories == true){
    echo("nothing to see here");
}