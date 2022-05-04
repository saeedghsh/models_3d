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
         _   _
        | | | |
N       | | | |
        | | | |
   _   _| |_| |
M | |_|       |
L |___________|
   A B C D E F 
*/

A = 10;
B = 5;
C = 20;
D = 10;
E = 15;
F = 10;

L = 15;
M = 15;
N = 200;

points = [
     [0, 0], // 1
     [A+B+C+D+E+F, 0], // 2
     [A+B+C+D+E+F, L+M+N], // 3
     [A+B+C+D+E, L+M+N], // 4
     [A+B+C+D+E, L], // 5
     [A+B+C+D, L], // 6
     [A+B+C+D, L+M+N], // 7
     [A+B+C, L+M+N], // 8
     [A+B+C, L+M], // 9
     [A+B, L+M], // 10
     [A+B, L], // 11
     [A, L], // 12
     [A, L+M], // 13
     [0, L+M], // 14
     ];

{
     // cross section
     linear_extrude(height = 200)
          polygon(points);
}
