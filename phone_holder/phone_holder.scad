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
use <../lib/shapes.scad>
use <../lib/extrude_directional.scad>

tol = 0.02;
fragments = 300;
alpha = 1.0;

module phone_outline(scale_=1.0){
    let(s = scale_,
        x = phone_x,
        y = phone_y,
        z = phone_z,
        dz = phone_z/2 + gaurd_thickness,
        c = phone_color)
    {
        color(c, alpha)
        translate([0, 0, dz])
        scale(s)
        cube([x, y, z], center=true);
    }
}

module gaurd(){
    // TODO: add place for magnet
    let(p_x = phone_x,
        p_y = phone_y,
        p_z = phone_z,
        p_dz = phone_z/2 + gaurd_thickness,
        g_x = gaurd_x,
        g_y = gaurd_y,
        g_z = gaurd_z,
        g_dz = gaurd_z/2,
        g_th = gaurd_thickness,
        g_c = gaurd_color)
    {
        color(g_c, alpha)
        difference(){
            translate([0, 0, g_dz])
            cube([g_x, g_y, g_z], center=true);
            // phone
            phone_outline();
            // phone entrance
            translate([0, -2*g_th, 0])
            phone_outline();
            // screen side
            translate([2*g_th, 0, 0])
            phone_outline(scale_=0.92);
            // back side
            translate([-2*g_th, 0, 0])
            phone_outline(scale_=0.92);
            // bottom side for bottoms
            translate([0, 0, -5*g_th])
            phone_outline(scale_=0.8);
            // top side
            translate([0, 10*g_th, 0])
            phone_outline(scale_=0.8);
            // holes for dampers
            translate([0, g_y/3, 1.05*g_z])
            cylinder(h=2*g_x, d=p_x/2, center=true, $fn=fragments);
            translate([0, -g_y/3, 1.05*g_z+tol])
            cylinder(h=2*g_x, d=p_x/2, center=true, $fn=fragments);
        }
    }
    let(r = gaurd_x/4,
        l = gaurd_y,
        dz = gaurd_x/4 + gaurd_z -10*tol,
        g_c = gaurd_color)
    {
        color(g_c, alpha)
        translate([0, 0, dz])
        rotate([90, 90/4, 0])
        linear_extrude(height=l, center=true)
        regularPolygon(order=8, radius=r);
    }
}

module dampers(){
    color(damper_color, alpha)
    translate([0, 0, 0.95*gaurd_z])
    {
        translate([0, gaurd_y/3, 0])
        union(){
            // peg
            translate([0, 0, gaurd_thickness])
            cylinder(h=gaurd_thickness, d=phone_x/2, center=true, $fn=fragments);
            // damper
            cylinder(h=damper_z, r=damper_radius, center=true, $fn=fragments);
        }
        translate([0, -gaurd_y/3, 0])
        union(){
            // peg
            translate([0, 0, gaurd_thickness])
            cylinder(h=gaurd_thickness, d=phone_x/2, center=true, $fn=fragments);
            // damper
            cylinder(h=damper_z, r=damper_radius, center=true, $fn=fragments);
        }
    }
}

module gaurd_outline(){
    let(g_x = gaurd_x,
        g_y = gaurd_y,
        g_z = gaurd_z,
        g_dz = gaurd_z/2)
    {
        color(gaurd_color, alpha)
        difference(){
            translate([0, 0, g_dz])
            cube([g_x, g_y, g_z], center=true);
        }
    }
    let(r = gaurd_x/4,
        l = gaurd_y,
        dz = gaurd_x/4 + gaurd_z -10*tol)
    {
        color(gaurd_color, alpha)
        translate([0, 0, dz])
        rotate([90, 90/4, 0])
        linear_extrude(height=l, center=true)
        regularPolygon(order=8, radius=r);
    }
}

module ball_joint(){
    color(ball_joint_color, alpha) 
    rotate([0, 45, 0])
    union(){
        translate([0, 0, ball_joint_screw_length/2])
        cylinder(
            h=ball_joint_screw_length,
            r=ball_joint_screw_radius,
            center=true, $fn=fragments);
        translate([0, 0, ball_joint_screw_length+0.8*ball_joint_ball_radius])
        sphere(r=ball_joint_ball_radius, $fn=fragments);
    }
}

module gaurd_holder(){
    // the holder itself    
    color(gaurd_holder_color, alpha)
    difference(){
        translate([0, 0, gaurd_holder_z/2 - gaurd_holder_thickness])
        cube([gaurd_holder_x, gaurd_holder_y, gaurd_holder_z], center=true);

        scale(1.002){
            // the main part
            gaurd_outline();
            // for entrance
            translate([0, -2* gaurd_holder_thickness, 0])
            gaurd_outline();
        }

        // screen side
        translate([5*gaurd_thickness, 0, 0])
        phone_outline(scale_=0.92);
        // back side
        translate([-5*gaurd_thickness, 0, 0])
        phone_outline(scale_=0.92);
        // bottom side for bottoms
        translate([0, 0, -10*gaurd_thickness])
        phone_outline(scale_=0.8);
        // top side
        translate([0, 10*gaurd_thickness, 0])
        phone_outline(scale_=0.8);
    }

    // holder for the ball joint
    color(gaurd_holder_color, alpha)
    translate([-0.75*gaurd_x, 0, gaurd_x + gaurd_z])
    rotate([0, 45, 0])
    let(h=ball_joint_screw_length - ball_joint_nut_height){
        difference(){
            rotate([0, 0, 90/4])
            linear_extrude(height=h, center=true)
            regularPolygon(order=8, radius= 2*ball_joint_screw_radius);

            cylinder(h=h+tol, r=ball_joint_screw_radius, center=true, $fn=fragments);
        }
    }
}


*phone_outline();
*gaurd_outline();

translate([-40, 0, 0])
gaurd();

translate([-40, 0, 0])
dampers();

gaurd_holder();

translate([-0.75*gaurd_x, 0, gaurd_x + gaurd_z])
ball_joint();