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

// plate thickness
thickness = 8;

// side plate dimensions
sp_width = 118;
sp_height = 880;

// bottom to plate dimensions
bp_width = 118;
bp_height = 120;


{

    // left plate
    // *
    %
    translate([-(bp_height+thickness)/2, 0, 0])
    rotate([90, 0, 90])
    cube(size = [sp_width, sp_height, thickness], center=true);

    // right plate
    // *
    %
    translate([+(bp_height+thickness)/2, 0, 0])
    rotate([90, 0, 90])
    cube(size = [sp_width, sp_height, thickness], center=true);

    // bottom plate
    // *
    %
    translate([0, 0, -(sp_height-thickness)/2])
    rotate([0, 0, 0])
    cube(size = [bp_height, bp_width, thickness], center=true);

    // top plate
    // *
    %
    translate([0, 0, +(sp_height-thickness)/2])
    rotate([0, 0, 0])
    cube(size = [bp_height, bp_width, thickness], center=true);
}


{
    // LED strip holder
    ls_thickness = 18;
    ls_width = 27.8;
    ls_height = 772.5;
    
    // light plate front
    %
    translate([0, 0, 0])
    rotate([0, 90, 90])
    cube(size = [ls_height, ls_width, ls_thickness], center=true);    
}

{
    lp_thickness = 1.5;
    lp_width = 40;
    lp_height = 785;
    
    // light plate front
    %
    translate([0, (ls_thickness+lp_thickness)/2, 0])
    rotate([0, 90, 90])
    cube(size = [lp_height, lp_width, lp_thickness], center=true);
    
    // light plate back
    %
    translate([0, -(ls_thickness+lp_thickness)/2, 0])
    rotate([0, 90, 90])
    cube(size = [lp_height, lp_width, lp_thickness], center=true);

}
    





