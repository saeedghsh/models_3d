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

// Returns form factor of a very simple screw
module formFactorScrew(radius, height, head_radius, head_height)
{    
    union(){
        // threaded part
        color("Green", 1.0)
        cylinder($fn=30, h=height, r=radius, center=false);
        
        // head part
        color("Green", 1.0)
        translate([0, 0, height-tol])
        cylinder($fn=30, h=head_height, r=head_radius, center=false);
    }    
}


// example of creating a M4 screw
formFactorScrew(radius=4/2, height=11.5, head_radius=7/2, head_height=2.5);
