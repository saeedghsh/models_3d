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
alpha_1 = 1.0;
alpha_0_5 = 0.5;

// cocraft linear clamp 150mm
// ignoring the rounded corners and approximating the whole pad with a box/cube
pad_width = 24 + 0.5;
pad_length = 37.3;
pad_height = 8.0 + 0.2;
pad_connect_width = 15.3 + 0.2;
pad_connect_length = pad_length;
pad_connect_height = 2;

// base
base_width = 60;
base_lengh = 16;
base_height = pad_length- tol;  // 50;

// for the corner and wedge
clamp_width = base_width;
clamp_lengh = base_width / 2;
clamp_height = base_height;

module cocraft_pad(){
    color("CornflowerBlue", alpha_0_5)
    translate([0, -pad_connect_height+tol, 0])
    union(){
        let(x = pad_width,
            y = pad_length,
            z = pad_height)
        {
            translate([0, -z/2+tol, 0])
            rotate([90, 0, 0])
            cube([x, y, z+tol], center=true);
        }
        let(x = pad_connect_width,
            y = pad_connect_length,
            z = pad_connect_height)
        {
            translate([0, +z/2, 0])
            rotate([90, 0, 0])
            cube([x, y, z+tol], center=true);
        }
    }
}

module adapter() {
    color("IndianRed", alpha_1)
    let(x = base_width,
        y = base_lengh,
        z = base_height)
    {
        difference(){
            translate([0, -y/2, 0])
            cube([x, y+tol, z], center=true);
            cocraft_pad();
        }
    }
}

module corner(){
    color("DarkRed", alpha_1){
        adapter();
        let(x = clamp_width,
            y = clamp_lengh,
            z = clamp_height,
            dy = base_lengh)
        {
            translate([0, -y/2 - dy, 0])
            difference(){
                cube([x, y, z], center=true);

                d = y * sqrt(2);
                translate([0, -y/2, 0])
                rotate([0, 0, 45])
                cube([d, d, z+tol], center=true);
            }
        }
    }
}

module wedge(){
    color("DarkRed", alpha_1){
        adapter();
        let(x = clamp_width,
            y = clamp_lengh,
            z = clamp_height,
            dy = base_lengh)
        {
            translate([0, - dy, 0])
            difference(){
                d = y * sqrt(2);
                rotate([0, 0, 45])
                cube([d, d, z], center=true);

                translate([0, x/2, 0])
                cube([x, x, z+tol], center=true);
            }
        }
    }
}

translate([0, clamp_lengh + base_lengh, 0])
{
    cocraft_pad();
    wedge();
}

translate([0, -(clamp_lengh + base_lengh), 0])
rotate([0, 0, 180])
{
    cocraft_pad();
    corner();
}