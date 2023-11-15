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

include <water_reservoir_measurements.scad>

module remove_holes(wall_radius, wall_height, hole_radius, hole_height_offset){
    difference(){
        children();
        for (angle=[0, 45, 90, 135]){
            translate([0, 0, -wall_height/2 + hole_radius + hole_height_offset])
            rotate([0, 0, angle])
            rotate([90, 0, 0])
            cylinder(h=3*wall_radius, r=hole_radius, center=true, $fn=fragments);
        }
    }
}

module humidifier_dispenser_cap(
    inner_radius, outer_radius, short_wall_height, tall_wall_height, hole_radius, thickness, outer_wall
){
    // saucer
    translate([0, 0, thickness/2])
    difference(){
        cylinder(h=thickness, r=outer_radius, center=true, $fn=fragments);
        cylinder(h=thickness+tol, r=inner_radius-thickness, center=true, $fn=fragments);
    }

    // inner downward wall
    color("red")
    // translate([0, 0, -thickness]) // for separation
    translate([0, 0, -short_wall_height/2 +tol])
    difference(){
        cylinder(h=short_wall_height, r=inner_radius-1, center=true, $fn=fragments);
        cylinder(h=short_wall_height+tol, r=inner_radius-thickness, center=true, $fn=fragments);
    }

    // inner upward wall
    color("green")
    translate([0, 0, 2*thickness]) // for separation
    translate([0, 0, 0.5*tall_wall_height/2 +tol])
    union(){
        translate([0, 0, 0.5*tall_wall_height/2])
        cylinder(h=thickness, r=inner_radius, center=true, $fn=fragments);
        difference(){
            remove_holes(outer_radius, 0.5*tall_wall_height, hole_radius, thickness/3)
            cylinder(h=0.5*tall_wall_height, r=inner_radius, center=true, $fn=fragments);
            cylinder(h=0.5*tall_wall_height+tol, r=inner_radius-thickness, center=true, $fn=fragments);
        }
    }

    // outer upward wall
    if (outer_wall == true){
        
        color("blue")
        translate([0, 0, 2*thickness]) // for separation
        translate([0, 0, tall_wall_height/2])
        difference(){
            remove_holes(outer_radius, tall_wall_height, hole_radius, thickness/3)
            cylinder(h=tall_wall_height, r=outer_radius, center=true, $fn=fragments);
            cylinder(h=tall_wall_height+2*tol, r=outer_radius-thickness, center=true, $fn=fragments);
        }
    }
}

d = floatie_diameter+ 2*(floatie_leeway);
let(
    inner_radius = 0.5 * d,
    outer_raidus = 0.7 *d,
    short_wall_height = 2 * thickness,
    tall_wall_height = 10 * thickness,
    hole_radius = 3* 2,
    thickness = 2,
    outer_wall = false
)
{
    humidifier_dispenser_cap(
        inner_radius, outer_raidus, short_wall_height, tall_wall_height, hole_radius, thickness, outer_wall
    );

     // plugs
     color("DarkGray")
     translate([0, 0, 2*hole_radius-thickness/2]) rotate([90, 0, 0]) // just for visual
     translate([0, 0, 1.5 * tall_wall_height])
     difference(){
          cylinder(h=2*thickness, r=0.99* hole_radius, center=true, $fn=fragments);
          translate([0, 0, thickness/2 + tol])
          cylinder(h=thickness, r=hole_radius-thickness/2, center=true, $fn=fragments);
     }

     // pipe
     color("DarkGray")
     translate([-20, 0, 2*hole_radius-thickness/2]) rotate([0, 90, 0]) // just for visual
     translate([0, 0, 2.5 * tall_wall_height])
     difference(){
          cylinder(h=8*thickness, r=0.99* hole_radius, center=true, $fn=fragments);
          cylinder(h=9*thickness, r=hole_radius-thickness/2, center=true, $fn=fragments);
     }
}
