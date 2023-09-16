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

module octagon_ring(diameter, height, thickness){
    x_outer = (diameter+thickness) * sqrt(2) / 2;
    x_inner = (diameter-thickness) * sqrt(2) / 2;

  	difference(){
  	  union(){
  	    rotate([0, 0, 45])
  	      cube(size=[x_outer, x_outer, height], center=true);
  	    cube(size=[x_outer, x_outer, height], center=true);
  	  }
  	  union(){
  	    rotate([0, 0, 45])
  	      cube(size=[x_inner, x_inner, height+tol], center=true);
  	    cube(size=[x_inner, x_inner, height+tol], center=true);
  	  }
  	}
}

module circle_ring(diameter, height, thickness){
	  difference(){
	      cylinder(h=height, d=diameter+thickness, center=true, $fn=fragments);
	      cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fragments);
	  }
}

module square_ring(diameter, height, thickness){
    x_outer = (diameter+thickness) * sqrt(2) / 2;
    x_inner = (diameter-thickness) * sqrt(2) / 2;
	  rotate([0, 0, 45])
	  difference(){
	      cube(size=[x_outer, x_outer, height], center=true);
	      cube(size=[x_inner, x_inner, height+tol], center=true);
	  }
}
