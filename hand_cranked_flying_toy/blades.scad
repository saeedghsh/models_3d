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

blades_height = 5;
blades_outer_radius = 50;
blades_shaft_radius = 7/2;

blades_count = 3;

module blade(angle){
    length = blades_outer_radius - thickness;
    rotate([0, 0, angle])
    translate([blades_outer_radius/2, 0, 0])    
    difference(){
        rotate([45, 0, 0])    
        cube([length, sqrt(2) * blades_height, thickness], center=true);

        translate([0, 0, (blades_height+thickness)/2])
        cube([length+tol, sqrt(2) * blades_height, thickness], center=true);
        translate([0, 0, -(blades_height+thickness)/2])
        cube([length+tol, sqrt(2) * blades_height, thickness], center=true);
    }
}

module blades(){
    translate([0, 0, blades_height/2])
    union(){
        difference(){
            cylinder(h=blades_height, r=blades_outer_radius, center=true, $fn=fragments);
            cylinder(h=blades_height+tol, r=blades_outer_radius-thickness, center=true, $fn=fragments);
        }
        cylinder(h=blades_height, r=blades_shaft_radius, center=true, $fn=fragments);
        for (i=[0:blades_count]){
            blade(i * 360/blades_count);
        }
    }
}

interlock_height = 7;
interlock_radius = 2.4/2;
interlock_peg_radius = 1;
interlock_peg_legth = 3;
interlock_peg_offset_from_top = 2.5;

module interlock(){
    union(){
        translate([0, 0, -interlock_height/2])
        cylinder(h=interlock_height, r=interlock_radius, center=true, $fn=fragments);

        translate([0, 0, -interlock_peg_offset_from_top])
        rotate([90, 0, 0])
        cylinder(h=2*(interlock_peg_legth+interlock_radius), r=interlock_peg_radius, center=true, $fn=fragments);
    }
}

translate([0, 0, -tol]) 
interlock();
blades();