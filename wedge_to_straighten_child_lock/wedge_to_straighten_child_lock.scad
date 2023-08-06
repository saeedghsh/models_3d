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

alpha = 24.25;
x = 20.0 * cos(alpha);
y = 20.0 * sin(alpha);
h = 32.0;
points = [[0.0, 0.0],
	  [x, 0.0],
	  [x, y]];

module wedge()
{
  translate([-x/2, 0, -h/2])
    linear_extrude(height=h)
    polygon(points);
}

module slot()
{
  color("Red", alpha=0.5)
    cube(size=[10.0, 100.0, 4.0], center=true);
}

difference(){
  wedge();

  translate([0, 0, -10])
  slot();

  translate([0, 0, 10])
  slot();
}
