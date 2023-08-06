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

/*
 _____   _
|  _  |_| |
|_| |     |
    |     |
    |___  |
        | |
        | |
        | |
        |_|
*/

points = [
     [0, 0],		// A
     [0, 10],		// B
     [11, 10],		// C
     [11, 0],		// D
     [14, 0],		// E
     [14, 10],		// F
     [18, 10],		// G
     [18, -30],		// H
     [11, -30],		// I
     /* [11, -10],	// J */
     /* [7, -10],	// K */
     [7, 7],		// L
     [3, 7],		// M
     [3, 0],		// N
     ];

points_2 = [
     [0, 0],		// A
     [0, 10],		// B
     [11, 10],		// C
     [11, 0],		// D
     ];

union(){
     linear_extrude(height = 65)
          polygon(points);

     translate([0, 0, -(5-tol)])
     linear_extrude(height = 5)
          polygon(points_2);

     translate([0, 0, 65-tol])
     linear_extrude(height = 5)
          polygon(points_2);

}
