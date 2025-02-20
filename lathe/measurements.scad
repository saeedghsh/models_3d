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
alpha = 1.0;

// colors
fixture_color = "LightGrey";
coil_color = "SandyBrown";
armature_color = "DimGray";
armature_shaft_holder_color = "LightSlateGray";

// fixture outline
fixture_size_x = 16.3;
fixture_size_y = 60.0;
fixture_size_z = 60.0;

// fixture's armature hole
fixure_hole_diameter = 30.5;
fixure_hole_z_offset = 43.05; // fixture_size_z -fixure_hole_diameter/2 -1.7;

// coil
coil_size_x = 38.0;
coil_size_y = 31.5;
coil_size_z = 33.0;
coil_offset_z = 6.5; // 23 - coil_size_z/2;

// four small screw holes
screw_hole_1_diameter = 4.40;
screw_hole_1_y_offset = 24.2;
screw_hole_1_z_offset1 = 19.5;
screw_hole_1_z_offset2 = 28.5;

// two big screw holes
screw_hole_2_diameter = 6.60;
screw_hole_2_y_offset = 24.2;
screw_hole_2_z_offset = 43.0;

// armature
armature_center_diameter = 30.0;
armature_center_length = 21.2;

armature_shaft_diameter = 6.0;
armature_shaft_length = 127.2;
armature_shaft_offset = 18.1;

// armature shaft holder (all pre-rotation)
armature_shaft_holder_plate_thickness = 2.3;

armature_shaft_holder_plate_1_size_x = 12.0;
armature_shaft_holder_plate_1_size_y = 57.0;
armature_shaft_holder_plate_1_gap_y = 34.3;

armature_shaft_holder_screw_diameter = 4.5;
armature_shaft_holder_screw_y_offset = screw_hole_2_y_offset;

armature_shaft_holder_plate_2_size_x = armature_shaft_holder_plate_1_size_x;
armature_shaft_holder_plate_2_size_y = 38.2;
armature_shaft_holder_plate_2_z_offset = 4.9;

armature_shaft_holder_disk_thickness = 7.2;
armature_shaft_holder_disk_diameter = 20.3;
armature_shaft_holder_disk_hole_diameter = 6.2;

// control bottoms
bottom_box_size_x = 14;
bottom_box_size_y = 84;
bottom_box_size_z = 16.7;
