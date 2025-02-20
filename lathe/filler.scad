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

// TODO: WIP

// TODO: start with drawing quadrant
// along x (y-z plane): q1, q2, q3, q4
// along y (z-x plane): q1, q2, q3, q4
// along z (x-y plane): q1, q2, q3, q4

module fillet(radius, length, position, quadrant, along_axis){
    intersection(){
        difference(){
            cube([2*radius, 2*radius, length], center=true);

            cylinder(h=length+tol, r=radius, center=true, $fn=fragments);
        }
        translate([radius/2, radius/2, 0])
        cube([radius, radius, length], center=true);
    }
}

module position_fillet(position, quadrant){
    if      (quadrant==1){
        rotate([0, 0, 0])
        translate(position)
        children();
    }
    else if (quadrant==2){
        rotate([0, 0, 90])
        translate(position)
        children();
    }
    else if (quadrant==3){
        rotate([0, 0, 180])
        translate(position)
        children();
    }
    else if (quadrant==4){
        rotate([0, 0, 270])
        translate(position)
        children();
    }
    else {
        echo("Wrong direction key");
    }
}

module align_fillet_along_axis(axis){
    if (axis == "x"){
        // y-z
        rotate([90, 0, 90])
        children();
    }
    else if (axis == "y"){
        // z-x
        rotate([90, 0, 0])
        children();
    }
    else if (axis == "z"){
        // x-y
        rotate([0, 0, 0])
        children();
    }
    else{
        echo("Wrong axis key");
    }
}

align_fillet_along_axis(axis="y")
position_fillet(position=[0, 0, 0], quadrant=1)
fillet(radius = 10, length = 5);
