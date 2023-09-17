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
width = 100;

filename = "/home/saeed/code/3d_models/stencils/designs/drawing_01.svg";

module bottom_plate(width, thickness){
  difference(){
    cube(size=[width, width, thickness], center=true);

    color("red", 1.0)
      translate([-(width-thickness+tol)/2, -(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([(width-thickness+tol)/2, +(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([-(width/4+tol), (width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
    
    color("red", 1.0)
      translate([(width/4+tol), -(width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
  }
}

module plate(width, thickness){
  difference(){
    cube(size=[width, width, thickness], center=true);

    color("red", 1.0)
      translate([-(width-thickness+tol)/2, width/4+tol, 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([(width-thickness+tol)/2, -(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([-(width/4+tol), -(width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
  }
}

module plate_stenciled(width, thickness, file_name){
  difference(){
    plate(width, thickness);
    linear_extrude(3*thickness, center=true)
      import(file=file_name, center=true, $fn=fragments);
  }
}

translate([0, -width/2+thickness/2, width/2])
rotate([90, 0, 0])
plate_stenciled(width, thickness, filename);

rotate([0, 0, 90])
translate([0, -width/2+thickness/2, width/2])
rotate([90, 0, 0])
plate_stenciled(width, thickness, filename);

rotate([0, 0, 180])
translate([0, -width/2+thickness/2, width/2])
rotate([90, 0, 0])
plate_stenciled(width, thickness, filename);

rotate([0, 0, 270])
translate([0, -width/2+thickness/2, width/2])
rotate([90, 0, 0])
plate_stenciled(width, thickness, filename);

translate([0, 0, thickness/2])
bottom_plate(width, thickness);
