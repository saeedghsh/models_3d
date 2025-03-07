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

include <../formfactors/battery_measurement.scad>
include <../formfactors/led_measurement.scad>

use <../formfactors/battery.scad>
use <../formfactors/led.scad>

tol = 0.01;
thickness = 2;
fragments = 300;

battery_count = 2;

// Isolation disk between batter and led
disk_thickness = 1;
// For some reason the batteries do not fit with very tight/accurate measurements
// so we add a buffer of 0.3mm for one battery, and 0.7mm if there are more than one batteries!
battery_compartment_buffer = battery_count == 1 ? 0.25 : 0.50;

module led_and_battery_holder(battery_height, battery_diameter, battery_count){
    difference(){
        union(){
            // LED holder
            let(h = thickness,
                d = led_body_diameter+2*thickness,
                dz = thickness +h/2)
            {
                translate([0, 0, dz-tol])
                cylinder(h=h, d=d, center=true, $fn=fragments);
            }

            // middle disk between LED holder and battery holder
            let(h=thickness,
                d=battery_diameter + 2*thickness)
            {
                translate([0, 0, h/2])
                cylinder(h=h, d=d, center=true, $fn=fragments);
            }

            // battery holder rim
            let(h=battery_count*battery_height +battery_compartment_buffer +disk_thickness +thickness,
                d=battery_diameter+2*thickness)
            {
                translate([0, 0, -(h)/2])
                cylinder(h=h,d=d,center=true, $fn=fragments);
            }
        }

        // remove LED body
        let(h = 10*(led_body_height+thickness),
            d = led_body_diameter)
        {
            cylinder(h=h, d=d+tol, center=true, $fn=fragments);
        }

        // remove LED bottom rim
        let(h = led_rim_height,
            d = led_rim_diameter)
        {
            translate([0, 0, h/2-tol])
            cylinder(h=h, d=d+tol, center=true, $fn=fragments);
        }

        // remove the space for the battery
        let(h = battery_count*battery_height +battery_compartment_buffer +disk_thickness,
            d = battery_diameter)
        {
            translate([0, 0, -h/2])
            cylinder(h=h+tol, d=d, center=true, $fn=fragments);
        }

        // remove half of battery holder rim
        let(d=battery_diameter+2*thickness,
            h = battery_count*battery_height +battery_compartment_buffer +disk_thickness +thickness)
        {
            translate([d/2, 0, -h/2 -disk_thickness])
            cube([d, d, h+tol], center=true);
        }

        // remove a small hole on the back of battery rim to give access for pushing out the battery
        let(d = battery_diameter+2*thickness,
            h = battery_count*battery_height,
            dx = -(battery_diameter+thickness/2),
            dz = -h/2 -disk_thickness)
        {
            translate([dx, 0, dz])
            cube([d, d, h+tol], center=true);
        }

        // when there are more than one batteries, we only want the outer leg of led to contant the last battery
        // so here we carve out a gap to let the led leg to out and come back at the different height
        let(gap= (battery_count - 0.20) * battery_height)
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

// main body
let(battery_diameter=lr44_diameter,
    battery_height=lr44_thickness,
    battery_count=battery_count)
{
    color("DarkOrange")
    led_and_battery_holder(battery_height, battery_diameter, battery_count);
}
// batter isolation disk
let(battery_diameter=lr44_diameter,
    battery_height=lr44_thickness)
{
    color("LimeGreen")
    translate([0, 0, -disk_thickness/2])
    battery_isolate_disk(battery_height, battery_diameter);
}

// led and battery for visualization
let(){
    led(clr="DarkRed", include_legs=false);
    for (i =[0:battery_count-1]){
        dz = - (i*lr44_thickness +lr44_thickness/2 + disk_thickness);
        formfactor_lr44(tran=[0, 0, dz]);
    }
}