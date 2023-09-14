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

difference(){
    union(){
        translate([0, 0, -wheel_flange_thickness/2])
        cylinder(h=wheel_flange_thickness+tol, d=wheel_flange_diameter, $fn=fragments, center=true);

        translate([0, 0, wheel_thickness/2])
        cylinder(h=wheel_thickness+tol, d=wheel_diameter, $fn=fragments, center=true);

        translate([wheel_peg_offset, 0, wheel_thickness+wheel_peg_height/2])
        cylinder(h=wheel_peg_height+tol, d=wheel_peg_diameter, $fn=fragments, center=true);
    }
    
    translate([0, 0, 0])
    cylinder(h=2*(wheel_flange_thickness+wheel_thickness+tol), d=shaft_diameter, $fn=fragments, center=true);
}