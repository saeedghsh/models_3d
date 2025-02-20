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

fragments = 300;
tol = 0.1;

thickness = 2;
adhesive_tape_x = 15;
adhesive_tape_y = 22;
adhesive_tape_z = 1;

hanger_plate_x = adhesive_tape_x;
hanger_plate_y = adhesive_tape_y;
hanger_plate_z = thickness;
hanger_peg_height = 3;
hanger_peg_diameter = 5;

// plate
let(x = hanger_plate_x,
    y = hanger_plate_y,
    z = hanger_plate_z)
{
    translate([0,0, z/2]) 
    cube(size = [x, y, z], center=true);
}

// peg
let(h = hanger_peg_height,
    d = hanger_peg_diameter,
    dz = hanger_plate_z - tol,
    scale = 0.5)
{
    translate([0, 0, dz])
    {
        linear_extrude(height = h, scale = scale, $fn=fragments)
        circle(d = d);
    
        linear_extrude(height = h, scale = 1/scale, $fn=fragments)
        circle(d = d * scale);
    
    }
}
