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

tol = 0.02;
thickness = 2.0;
fragments = 300;
inner_diameter = 13.0;

outer_size = inner_diameter + 2 * thickness;

difference(){
  union(){
    color("Green", 1.0)
      cylinder(h=outer_size, d=outer_size, $fn=fragments, center=true);
    
    color("Green", 1.0)
      translate([0, outer_size/4, 0])
      cube(size = [outer_size, outer_size/2 , outer_size], center=true);
  }

  color("Red", 1.0)
    cylinder(h=outer_size+tol, d=inner_diameter, $fn=fragments, center=true);  
}
