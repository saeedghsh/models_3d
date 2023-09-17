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
fragments = 300;
x_displace = 80;

// lower plate
l_radius = 76 / 2;
l_height = 6;
// lower plate - hole
lh_radius = 19 / 2;
lh_height = 6;
difference()
{
     // lower plate
     translate([0, 0, l_height/2])
          cylinder(h=l_height, r=l_radius, center=true, $fn=fragments);
     // lower plate - hole
     translate([0, 0, lh_height/2 + tol])
          cylinder(h=lh_height, r=lh_radius, center=true, $fn=fragments);
}

// upper plate
u_radius = 76 / 2;
u_height = 23;
// upper plate - hole
uh_radius = 70 / 2;
uh_height = 20;
uh_dz = 3;
// upper plate - pin
up_radius = 6 / 2;
up_height = 6;
translate([x_displace, 0, up_height])
union(){
     difference(){
          // upper plate - outer
          translate([0, 0, u_height/2])
               cylinder(h=u_height, r=u_radius, center=true, $fn=fragments);
          // upper plate - hole
          translate([0, 0, uh_height/2 + uh_dz + tol])
               cylinder(h=uh_height, r=uh_radius, center=true, $fn=fragments);
     }
     translate([0, 0, -up_height/2 - tol])
          cylinder(h=up_height, r=up_radius, center=true, $fn=fragments);
}
