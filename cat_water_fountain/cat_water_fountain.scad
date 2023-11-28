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

space_out = 20.0;
tol = 0.02;
cylinder_res = 150;
color_alhpa = 0.8;

// general
thickness = 2.0;

// basin parameter
basin_diameter = 150.0;
basin_height = 10.0;

// drain parameter
drain_arc_outer_radius = (0.9 * basin_diameter) / 2;
drain_arc_inner_radius = drain_arc_outer_radius - 10.0;
drain_arc_height = 0.8 * basin_height;
drain_arc_angle = 90;

// leg parameter
pump_height = 23; // don't change
leg_diameter = 5.0;
leg_height = 50.0;
legs_count = 4;

// fountain parameters
pump_shaft_diameter = 8.0; // don't change
shaft_hieght_below = leg_height - pump_height;
shaft_height_above = basin_height * 2;
slope_height = 10.0;
slope_base_radius = 30.0;

module basin(diameter, height, thickness)
{
  union(){
    // bottom
    cylinder(h=thickness, d=diameter, $fn=cylinder_res, center=true);
    // souranding wall
    translate([0, 0, height/2])
      difference(){
      cylinder(h=height, d=diameter, $fn=cylinder_res, center=true);
      cylinder(h=height+110, d=diameter-thickness, $fn=cylinder_res, center=true);
    }
  }
}

module arc(outer_radius, inner_radius, height, angle)
{
  x = outer_radius - inner_radius;
  y = height;
  rotate_extrude(angle=angle, $fn = cylinder_res)
    translate([inner_radius + x/2, 0, 0])
    square(size=[x, y], center=true);
}

module arc_drain_wall(outer_radius, inner_radius, height, angle)
{
  x = outer_radius - inner_radius;
  y = height;

  union(){
    arc(outer_radius, outer_radius-thickness, height, angle);
    arc(inner_radius+thickness, inner_radius, height, angle);

    
    translate([inner_radius + x/2, thickness, 0])
      rotate([90, 0, 0])
      linear_extrude(height = thickness)
      square(size=[x, y], center=true);

    rotate([0, 0, angle])
      translate([inner_radius + x/2, 0, 0])
      rotate([90, 0, 0])
      linear_extrude(height = thickness)
      square(size=[x, y], center=true);
  }
}

module add_drain(outer_radius, inner_radius, height, angle)
{
  union(){
    difference(){
      children();
      arc(outer_radius, inner_radius, height, angle);
    }
    translate([0, 0, (height-thickness)/2])
      arc_drain_wall(outer_radius, inner_radius, height, angle);
  }
}

module pipe(inner_diameter, thickness, height)
{
  difference(){
    cylinder(h=height, d=inner_diameter + 2*thickness, $fn=cylinder_res, center=true);
    cylinder(h=height+10.0, d=inner_diameter, $fn=cylinder_res, center=true);
  }
}

module fountain_shaft(pump_shaft_diameter, shaft_hieght_below, shaft_height_above,
		      thickness)
{
  shaft_hieght = shaft_hieght_below + shaft_height_above + thickness;
  shaft_thickness = 0.9 * thickness;
  translate([0, 0, shaft_hieght/2 - shaft_hieght_below])
    pipe(inner_diameter=pump_shaft_diameter, thickness=shaft_thickness, height=shaft_hieght);
}

module fountain_slope(pump_shaft_diameter, shaft_hieght_below, shaft_height_above,
		      slope_height, slope_base_radius,
		      thickness)
{
  shaft_hieght = shaft_hieght_below + shaft_height_above + thickness;
  translate([0, 0, slope_height/2 + (shaft_height_above - slope_height) + thickness])
    difference(){
    cylinder(h=slope_height, r1=slope_base_radius, r2=pump_shaft_diameter-thickness, $fn=cylinder_res, center=true);
    cylinder(h=slope_height*2, d=pump_shaft_diameter + 2*thickness, $fn=cylinder_res, center=true);
  }
}

module leg(height, diameter)
{
  translate([0, 0, -height/2])
    cube(size=[diameter, diameter, height], center=true);
}

module legs(leg_height, leg_diameter, basin_diameter, legs_count){
  for (n =[0: legs_count-1] ){
    rotate([0, 0, n*(360.0/legs_count)])
      translate([(basin_diameter-leg_diameter)/2, 0, 0])
      leg(leg_height, leg_diameter);
  }
}

color("red", color_alhpa) translate([0, 0, -space_out])
legs(leg_height, leg_diameter, basin_diameter, legs_count);

color("blue", color_alhpa) translate([0, 0, space_out])
fountain_shaft(pump_shaft_diameter, shaft_hieght_below, shaft_height_above, thickness);

color("green", color_alhpa) translate([0, 0, 2 * space_out])
fountain_slope(pump_shaft_diameter, shaft_hieght_below, shaft_height_above,
	       slope_height, slope_base_radius, thickness);

color("yellow", color_alhpa)
difference(){
  add_drain(drain_arc_outer_radius, drain_arc_inner_radius, drain_arc_height, drain_arc_angle)
    basin(basin_diameter, basin_height, thickness);
  // remove shaft hole
  cylinder(h=thickness+10.0, d= pump_shaft_diameter + 2*thickness, $fn=cylinder_res, center=true);
}
