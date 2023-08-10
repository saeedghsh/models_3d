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
thickness = 1;
fragments = 300;

ballbearing_outer_raduis = 24.3 / 2;
ballbearing_inner_raduis = 15.2 / 2;
ballbearing_height = 5;

// ---------------------------------------------------------------------- center
// bottom part
translate([130, 0, 0]) // just to separete parts
union(){
  // plate
  translate([0, 0, -thickness/2])
    cylinder(h=thickness, r=ballbearing_outer_raduis, center=true, $fn=fragments);

  // plug
  translate([0, 0, ballbearing_height/2 - tol]) // goes into top part
    cylinder(h=ballbearing_height, r=ballbearing_inner_raduis/2 - 5*tol, center=true, $fn=fragments);
}

translate([100, 0, 0]) // just to separete parts
// top part
union(){
  // plate
  translate([0, 0, -thickness/2])
    cylinder(h=thickness, r=ballbearing_outer_raduis, center=true, $fn=fragments);

  // plug with hold
  difference(){
    translate([0, 0, ballbearing_height/2 - 3*tol]) // goes into ballbearing
      cylinder(h=ballbearing_height, r=ballbearing_inner_raduis-5*tol, center=true, $fn=fragments);

    translate([0, 0, ballbearing_height/2 + tol]) // the bottom part goes into it
      cylinder(h=ballbearing_height, r=ballbearing_inner_raduis/2 - tol, center=true, $fn=fragments);

  }
}


// --------------------------------------------------------------------- spinner
peg_inner_radius = 1;
peg_outer_radius = 2;
peg_depth = 2 * thickness;

spinner_height = ballbearing_height + 2*thickness;
spinner_raduis = 50;

screw_radius = 2.8/2;
screw_length = 8;
screw_head_radius = 5.3/2;
screw_head_length = 2;


module peg_holes(count, hole_radius, hole_depth, separation_radius){
  step = 360 / count;
  for (degree=[0: step: 360-1]){
    rotate([0, 0, degree])
      translate([separation_radius, 0, -hole_depth/2 + tol])
      cylinder(h=hole_depth+tol, r=hole_radius+tol, center=true, $fn=fragments);
  }
}

module screw(radius, length, head_length, head_radius){
  union(){
    // head
    translate([0, 0, -head_length/2])
      cylinder(h=head_length, r1=radius, r2=head_radius, center=true, $fn=fragments/3);

    // body
    translate([0, 0, -length/2 - head_length + tol])
      cylinder(h=length, r=radius, center=true, $fn=fragments/3);
  }
}

module distribute_screws(count, separation_radius){
  step = 360 / count;
  for (degree=[0: step: 360-1]){
    rotate([0, 0, degree])
      translate([separation_radius, 0, 0])
      rotate([0, 90, 0])
      screw(radius=screw_radius,
	    length=screw_length,
	    head_length=screw_head_length,
	    head_radius=screw_head_radius);
  }
}


// pegs
union(){
  translate([0, 0, -peg_depth/2])
      cylinder(h=peg_depth, r=peg_inner_radius, center=true, $fn=fragments);

  translate([0, 0, peg_depth/2 - tol])
    cylinder(h=peg_depth, r=peg_outer_radius, center=true, $fn=fragments);
}

// spinner
difference(){
  
  // disk
  translate([0, 0, -spinner_height/2])
    cylinder(h=spinner_height, r=spinner_raduis, center=true, $fn=fragments);

  // buffer - top
  translate([0, 0, -thickness/2])
    cylinder(h=thickness+tol, r=ballbearing_outer_raduis+thickness/2, center=true, $fn=fragments);

  // buffer - bottom
  translate([0, 0, -spinner_height])
    cylinder(h=thickness+tol, r=ballbearing_outer_raduis+thickness/2, center=true, $fn=fragments);

  // remove ballbearing
  translate([0, 0, -spinner_height/2])
    cylinder(h=spinner_height+tol, r=ballbearing_outer_raduis+tol, center=true, $fn=fragments);

  // remove peg holes
  peg_holes(count=3,
	    hole_radius=peg_inner_radius,
	    hole_depth=spinner_height + tol,
	    separation_radius=spinner_raduis-peg_outer_radius);

  // remove screw holes
  translate([0, 0, -spinner_height/2])
    distribute_screws(count=50, separation_radius=spinner_raduis+tol);
}


