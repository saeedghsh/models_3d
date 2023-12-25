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
include <led_measurement.scad>
tol = 0.01;
fragments = 300;

module led(clr="red", include_legs=true, tran=[0, 0, 0], rot=[0, 0, 0]){
    translate(tran)
    rotate(rot)
    {
        // bulb
        color(c=clr, alpha=0.6)
        {
            translate([0, 0, led_rim_height/2])
            cylinder(h=led_rim_height, d=led_rim_diameter, center=true, $fn=fragments);
            translate([0, 0, led_rim_height + led_body_height/2])
            cylinder(h=led_body_height, d=led_body_diameter, center=true, $fn=fragments);
            translate([0, 0, led_rim_height+led_body_height])
            sphere(r=led_sphere_tip_radius, $fn=fragments);
        }
        // legs
        if (include_legs){
            color(c="DimGray", alpha=1.0)
            {
                // short leg
                translate([-led_leg_distance/2, 0, -led_short_leg_length/2])
                cube([led_leg_width, led_leg_width, led_short_leg_length], center=true);
                // long leg
                translate([+led_leg_distance/2, 0, -led_long_leg_length/2])
                cube([led_leg_width, led_leg_width, led_long_leg_length], center=true);
            }
        }
    }
}
