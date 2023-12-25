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
use <../formfactors/ballbearing.scad>
include <../formfactors/ballbearing_measurement.scad>
use <../formfactors/battery.scad>
include <../formfactors/battery_measurement.scad>
include <../formfactors/led_measurement.scad>

tol = 0.01;
thickness = 2;
fragments = 300;

battery_height = 10;
battery_isolate_disk_thickness = 1;

ballbearing_height = ballbearing_height_1;
ballbearing_outer_radius = ballbearing_outer_radius_1;
ballbearing_inner_radius = ballbearing_inner_radius_1;
ballbearing_brearing_radius = ballbearing_brearing_radius_1;

long_hand_length = 230;
hand_thickness = ballbearing_height;
short_hand_length = long_hand_length/2 - 2*(ballbearing_outer_radius+hand_thickness);
shaft_height = ballbearing_height + hand_thickness + battery_height + thickness;

module ballbearing_holder_donut(height, outer_radius, holder_thickness){
    difference(){
        cylinder(h=height, d=2*(outer_radius+holder_thickness), center=true, $fn=fragments);
        cylinder(h=height+tol, d=2*outer_radius, center=true, $fn=fragments);
    }
}

module long_arm(){
  union(){
    // the arm
    difference() {
      scale([1, 1, 1])
      cube([long_hand_length, hand_thickness, hand_thickness], center=true);

      hull()
      scale([0.95, 0.95, 1.01])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);
    }

    // center ring
    ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);

    // +x ring
    translate([(long_hand_length+ballbearing_outer_radius+hand_thickness)/2 + hand_thickness, 0, 0])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);

    // -x ring
    translate([-(long_hand_length+ballbearing_outer_radius+hand_thickness)/2 - hand_thickness, 0, 0])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);
  }
}

module short_arm_one_sided(){
    scale([1.01, 1, 1])
    cube([short_hand_length, hand_thickness, hand_thickness], center=true);

    // +x ring
    translate([short_hand_length/2 +ballbearing_outer_radius +hand_thickness, 0, 0])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);

    // -x shaft
    translate([-(short_hand_length/2 +ballbearing_inner_radius), 0, shaft_height/2 - hand_thickness/2])
      cylinder(h=shaft_height, d=2*ballbearing_inner_radius, center=true, $fn=fragments);
}

module short_arm_double_sided(){
    scale([1.01, 1, 1])
    cube([2*short_hand_length, hand_thickness, hand_thickness], center=true);

    // center shaft
    translate([-(0), 0, shaft_height/2 - hand_thickness/2])
      cylinder(h=shaft_height, d=2*ballbearing_inner_radius, center=true, $fn=fragments);

    // +x ring
    translate([short_hand_length +ballbearing_outer_radius +hand_thickness, 0, 0])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);

    // -x ring
    translate([-(short_hand_length +ballbearing_outer_radius +hand_thickness), 0, 0])
      ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);
}

module led_and_battery_holder(){
  difference(){
    union(){
      // LED holder fitting inside ballbearing
      translate([0, 0, thickness +(ballbearing_height+thickness)/2 -tol])
        cylinder(h=ballbearing_height+thickness, d=2*ballbearing_inner_radius, center=true, $fn=fragments);

      // middle disk between LED holder and battery holder
      translate([0, 0, thickness -thickness/2])
        cylinder(h=thickness, d=2*(ballbearing_outer_radius+hand_thickness), center=true, $fn=fragments);

      // battery holder rim
      translate([0, 0, -(cr2032_thickness+battery_isolate_disk_thickness)/2])
      cylinder(
        h=cr2032_thickness+battery_isolate_disk_thickness,
        d=cr2032_diameter+2*thickness,
        center=true, $fn=fragments);
    }

    // removal of the LED holes
    cylinder(h=10*(ballbearing_height+thickness), d=led_body_diameter+tol, center=true, $fn=fragments);
    
    // remove the space for the battery
    translate([0, 0, -(cr2032_thickness)/2]) 
    cylinder(h=cr2032_thickness+tol, d=cr2032_diameter, center=true, $fn=fragments);

    // removal of the LED bottom rim
    translate([0, 0, led_rim_height/2-tol])
    cylinder(h=led_rim_height, d=led_rim_diameter+tol, center=true, $fn=fragments);

    // remove half of battery holder rim
    translate([(cr2032_diameter+2*thickness)/2, 0, -cr2032_thickness/2 -battery_isolate_disk_thickness])
    cube([cr2032_diameter+2*thickness, cr2032_diameter+2*thickness, cr2032_thickness+tol], center=true);

    // remove a small hole on the back of battery rim for to give access for pushing out the battery
    translate([-cr2032_diameter-thickness/2, 0, -cr2032_thickness/2 -battery_isolate_disk_thickness])
    cube([cr2032_diameter+2*thickness, cr2032_diameter+2*thickness, cr2032_thickness+tol], center=true);

  }
}

module battery_isolate_disk(){
  difference(){
    cylinder(h=battery_isolate_disk_thickness, d=cr2032_diameter-10*tol, center=true, $fn=fragments);
    cylinder(h=2*battery_isolate_disk_thickness, d=led_rim_diameter, center=true, $fn=fragments);
  }
  
}

// long arm
translate([0, 0, hand_thickness/2])
union(){
  color("blue")
  long_arm();
  ballbearing(model="1");
  translate([-(long_hand_length+ballbearing_outer_radius+hand_thickness)/2 -hand_thickness, 0, 0])
  ballbearing(model="1");
  translate([(long_hand_length+ballbearing_outer_radius+hand_thickness)/2 +hand_thickness, 0, 0])
  ballbearing(model="1");
}

// holder for the center ballbearing fitting an M6 screw
color("blue") 
translate([0, 0, ballbearing_height/2]) 
difference(){
  cylinder(h=ballbearing_height+tol, r=ballbearing_inner_radius, center=true, $fn=fragments);
  cylinder(h=ballbearing_height+2*tol, d=6, center=true, $fn=fragments);
}

// +x | battery-led holder / battery isolator / mock ballbearing
translate([2*ballbearing_outer_radius, 0, 20])
rotate([180, 0, 0])
translate([0, 0, -35])
{
  color("green")
  led_and_battery_holder();
  color("red")
  translate([0, 0, -2])
  battery_isolate_disk();
  color("green")
  translate([0, 0, 15]) 
  mock_ballbearing(model="1");
}

// -x | battery-led holder / battery isolator / mock ballbearing
translate([-2*ballbearing_outer_radius, 0, 20])
rotate([180, 0, 0])
translate([0, 0, -35])
{
  color("green")
  led_and_battery_holder();
  color("red")
  translate([0, 0, -2]) 
  battery_isolate_disk();
  color("green")
  translate([0, 0, 15]) 
  mock_ballbearing(model="1");
}

// +x | short arm double-sided
color("magenta")
translate([(long_hand_length+ballbearing_outer_radius+hand_thickness)/2 +hand_thickness, 0, hand_thickness/2 + shaft_height + thickness])
rotate([180, 0, 0])
short_arm_double_sided();

// -x | short arm double-sided
color("magenta")
translate([-((long_hand_length+ballbearing_outer_radius+hand_thickness)/2 +hand_thickness), 0, hand_thickness/2 + shaft_height + thickness])
rotate([180, 0, 0])
short_arm_double_sided();

// just a visual guide
*
translate([0, 0, 20]){
  color("blue", alpha=0.8)
  ballbearing_holder_donut(ballbearing_height, ballbearing_outer_radius, hand_thickness);
  ballbearing(model="1");
}