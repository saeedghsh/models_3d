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
include <battery_measurement.scad>
tol = 0.01;
fragments = 300;

module formfactor_aaa(tran=[0, 0, 0], rot=[0, 0, 0]){
    translate(tran)
    rotate(rot)
    union(){
        cylinder(h=aaa_body_length, d=aaa_body_diameter, center=true, $fn=fragments);
        translate([0, 0, (aaa_body_length+aaa_tip_length)/2])
            cylinder(h=aaa_tip_length, d=aaa_tip_diameter, center=true, $fn=fragments);
    }
}

module formfactor_aaa_holder(tran=[0, 0, 0], rot=[0, 0, 0], clr="gray"){
    color(clr)
    translate(tran)
    rotate(rot)
    difference(){
        cube([aaa_holder_width, aaa_holder_length, aaa_holder_height], center=true);

        translate([0, 0, aaa_holder_thickness+tol])
            cube([aaa_holder_width-2*aaa_holder_thickness,
                  aaa_holder_length-2*aaa_holder_thickness,
                  aaa_holder_height-aaa_holder_thickness+tol], center=true);

        translate([0, 0, aaa_holder_notch_height])
            cube([1.5* aaa_holder_width, aaa_holder_notch_width, aaa_holder_height], center=true);
    }

}

module aaa_holder_grip(tran, rot, thickness){
    translate(tran)
    rotate(rot)
    let(thickness=thickness,
        wall_height = aaa_holder_notch_height,
        wall_width = aaa_holder_notch_width,
        notch_depth = aaa_holder_thickness,
        holder_width = aaa_holder_width)
    {
        union(){
            translate([0, 0, thickness/2])
                cube(size=[holder_width+2*thickness, wall_width, thickness], center=true);
            translate([(holder_width+thickness)/2, 0, wall_height -thickness/2 -tol])
                cube(size=[thickness, wall_width, wall_height], center=true);
            translate([-(holder_width+thickness)/2, 0, wall_height -thickness/2 -tol])
                cube(size=[thickness, wall_width, wall_height], center=true);
            translate([-(holder_width+thickness)/2 +notch_depth/2, 0, wall_height +1.5*thickness -tol])
                cube(size=[thickness+notch_depth, wall_width, thickness], center=true);
            translate([(holder_width+thickness)/2 -notch_depth/2, 0, wall_height +1.5*thickness -tol])
                cube(size=[thickness+notch_depth, wall_width, thickness], center=true);
        }
    }
}