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
fragments = 50;

// ---------------------------------------------------------------- bottom plate
pipe_outer_diameter = 18.1;
pipe_inner_diameter = 16.4;
pipe_holder_height = 40;
pipe_holder_diameter = pipe_outer_diameter + 2*thickness;

plate_width = 80 + 2*pipe_holder_diameter;
plate_hole_diameter = 50;
plate_height = 2*thickness;
pole_to_pole_distance = plate_width-pipe_holder_diameter;

module pipe(height){
  /* color("gray", alpha=0.5) */
  translate([0, 0, height/2])
    difference(){
    cylinder(h=height, d=pipe_outer_diameter, center=true, $fn=fragments);
    cylinder(h=height+tol, d=pipe_inner_diameter, center=true, $fn=fragments);
  }
}

module pipe_hold(holder_h, holder_d, with_inside)
{
  translate([0, 0, holder_h/2])
  union(){
    /* outer tube */
    difference(){
      cylinder(h=holder_h, d=holder_d, center=true, $fn=fragments);
      cylinder(h=holder_h+tol, d=pipe_outer_diameter, center=true, $fn=fragments);
    }
    
    /* inner tube */
    if(with_inside){
      cylinder(h=holder_h, d=pipe_inner_diameter-tol, center=true, $fn=fragments);
    }
  }
}

module plate(height, hole_d){
  difference(){
    translate([0, 0, -height/2])
      cube(size=[plate_width, plate_width, height], center=true);

    translate([0, 0, -height/2])
    cylinder(h=height+tol, d=hole_d, center=true, $fn=fragments);
  }
}


union(){
  %
  translate([pole_to_pole_distance/2, 0, 0])  
    pipe(height=100);
  %
  translate([-pole_to_pole_distance/2, 0, 0])
    pipe(height=100);

  color("blue")
  translate([pole_to_pole_distance/2, 0, 0])
    pipe_hold(holder_h=pipe_holder_height,
	      holder_d=pipe_holder_diameter,
	      with_inside=true);
  color("blue")
  translate([-pole_to_pole_distance/2, 0, 0])
    pipe_hold(holder_h=pipe_holder_height,
	      holder_d=pipe_holder_diameter,
	      with_inside=true);

  color("blue")
  translate([0, 0, tol])
    plate(height=plate_height, hole_d=plate_hole_diameter);
}


// ---------------------------------------------------------------- drill holder
/* measuremenst from the tip of the spindle */
/* different diameters leading to concatenated sliced cones*/
d1 = 50.0;
d2 = 52.0;
d3 = 56.0;
d4 = 58.0;
d5 = 59.0;
d6 = 71.0;

/* hieght of each cone */
h1 = 3.0;
h2 = 11.6;
h3 = 7.0;
h4 = 10.0;
h5 = 14.0;

trigger_w = 37.0;

spindle_cup_d = d6 + 4*thickness;
spindle_cup_h = h1 +h2 +h3 +h4 +h5 -thickness;

module spindle_cup()
{
  difference(){

    union(){
      translate([0, 0, -h5/2-tol])
	cylinder(h=h5, d=spindle_cup_d, center=true, $fn=fragments);
      
      translate([0, 0, -(spindle_cup_h-h5)/2 -h5+tol])
	cylinder(h=spindle_cup_h-h5, r1=(d1/2)+2*thickness, r2=spindle_cup_d/2, center=true, $fn=fragments);
    }

    /* rough model of the spindle of the drill */
    color("red")
      union(){
      translate([0, 0, -h1/2 -h2 -h3 -h4 -h5 +4*tol])
	cylinder(h=h1, r1=d1/2, r2=d2/2, center=true, $fn=fragments);
      
      translate([0, 0, -h2/2 -h3 -h4 -h5 +3*tol])
	cylinder(h=h2, r1=d2/2, r2=d3/2, center=true, $fn=fragments);
      
      translate([0, 0, -h3/2 -h4 -h5 +2*tol])
	cylinder(h=h3, r1=d3/2, r2=d4/2, center=true, $fn=fragments);
      
      translate([0, 0, -h4/2 -h5 +tol])
	cylinder(h=h4, r1=d4/2, r2=d5/2, center=true, $fn=fragments);
      
      translate([0, 0, -h5/2])
	cylinder(h=h5, d=d6, center=true, $fn=fragments);
      
      translate([d6-2*trigger_w/3, 0, -h5/2])
	cube(size=[trigger_w, trigger_w, h5], center=true);
    }
  }
}


module spindle_cup_holder(){

  union(){
      color("red")
    difference(){
      translate([0, 0, -pipe_holder_diameter/2])
	cube(size=[pole_to_pole_distance, pipe_holder_diameter, pipe_holder_diameter], center=true);
      
      /* carve out the hulls of the pipe and spinle holders before adding them */
      hull(){
	translate([pole_to_pole_distance/2+tol, 0, -pipe_holder_diameter-tol])
	  pipe_hold(holder_h=pipe_holder_diameter+2*tol,
		    holder_d=pipe_holder_diameter,
		    with_inside=false);
      }
      hull(){
	translate([-(pole_to_pole_distance/2+tol), 0, -pipe_holder_diameter-tol])
	  pipe_hold(holder_h=pipe_holder_diameter+2*tol,
		    holder_d=pipe_holder_diameter,
		    with_inside=false);
      }
      
      hull(){
        translate([0, 0, 2*tol])
	spindle_cup();
      }
    }

    color("red")
      translate([pole_to_pole_distance/2, 0, -pipe_holder_diameter])
      pipe_hold(holder_h=pipe_holder_diameter,
		holder_d=pipe_holder_diameter,
		with_inside=false);
    color("red")
      translate([-pole_to_pole_distance/2, 0, -pipe_holder_diameter])
      pipe_hold(holder_h=pipe_holder_diameter,
		holder_d=pipe_holder_diameter,
		with_inside=false);
    color("red")
      rotate([0, 0, 90])
      scale(1.01)
      spindle_cup();    
  }

}

translate([0, 0, 100])
spindle_cup_holder();
