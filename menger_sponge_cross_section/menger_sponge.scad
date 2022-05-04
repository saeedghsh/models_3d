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

/******************************************************************************/
module construct_column_single(cube_size, base_size, tx, ty) {
    // this module returns an square extruded to cube
    // size = [base_size, base_size, cube_size]
    // translation of the center = [tx, ty]
    translate(v = [tx, ty, 0])
    linear_extrude(
        height=cube_size*1.01, center=true, convexity=10, twist=0, scale=1.0)
	square(size=base_size, center=true);
}

module construct_columns_full(cube_size, itr) {
    // returns all columns in all 3 directions at
    // note that by default they are "unioned"
    bs = cube_size / pow(3, itr); // base size
    for (tx=[-(cube_size/2)+1.5*bs:3*bs:(cube_size/2)-1.5*bs ]){
        for (ty=[-(cube_size/2)+1.5*bs:3*bs:(cube_size/2)-1.5*bs ]){
            union(){
                color( "Red", 1.0 )
                rotate(a=[0,0,0])
                construct_column_single(cube_size, bs, tx, ty);
            
                color("Orange", 1.0 )
                rotate(a=[90, 0, 0])
                construct_column_single(cube_size, bs, tx, ty);
            
                color("Yellow", 1.0 )
                rotate(a=[0, 90, 0])
                construct_column_single(cube_size, bs, tx, ty);
            }
        }
    }
}

module menger_sponge(cube_size, itr_max) {
    // main loop
    difference()
    {
        color( "Green", 1.0 )
	    linear_extrude(height=cube_size, center=true, convexity=10, twist=0, scale=1.0)
        square(size=cube_size, center=true);
        for (itr=[1:1:itr_max]){
            construct_columns_full(cube_size, itr);
        }
     }
}

/******************************************************************************/
cube_size = 100;
itr_max=3; // depth of fractal steps
cross_section=[false, true][0]; // plot the cross-section or the full spong 

if (!cross_section){
     menger_sponge(cube_size, itr_max);
}
else
{
    intersection()
    {
        menger_sponge(cube_size, itr_max);
        color( "blue", 1.0 )
	    
	    rotate(a=[0,90-35.2643897,0])
	    linear_extrude(height=0.001)
	    square(size=2*cube_size, center=true);
    }
}


