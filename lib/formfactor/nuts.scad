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

use <shapes.scad>


// Returns form factor of a nut, i.e. a hexagon extruded along z-axis
module formFactorNut(outer_radius, inner_radius, height)
{
    difference(){
        color("Red", 1.0)
        linear_extrude(height=height, center=false)
        regularPolygon(order=6, radius=outer_radius, height=height);
        
        color("Gray", 1.0)
        translate([0, 0, -tol])
        cylinder($fn=30, h=height+2*tol, r=inner_radius, center=false);
    }    
}

// Returns one kind of M4 Nut, with the center whole filled
module formFactorNutM4Filled(outer_width, height)
{
    color("Red", 1.0)
    linear_extrude(height=height, center=false)
    regularPolygon(order=6, radius=outer_width/2, height=height);
}

// Returns one kind of M4 Nut
module formFactorNutM4(outer_width, height)
{
    formFactorNut(
        outer_radius=outer_width/2,
        inner_radius=4/2,
        height=height
    );
}

// examples
formFactorNutM4(outer_width=7, height=3);

color("Blue")
translate([0, 0, 5])
formFactorNutM4Filled(outer_width=7, height=3);
