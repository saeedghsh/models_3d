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
use <../lib/nuts.scad>
use <../lib/screws.scad>
use <../lib/splitter.scad>
use <../lib/extrude_directional.scad>

/******************************************************************************/
// Adding some tolerance for safety and better visual rendering
tol = 0.01;

/******************************************************************************/
module myCylinder(height, bottom_diameter, top_diameter, tranlation, clr)
{
    // this module returns an cylinder
    translate(tranlation)
    color(clr, 1.0)
    cylinder(h=height, d1=bottom_diameter, d2=top_diameter, center=false);
}

module cocraftHandle()
{
    // top cylinder
    top_clr = "Red";
    top_height = 20 + tol;
    top_bottom_diameter = 19.5;
    top_top_diameter = 17.5;
    top_tranlation = [0, 0, 88];

    // middle cylinder
    mid_clr = "Green";
    mid_height = 39 + tol;
    mid_bottom_diameter = 19.5;
    mid_top_diameter = 19.5;
    mid_tranlation = [0, 0, 49];

    // bottom cylinder
    bot_clr = "Blue";
    bot_height = 49 + tol;
    bot_bottom_diameter = 13;
    bot_top_diameter = 15;
    bot_tranlation = [0, 0, 0];
    
    union(){
        myCylinder(top_height, top_bottom_diameter, top_top_diameter,
                   top_tranlation, top_clr);
        myCylinder(mid_height, mid_bottom_diameter, mid_top_diameter,
                   mid_tranlation, mid_clr);
        myCylinder(bot_height, bot_bottom_diameter, bot_top_diameter,
                   bot_tranlation, bot_clr);
    }
}

module gripBox(size, tranlation, clr)
{
    // this module returns an cylinder
    translate(tranlation)
    color(clr, 1.0 )
    cube(size = cube_size, center = true);
}

module nutAndBolt(top, left)
{
    nut_x_offset = 3;
    y_offset = 15;
    scale_factor = 1.05;
    
    tz = top ? 100 : 10;
    ty = left ? y_offset : -y_offset;
    
    color("Red")
    translate(v=[nut_x_offset, ty, tz])
    extrude_along_y(length= left ? (5+tol) : -(5+tol) )
    rotate(a=[90, 0, 90])
    scale(scale_factor)
    formFactorNutM4Filled(outer_width=7, height=3);

    translate(v=[nut_x_offset+3, ty, tz])
    rotate(a=[0, -90, 0])
    scale(scale_factor)
    formFactorScrew(radius=4/2, height=11.5, head_radius=7/2, head_height=34);
}

module nutsAndBolts()
{
    union()
    {
        nutAndBolt(top=false, left=false);
        nutAndBolt(top=false, left=true);
        nutAndBolt(top=true, left=false);
        nutAndBolt(top=true, left=true);
    }
}

module topPlate()
{
    color("Yellow")
    translate(v=[9, 0, 50])
    cube(size = [2, 150, 200], center = true);
}

module sawSlot()
{
    color("Red")
    translate(v=[9, 0, 108+28])
    cube(size = [5, 40, 3], center = true);
}

/******************************************************************************/
// cube
cube_size = [40, 40, 108 - 2 * tol];
cube_clr = "Yellow";
cube_tranlation = [-10, 0, cube_size[2]/2 + tol];

cube(size = [1, 1, 1], center = true);

#split_along_yz(max_size=400, offset=1)
union()
{
    // top plate
    difference()
    {
        topPlate();
        // cut out the gripBox to leave the inside cylindar untouched
        gripBox(cube_size, cube_tranlation, cube_clr);
        sawSlot();
    }

    // the gripping box
    difference(){
        gripBox(cube_size, cube_tranlation, cube_clr);
        cocraftHandle();
        nutsAndBolts();
    }
}
