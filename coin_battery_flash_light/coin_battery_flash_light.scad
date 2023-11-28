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

include <../lib/formfactor/battery_measurement.scad>
include <../lib/formfactor/led_measurement.scad>

use <../lib/formfactor/battery.scad>
use <../lib/formfactor/led.scad>

tol = 0.01;
thickness = 2;
fragments = 300;

// Isolation disk between batter and led
disk_thickness = 1;

module led_and_battery_holder(battery_height, battery_diameter, battery_count){
    difference(){
        union(){
            // LED holder fitting inside ballbearing
            translate([0, 0, thickness +(led_body_height/2+thickness)/2 -tol])
                cylinder(h=led_body_height/2+thickness, d=led_body_diameter+2*thickness, center=true, $fn=fragments);

            // middle disk between LED holder and battery holder
            translate([0, 0, thickness -thickness/2])
                cylinder(h=thickness, d=battery_diameter + 2*thickness, center=true, $fn=fragments);

            // battery holder rim
            translate([0, 0, -(battery_count*battery_height+disk_thickness+ thickness)/2])
            cylinder(
                h=battery_count*battery_height+disk_thickness + thickness,
                d=battery_diameter+2*thickness,
                center=true, $fn=fragments);
        }

        // remove LED body
        cylinder(h=10*(led_body_height+thickness), d=led_body_diameter+tol, center=true, $fn=fragments);

        // remove LED bottom rim
        translate([0, 0, led_rim_height/2-tol])
        cylinder(h=led_rim_height, d=led_rim_diameter+tol, center=true, $fn=fragments);

        // remove the space for the battery
        let(total_height=battery_count*battery_height + disk_thickness)
        {
            translate([0, 0, -total_height/2])
            cylinder(h=total_height+tol, d=battery_diameter, center=true, $fn=fragments);
        }

        // remove half of battery holder rim
        let(outer_d=battery_diameter+2*thickness,
            total_battery_height=battery_count*battery_height)
        {
            translate([outer_d/2, 0, -total_battery_height/2 -disk_thickness])
            cube([outer_d, outer_d, total_battery_height+tol], center=true);
        }

        // remove a small hole on the back of battery rim to give access for pushing out the battery
        let(outer_d=battery_diameter+2*thickness,
            total_battery_height=battery_count*battery_height)
        {
            translate([-(battery_diameter+thickness/2), 0, -total_battery_height/2 -disk_thickness])
            cube([outer_d, outer_d, total_battery_height+tol], center=true);
        }

        // when there are more than one batteries, we only want the outer leg of led to contant the last battery
        // so here we carve out a gap to let the led leg to out and come back at the different hieght
        let(gap= (battery_count - 0.5) * battery_height)
        {
            rotate([0, 0, -30])
            translate([0, -battery_diameter/2, -gap/2])
            cube(size = [1.5*led_leg_width, battery_diameter, gap], center = true);   
        }
    }
}

module battery_isolate_disk(battery_height, battery_diameter){
    difference(){
        cylinder(h=disk_thickness, d=battery_diameter-10*tol, center=true, $fn=fragments);
        cylinder(h=2*disk_thickness, d=led_rim_diameter, center=true, $fn=fragments);
    }  
}

let(
    battery_diameter=lr44_diameter,
    battery_height=lr44_thickness,
    battery_count=2)
{
    color("DarkOrange")
    led_and_battery_holder(battery_height, battery_diameter, battery_count);
    
    color("LimeGreen")
    translate([0, 0, -0.5])
    battery_isolate_disk(battery_height, battery_diameter);
}

#let(){
    led(clr="DarkRed", include_legs=false);
    formfactor_lr44(tran=[0, 0, -lr44_thickness/2 - disk_thickness]);
    formfactor_lr44(tran=[0, 0, -3*lr44_thickness/2 - disk_thickness]);
}