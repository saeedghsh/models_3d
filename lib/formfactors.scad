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

tol = 0.01;
fragments = 300;

// AAA (GP super alkaline)
aaa_weight = 11.5; // gr
aaa_body_diameter = 10.3; // mm
aaa_body_length = 44.1; // mm
aaa_tip_diameter = 3.5; // mm
aaa_tip_length = 1; // mm

module formfactor_aaa(tran=[0, 0, 0], rot=[0, 0, 0]){
    translate(tran)
    rotate(rot)
    union(){
        cylinder(h=aaa_body_length, d=aaa_body_diameter, center=true, $fn=fragments);
        translate([0, 0, (aaa_body_length+aaa_tip_length)/2])
            cylinder(h=aaa_tip_length, d=aaa_tip_diameter, center=true, $fn=fragments);
    }
}

// AAA battery holder (from kjell)
aaa_holder_weight = 2.5; // gr
aaa_holder_thickness = 1;
aaa_holder_length = 50.5; // mm
aaa_holder_width = 13; // mm
aaa_holder_height = 12; // mm
aaa_holder_notch_height = 6; // mm
aaa_holder_notch_width = 15; // mm

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

// motors from quadrocopter
motor_weight = 5; // gr
motor_body_diameter = 8.5; // mm
motor_body_length = 20; // mm
motor_shaft_diameter = 1; // mm
motor_shaft_length = 5; // mm
propeller_length = 55 + 1; // mm
propeller_width = 8; // mm
propeller_thickness = 1; // mm

module formfactor_propeller(radius, width, thickness=1){
    union(){
        translate([0, 0, 2*thickness])
            cylinder(h=4*thickness, r1=propeller_width/2, r2=propeller_width/4, center=true, $fn=fragments);

        translate([propeller_length/4, 0, thickness/2])
        scale([propeller_length/4, propeller_width/2, 1])
            cylinder(h=thickness, r=1, center=true, $fn=fragments);

        translate([-propeller_length/4, 0, thickness/2])
        scale([propeller_length/4, propeller_width/2, 1])
            cylinder(h=thickness, r=1, center=true, $fn=fragments);
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
        translate([0, 0, motor_body_length/2 + motor_shaft_length -propeller_thickness/2])
            formfactor_propeller(radius=propeller_length/2, width=propeller_width, thickness=propeller_thickness);
    }
}