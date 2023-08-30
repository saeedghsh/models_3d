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

// ----------------------------------------------------------------------
ballbearing_outer_raduis = 24.1 / 2;
ballbearing_inner_raduis = 15 / 2;
ballbearing_height = 5;

led_rim_height = 1;
led_rim_diameter = 6;
led_body_height = 6;
led_body_diameter = 5;
led_tip_heigh = 2;

battery_height = 10;

cr2032_diameter = 20;
cr2032_thickness = 4.5;
battery_isolate_disk_thickness = 1;

long_hand_length = 230;
hand_thickness = ballbearing_height;
short_hand_length = long_hand_length/2 - 2*(ballbearing_outer_raduis+hand_thickness);
shaft_height = ballbearing_height + hand_thickness + battery_height + thickness;

// ----------------------------------------------------------------------


module ballbearing(){
  bearing_to_center = ballbearing_outer_raduis - (ballbearing_outer_raduis - ballbearing_inner_raduis)/2;
  bearing_radius = 4.5/2;
  number_of_bearings = floor(2* 3.1415 * bearing_to_center / (2*bearing_radius));

  // donut
  %color("red", alpha=0.6)
  difference(){
    cylinder(h=ballbearing_height, d=2*ballbearing_outer_raduis, center=true, $fn=fragments);
    cylinder(h=ballbearing_height+tol, d=2*ballbearing_inner_raduis, center=true, $fn=fragments);
  }

  // bearings
  for (n=[1:number_of_bearings]) {
    color("black")
    rotate([0, 0, n * 360 / number_of_bearings])
    translate([bearing_to_center, 0, 0])
    sphere(bearing_radius, $fn=fragments);
  }
}

module ballbearing_holder_donut(){
  difference(){
    cylinder(h=ballbearing_height, d=2*(ballbearing_outer_raduis+hand_thickness), center=true, $fn=fragments);
    cylinder(h=ballbearing_height+tol, d=2*ballbearing_outer_raduis, center=true, $fn=fragments);
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
      ballbearing_holder_donut();
    }

    // center ring
    ballbearing_holder_donut();

    // +x ring
    translate([(long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 + hand_thickness, 0, 0])
      ballbearing_holder_donut();

    // -x ring
    translate([-(long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 - hand_thickness, 0, 0])
      ballbearing_holder_donut();
  }
}

module short_arm_one_sided(){
    scale([1.01, 1, 1])
    cube([short_hand_length, hand_thickness, hand_thickness], center=true);

    // +x ring
    translate([short_hand_length/2 +ballbearing_outer_raduis +hand_thickness, 0, 0])
      ballbearing_holder_donut();

    // -x shaft
    translate([-(short_hand_length/2 +ballbearing_inner_raduis), 0, shaft_height/2 - hand_thickness/2])
      cylinder(h=shaft_height, d=2*ballbearing_inner_raduis, center=true, $fn=fragments);
}

module short_arm_double_sided(){
    scale([1.01, 1, 1])
    cube([2*short_hand_length, hand_thickness, hand_thickness], center=true);

    // center shaft
    translate([-(0), 0, shaft_height/2 - hand_thickness/2])
      cylinder(h=shaft_height, d=2*ballbearing_inner_raduis, center=true, $fn=fragments);

    // +x ring
    translate([short_hand_length +ballbearing_outer_raduis +hand_thickness, 0, 0])
      ballbearing_holder_donut();

    // -x ring
    translate([-(short_hand_length +ballbearing_outer_raduis +hand_thickness), 0, 0])
      ballbearing_holder_donut();
}

module led_and_battery_holder(){

  difference(){
    union(){
      // LED holder fitting inside ballbearing
      translate([0, 0, thickness +(ballbearing_height+thickness)/2 -tol])
        cylinder(h=ballbearing_height+thickness, d=2*ballbearing_inner_raduis, center=true, $fn=fragments);

      // middle disk between LED holder and battery holder
      translate([0, 0, thickness -thickness/2])
        cylinder(h=thickness, d=2*(ballbearing_outer_raduis+hand_thickness), center=true, $fn=fragments);

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

module mock_ballbearing(){
  difference(){
    cylinder(h=ballbearing_height, r=ballbearing_outer_raduis, center=true, $fn=fragments);
    cylinder(h=ballbearing_height+tol, r=ballbearing_inner_raduis, center=true, $fn=fragments);
  }
}

// long arm
translate([0, 0, hand_thickness/2])
union(){
  color("blue")
  long_arm();
  ballbearing();
  translate([-(long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 -hand_thickness, 0, 0])
  ballbearing();
  translate([(long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 +hand_thickness, 0, 0])
  ballbearing();
}

// holder for the center ballbearing fitting an M6 screw
color("blue") 
translate([0, 0, ballbearing_height/2]) 
difference(){
  cylinder(h=ballbearing_height+tol, r=ballbearing_inner_raduis, center=true, $fn=fragments);
  cylinder(h=ballbearing_height+2*tol, d=6, center=true, $fn=fragments);
}

// +x | battery-led holder / battery isolator / mock ballbearing
translate([2*ballbearing_outer_raduis, 0, 20])
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
  mock_ballbearing();
}

// -x | battery-led holder / battery isolator / mock ballbearing
translate([-2*ballbearing_outer_raduis, 0, 20])
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
  mock_ballbearing();
}

// +x | short arm double-sided
color("magenta")
translate([(long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 +hand_thickness, 0, hand_thickness/2 + shaft_height + thickness])
rotate([180, 0, 0])
short_arm_double_sided();

// -x | short arm double-sided
color("magenta")
translate([-((long_hand_length+ballbearing_outer_raduis+hand_thickness)/2 +hand_thickness), 0, hand_thickness/2 + shaft_height + thickness])
rotate([180, 0, 0])
short_arm_double_sided();

// just a visual guide
*
translate([0, 0, 20]){
  color("blue", alpha=0.8)
  ballbearing_holder_donut();
  ballbearing();
}