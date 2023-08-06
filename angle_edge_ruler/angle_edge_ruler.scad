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
thickness = 3;
screw_radius = 2;
engrave_depth = 1.5;

module polar_tick_and_label(degree, radius, height){
  tick_width = 1;
  tick_length = 3;

  rotate([0, 0, degree])
    translate([0, radius, -height+tol])
    union(){
    // tick
    translate([-tick_width/2, 0, 0])
      linear_extrude(height=height)
      square([tick_width, tick_length]);
    
    // label
    translate([0, 1.5*tick_length, 0])
      linear_extrude(height=height)
      text(str(degree), size=6*tick_width, halign="center", valign="bottom");
  }
}

module half_cylinder(h, r)
{
  difference(){
    cylinder(h=h, r=r, center=true, $fn=fragments);
    
    translate([0, -r/2, 0])
      cube([2.2*r, r, 2*h], center=true);
  }
}

// protractor
r1 = 15;
r2 = 85;
r3 = 100;
protractor_width = r3 - r2;

// ruler fixure
ruler_width = 25;
ruler_length = 50;
ruler_thickness = 1;
ruler_hole_offset = 13.5;
ruler_hole_radius = 3.5;

// ---------------------------------------------------------------- ruler fixure
points_outer = [
		[-(ruler_width/2 + thickness), -(ruler_length-ruler_hole_offset)],	// A
		[-(ruler_width/2 + thickness), +ruler_hole_offset],			// B
		[0, r2],								// C
		[+(ruler_width/2 + thickness), +ruler_hole_offset],			// D
		[+(ruler_width/2 + thickness), -(ruler_length-ruler_hole_offset)],	// E
		];

points_inner = [
		[-ruler_width/2, -(ruler_length-ruler_hole_offset) -tol],	// L
		[-ruler_width/2, +ruler_hole_offset],			// M
		[+ruler_width/2, +ruler_hole_offset],			// N
		[+ruler_width/2, -(ruler_length-ruler_hole_offset) -tol],	// O
		];

difference(){
  // the fixure itself - the general arrow shape
  translate([0, 0, -(thickness+ruler_thickness)])
  linear_extrude(height=thickness+ruler_thickness)
    polygon(points_outer);

  // substract the place for ruler
  translate([0, 0, -ruler_thickness])
  difference(){
    linear_extrude(height=ruler_thickness+tol)
      polygon(points_inner);

    cylinder(h=2*ruler_thickness, r=ruler_hole_radius, center=true, $fn=fragments);
  }

  // substract the place for screw
  cylinder(h=3*thickness, r=screw_radius, center=true, $fn=fragments);
}


// ------------------------------------------------------------------ protractor
translate([0,0,-5*thickness]) // just to separate it from the ruler fixure
difference(){
  // protractor outline
  translate([0, 0, -thickness/2])
  union(){
    half_cylinder(h=thickness, r=r3);

    // bottom straight edge
    translate([0, -protractor_width/2, 0])
      cube([2*r3, protractor_width+tol, thickness], center=true);
  }
  
  // protractor cutout
  translate([0, 0, -thickness/2])
  difference(){
    half_cylinder(h=thickness+tol, r=r2);
    
    translate([0,-tol, 0])
      half_cylinder(h=thickness+2*tol, r=r1);
  }

  // screw
  translate([0, 0, -thickness/2])
  cylinder(h=4*thickness, r=screw_radius, center=true, $fn=fragments);

  // ticks and labels
  for (i = [-90:10:90]){
    polar_tick_and_label(degree=i, radius=r2-tol, height=engrave_depth);
  }
}
