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

module castor_wheel_screw_holes(){
    translate([castor_wheel_ball_diameter/2 +thickness/2, castor_wheel_ball_diameter/2 +thickness/2, 0]) 
    cylinder(h=4*thickness, d=screw_diameter, center=true, $fn=fragments);
    translate([-(castor_wheel_ball_diameter/2 +thickness/2), castor_wheel_ball_diameter/2 +thickness/2, 0]) 
    cylinder(h=4*thickness, d=screw_diameter, center=true, $fn=fragments);
    translate([castor_wheel_ball_diameter/2 +thickness/2, -(castor_wheel_ball_diameter/2 +thickness/2), 0]) 
    cylinder(h=4*thickness, d=screw_diameter, center=true, $fn=fragments);
    translate([-(castor_wheel_ball_diameter/2 +thickness/2), -(castor_wheel_ball_diameter/2 +thickness/2), 0]) 
    cylinder(h=4*thickness, d=screw_diameter, center=true, $fn=fragments);
}

module castor_wheel(){
    translate([0, 0, -castor_wheel_ball_diameter/2])
    union(){
        difference(){
            sphere(d=castor_wheel_ball_diameter +2*thickness, $fn=fragments);
            sphere(d=castor_wheel_ball_diameter, $fn=fragments);

            // cut off top half of the sphere
            translate([0, 0, castor_wheel_ball_diameter/2 +thickness])
            cube(size=castor_wheel_ball_diameter +2*thickness +tol, center=true);

            // cut out bottom for floor contact
            translate([0, 0, -3*castor_wheel_ball_diameter/4 -1.5 *thickness])
            cube(size=castor_wheel_ball_diameter +2*thickness +tol, center=true);
        }

        // top cylinder
        translate([0, 0, castor_wheel_ball_diameter/4 -tol])
        difference(){
            cylinder(h=castor_wheel_ball_diameter/2, d=castor_wheel_ball_diameter+ 2*thickness, center=true, $fn=fragments);
            cylinder(h=castor_wheel_ball_diameter/2+tol, d=castor_wheel_ball_diameter, center=true, $fn=fragments);
        }

        // top plate
        translate([0, 0, castor_wheel_ball_diameter/2 -thickness/2])
        difference(){
            cube([castor_wheel_ball_diameter+ 4*thickness, castor_wheel_ball_diameter+ 4*thickness, thickness], center=true);
            cylinder(h=castor_wheel_ball_diameter/2+tol, d=castor_wheel_ball_diameter, center=true, $fn=fragments);

            // screw holes
            castor_wheel_screw_holes();
        }
    }

    translate([0, 0, +thickness])
    difference(){
        cube([castor_wheel_ball_diameter+ 4*thickness, castor_wheel_ball_diameter+ 4*thickness, thickness], center=true);
        castor_wheel_screw_holes();
    }
}

castor_wheel();