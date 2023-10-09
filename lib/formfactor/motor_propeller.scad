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
include <motor_propeller_measurement.scad>
tol = 0.01;
fragments = 300;

module _formfactor_propeller(radius, width, thickness){
    union(){
        translate([0, 0, 2*thickness])
        cylinder(h=4*thickness, r1=width/2, r2=width/4, center=true, $fn=fragments);

        translate([radius/2, 0, thickness/2])
        scale([radius/2, width/2, 1])
        cylinder(h=thickness, r=1, center=true, $fn=fragments);

        translate([-radius/2, 0, thickness/2])
        scale([radius/2, width/2, 1])
        cylinder(h=thickness, r=1, center=true, $fn=fragments);
    }
}

module formfactor_propeller(size="small"){
    if (size == "small"){
        let(radius=small_propeller_length/2,
            width=small_propeller_width,
            thickness=small_propeller_thickness)
        {_formfactor_propeller(radius, width, thickness);}
    } else if (size == "big"){
        let(radius=big_propeller_length/2,
            width=big_propeller_width,
            thickness=big_propeller_thickness)
        {_formfactor_propeller(radius, width, thickness);}
    }
}

module formfactor_motor_and_propeller(tran=[0, 0, 0], rot=[0, 0, 0]){
    translate(tran)
    rotate(rot)
    union(){
        // motor
        color("Silver")
        cylinder(h=motor_body_length, d=motor_body_diameter, center=true, $fn=fragments);
        color("DimGray")
        translate([0, 0, (motor_body_length+motor_shaft_length)/2])
            cylinder(h=motor_shaft_length, d=motor_shaft_diameter, center=true, $fn=fragments);

        // propeller
        color("LightSlateGray")
        translate([0, 0, motor_body_length/2 + motor_shaft_length -small_propeller_thickness/2])
            formfactor_propeller(size="small");
    }
}

module add_dc_motor_holder(motor_body_diameter, motor_body_length, dx, dy, thickness){
    motor_holder_height = 0.5 * motor_body_length;
    difference(){
        union(){
            children();

            translate([dx, dy, 0])
            cylinder(h=motor_holder_height, d=motor_body_diameter+2*thickness, center=true, $fn=fragments);
        }
        translate([dx, dy, 0])
        cylinder(h=motor_holder_height+tol, d=motor_body_diameter, center=true, $fn=fragments);
    }
}