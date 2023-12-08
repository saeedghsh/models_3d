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
include <measurements.scad>

tol = 0.02;
fragments = 300;
extrude_convexity = 10;

module add_loop_and_socket(width, thickness){
    circle_diameter = 0.7 * width;
    loop_socket_distance = gauge - 1.1 * circle_diameter;
    scale_for_fitting = 1.02;

    color("blue") 
    difference(){
        union(){
            children();

            // loop
            translate([0, loop_socket_distance/2, 0])
            union(){
                translate([width, 0, -thickness/2])
                    cylinder(h=thickness+tol, d=circle_diameter, center=true, $fn=fragments);

                translate([0.5*circle_diameter, 0, -thickness/2])
                    cube([circle_diameter, 0.5*circle_diameter, thickness+tol], center=true);
            }
        }

        // socket
        translate([0, -loop_socket_distance/2, 0])
        union(){
            translate([0, 0, -thickness/2])
                scale([scale_for_fitting, scale_for_fitting, 1])
                cylinder(h=thickness+tol, d=circle_diameter, center=true, $fn=fragments);

            translate([0.5*circle_diameter, 0, -thickness/2])
                cube([circle_diameter, 0.5*circle_diameter, thickness+tol], center=true);
        }
    }
}

module sleeper(scale_for_groove=1){
    color("LightGrey")
    translate([0, 0, -sleeper_height/2])
        scale([scale_for_groove, scale_for_groove, 1])
        cube([sleeper_width, sleeper_length, sleeper_height], center=true);
}

module sleeper_end(scale_for_groove=1){
    color("RoyalBlue")
    add_loop_and_socket(width=sleeper_width, thickness=sleeper_height)
        sleeper();
}

module rail_cross_section(scale_for_groove=1){
    /*
    th = rail_thickness
    fw = flange_width
    wh = web_height
    d = fw - th /2;
               ____fw____
    th        |___    ___|
                  |  |
    wh            |th|
               _d_|  |___
    2 x th    |          |
              |__________|
    */
    th = rail_thickness;
    fw = rail_h_beam_flange_width;
    wh = rail_h_beam_web_height -5*th/2;
    d = (fw - th)/2;

    points = [
        [0, 0], // 1
        [0, 2*th], // 2
        [d, 2*th], // 3
        [d, 2*th + wh], // 4
        [0, 2*th + wh], // 5
        [0, 2*th + wh + th], // 6
        [fw, 2*th + wh + th], // 7
        [fw, 2*th + wh], // 8
        [d+th, 2*th + wh], // 9
        [d+th, 2*th], // 10
        [fw, 2*th], // 11
        [fw, 0], // 12
    ];
    scale(scale_for_groove)
        polygon(points);
}

module distribute_sleepers_straight(scale_for_groove=1){
    // starter sleeper
    translate([sleeper_width/2, 0, 0])
        rotate([0, 0, 180])
        sleeper_end(scale_for_groove);
    // middle sleepers
    for (i = [1:sleeper_count-1]){
        dx = i * sleeper_spacing;
        translate([sleeper_width/2 + dx, 0, 0])
            sleeper(scale_for_groove);
    }
    // end sleeper
    dx = sleeper_count * sleeper_spacing;
    translate([sleeper_width/2 + dx, 0, 0])
        sleeper_end(scale_for_groove);
}

module distribute_rails_straight(scale_for_groove=1){
    module straight_rail(scale_for_groove=1){
        translate([0, -rail_h_beam_flange_width/2, 0])
        rotate([90, 0, 90])
        linear_extrude(height=rail_length)
        rail_cross_section(scale_for_groove);
    }

    translate([0, +(gauge + rail_h_beam_flange_width)/2, 0])
    straight_rail();

    translate([0, -(gauge + rail_h_beam_flange_width)/2, 0])
    straight_rail();
}

module distribute_rails_curved(scale_for_groove=1){
    rotate_extrude(angle = 90, convexity=extrude_convexity, $fn=fragments)
    translate([curved_rail_radius +(gauge + rail_h_beam_flange_width)/2 -rail_h_beam_flange_width/2, 0, 0])
    rail_cross_section(scale_for_groove);

    rotate_extrude(angle = 90, convexity=extrude_convexity, $fn=fragments)
    translate([curved_rail_radius -(gauge + rail_h_beam_flange_width)/2 -rail_h_beam_flange_width/2, 0, 0])
    rail_cross_section(scale_for_groove);
}

module distribute_sleepers_curved(scale_for_groove=1){
    // starter sleeper
    translate([curved_rail_radius, sleeper_width/2, 0])
    rotate([0, 0, 90])
    rotate([0, 0, 180])
    sleeper_end(scale_for_groove);

    // middle sleepers
    for (i = [1:sleeper_count-1]){
        theta = i * 90/sleeper_count;
        rotate([0, 0, theta])
        translate([curved_rail_radius, 0, 0])
        rotate([0, 0, 90])
        sleeper(scale_for_groove);
    }

    // end sleeper
    theta = 90;
    translate([sleeper_width/2, 0, 0])
    rotate([0, 0, theta])
    translate([curved_rail_radius, 0, 0])
    rotate([0, 0, 90])
    sleeper_end(scale_for_groove);
}

disconnect_rail_sleeper = true;
disconnect_dz = disconnect_rail_sleeper ? +2*groove_depth : -2*groove_depth; // test ? true_val : false_val

// Cureved
{
    // rails
    color("gray")
    translate([0, 0, disconnect_dz])
    difference(){
        distribute_rails_curved(scale_for_groove=1);
        translate([0, 0, +groove_depth])
        distribute_sleepers_curved(scale_for_groove=1.03);
    }
    // sleepers
    color("black")
    difference(){
        distribute_sleepers_curved(scale_for_groove=1);
        translate([0, 0, -groove_depth])
            distribute_rails_curved(scale_for_groove=1.03);
    }
}

// Straight
*translate([-rail_length-10, curved_rail_radius, 0])
{
    // rails
    color("gray")
    translate([0, 0, disconnect_dz])
    difference(){
        distribute_rails_straight();
        translate([0, 0, +groove_depth])
            distribute_sleepers_straight(scale_for_groove=1.03);
    }
    // sleepers
    color("black")
    difference(){
        distribute_sleepers_straight();
        translate([0, 0, -groove_depth])
            distribute_rails_straight(scale_for_groove=1.03);
    }
}