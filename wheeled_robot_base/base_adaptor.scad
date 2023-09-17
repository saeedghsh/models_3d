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
use <castor_wheel.scad>

module base_adaptor(){
    // bottom plate
    difference(){
        translate([base_dx/2, 0, -thickness/2])
        cube([base_dx, base_dy, thickness], center=true);

        translate([base_dx - castor_wheel_ball_diameter, 0, 0])
        castor_wheel_screw_holes();
    }

    // front clip
    front_clip_thickness = 3* thickness;
    difference(){
        translate([front_clip_thickness/2, 0, base_clip_height/2 -2*tol])
        cube([front_clip_thickness, base_dy, base_clip_height], center=true);

        // remove notch
        translate([front_clip_thickness, 0, base_front_clip_notch_height]) 
        rotate([90, 0, 0])
        cylinder(h=base_dy+tol, d=base_front_clip_notch_diameter, center=true, $fn=fragments);

        // remove some above the notch to allow easy slide
        translate([front_clip_thickness/2, 0, front_clip_thickness/2 + 0.7*base_clip_height])
        cube([front_clip_thickness+tol, base_dy+tol, front_clip_thickness], center=true);
    }

    // back clip
    translate([thickness/2 + base_clip_dx +front_clip_thickness, 0, base_clip_height/2 -2*tol])
    cube([thickness, base_dy, base_clip_height], center=true);
}

base_adaptor();