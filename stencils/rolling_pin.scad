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

big_wheel_height = 5.0;
big_wheel_diameter = 39.0;

small_wheel_height = 10.0;
small_wheel_diameter = 13.0 - 1.0;

shaft_diameter = 9.4;

// an adaptor to fit the sticky roll ends and fit the 
difference(){
    union(){
        let(h=big_wheel_height,
            d=big_wheel_diameter)
        {
            translate([0, 0, h/2])
            cylinder(h=h, d=d, center=true, $fn=fragments);
        }
        let(h=small_wheel_height,
            d=small_wheel_diameter,
            dz=big_wheel_height + small_wheel_height/2)
        {
            translate([0, 0, dz-tol])
            cylinder(h=h, d=d, center=true, $fn=fragments);
        }
    }
    let(h=small_wheel_height +big_wheel_height +2*tol,
        d=shaft_diameter)
    {
        translate([0, 0, h/2-tol])
        cylinder(h=h, d=d, center=true, $fn=fragments);
    }
}