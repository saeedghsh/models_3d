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

use <../lib/shapes.scad>
use <../lib/splitter.scad>

tol = 0.2;
thickness = 5;
height = 60;
radius = 20;
slices = 5; // number of intermediate points along the Z axis of the extrusion
num_faces = 20; // no effect when slice is specified!?
twist = 45;
convexity = 10;
s = 1; // will scale the top of the extrude wrt bottom (making cone or funnel shapes)

color_alpha = 0.9;

split_along_yz(max_size=2*height, offset=5)
rotate([0,0,90])
split_along_yz(max_size=2*height, offset=5)
difference(){
     // mold body
     color("Blue", color_alpha)
          translate([0, 0, -thickness])
          cube([2*(radius+thickness), 2*(radius+thickness), height+thickness-tol], center=true);
     
     // candle shape
     color("Red", color_alpha)
     linear_extrude(
          height=height,
          center=true,
          convexity=convexity,
          twist=twist,
          slices=slices,
          scale=s,
          $fn=num_faces
          )
          regularPolygon(order=8, radius=radius);
}
