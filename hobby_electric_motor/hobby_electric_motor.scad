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
thickness = 2;
fragments = 300;

// ----------------------------------------------------------------------
battery_compartment_x = 57;
battery_compartment_y = 14;
battery_compartment_z = 14;

battery_contact_slip_x = 1;
battery_contact_slip_y = 4.5;
battery_contact_slip_z = 10* thickness;

armature_holder_height = 15;
armature_holder_width = 4;

armature_shaft_diameter = 0.8*thickness;
armature_shaft_length = 60;
armature_inner_diameter = 12.5;

module armature(){
  difference(){
    rotate([0, 90, 0])
    cylinder(h=armature_shaft_length, d=armature_shaft_diameter, center=true, $fn=fragments);

    cylinder(h=2*thickness, d=armature_inner_diameter+thickness-tol, center=true, $fn=fragments);
  }
  difference(){ 
    cylinder(h=2*thickness, d=armature_inner_diameter+thickness, center=true, $fn=fragments);
    cylinder(h=2*thickness+tol, d=armature_inner_diameter, center=true, $fn=fragments);
  }
}

module armature_holder(){
  translate([0, 0, armature_holder_height-2*tol])
  difference(){
    translate([0, 0, -armature_holder_height/2])
    cube([thickness,
          armature_holder_width,
          armature_holder_height], center=true);

    rotate([0, 90, 0])
    cylinder(h=2*thickness, r=0.9*thickness, center=true, $fn=fragments);
  }
}

module battery_compartment(){
  difference(){
    translate([0, 0, -(battery_compartment_z + thickness)/2])
    cube([battery_compartment_x +2*thickness,
          battery_compartment_y +2*thickness,
          battery_compartment_z +thickness], center=true);

    translate([0, 0, -battery_compartment_z/2 + tol])
    cube([battery_compartment_x,
          battery_compartment_y,
          battery_compartment_z], center=true);

    translate([(battery_compartment_x-battery_contact_slip_x)/2, 0, -battery_contact_slip_z/2])
      cube([battery_contact_slip_x,
            battery_contact_slip_y,
            battery_contact_slip_z], center=true);

    translate([-(battery_compartment_x-battery_contact_slip_x)/2, 0, -battery_contact_slip_z/2])
      cube([battery_contact_slip_x,
            battery_contact_slip_y,
            battery_contact_slip_z], center=true);
  }
}

battery_compartment();

translate([(battery_compartment_x+thickness)/2, 0, -tol])
armature_holder();

translate([-(battery_compartment_x+thickness)/2, 0, -tol])
armature_holder();

translate([0, 0, armature_holder_height])
armature();
