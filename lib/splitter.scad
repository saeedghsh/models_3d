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
use <extrude_directional.scad>

// Retuns a split of the object[s], cut by the yz plane
// If offset is set, the split parts are spaced accordingly for better visual
module split_along_yz(max_size, offset=0)
{
    // split along x=0
    union(){
        // positive side
        translate([offset, 0, 0])
        intersection()
        {
            translate([max_size/2, 0, 0])
            cube(max_size, true);
            children();
        }
        
        // negative side
        translate([-offset, 0, 0])
        intersection()
        {
            translate([-max_size/2, 0, 0])
            cube(max_size, true);
            children();
        }
    }    
}

// examples
%split_along_yz(max_size=20, offset=1)
toy_example(size=5);
