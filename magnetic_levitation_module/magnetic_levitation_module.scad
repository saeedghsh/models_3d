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

tol = 0.01;
thickness = 2;
fragments = 300;
alpha = 1.0;

module floating_magnet(){
    let(hole_d = floating_magnet_hole_diameter_1,
        d = floating_magnet_diameter_1,
        h = floating_magnet_height_1,
        c = floating_magnet_color_1,
        dz = floating_magnet_height_1/2 +floating_magnet_height_2 +floating_magnet_height_3)
    {
        color(c, alpha)
        translate([0, 0, dz])
        difference(){
        cylinder(h=h, d=d, center=true, $fn=fragments);
        cylinder(h=h+tol, d=hole_d, center=true, $fn=fragments);
        }
    }
    let(d = floating_magnet_diameter_2,
        h = floating_magnet_height_2,
        c = floating_magnet_color_2,
        dz = floating_magnet_height_2/2 +floating_magnet_height_3)
    {
        color(c, alpha)
        translate([0, 0, dz])
        cylinder(h=h, d=d, center=true, $fn=fragments);
    }
    let(d = floating_magnet_diameter_3,
        h = floating_magnet_height_3,
        c = floating_magnet_color_3,
        dz = +floating_magnet_height_3/2)
    {
        color(c, alpha)
        translate([0, 0, dz])
        cylinder(h=h, d=d, center=true, $fn=fragments);
    }
}

module base(){
    let(outer_d = base_magnet_outer_diameter,
        inner_d = base_magnet_inner_diameter,
        h = base_magnet_height,
        c = base_magnet_color,
        dz = base_magnet_height/2 +base_mounting_base_height +base_circuit_height)
    {
        color(c, alpha) 
        translate([0, 0, dz])
        difference(){
            cylinder(h=h, d=outer_d, center=true, $fn=fragments);
            cylinder(h=h+tol, d=inner_d, center=true, $fn=fragments);
        }
    }

    let(outer_d = base_mounting_base_outer_diameter,
        inner_d = base_mounting_base_inner_diameter,
        h = base_mounting_base_height,
        pad_w = base_mounting_base_screw_pad_width,
        pad_l = base_mounting_base_screw_pad_length,
        screw_d = base_mounting_base_screw_hole_diameter,
        screw_offset = base_mounting_base_screw_pad_center_offset,
        c = base_mounting_base_color,
        dz = base_mounting_base_height/2 +base_circuit_height)
    {
        color(c, alpha) 
        translate([0, 0, dz])
        difference(){
            union(){
                cylinder(h=h, d=outer_d, center=true, $fn=fragments);
                cube([outer_d+2*pad_l, pad_w, h], center=true);
                rotate([0, 0, 90])
                cube([outer_d+2*pad_l, pad_w, h], center=true);
            }
            cylinder(h=h+tol, d=inner_d, center=true, $fn=fragments);

            translate([outer_d/2 +screw_offset, 0, 0])
            cylinder(h=h+tol, d=screw_d, center=true, $fn=fragments);

            rotate([0, 0, 90])
            translate([outer_d/2 +screw_offset, 0, 0])
            cylinder(h=h+tol, d=screw_d, center=true, $fn=fragments);

            rotate([0, 0, 180])
            translate([outer_d/2 +screw_offset, 0, 0])
            cylinder(h=h+tol, d=screw_d, center=true, $fn=fragments);

            rotate([0, 0, 270])
            translate([outer_d/2 +screw_offset, 0, 0])
            cylinder(h=h+tol, d=screw_d, center=true, $fn=fragments);
        }
    }

    let(d = base_circuit_diameter,
        h = base_circuit_height,
        pad_h = base_circuit_led_pad_height,
        pad_w = base_circuit_led_pad_width,
        pad_l = base_circuit_led_pad_length,
        c = base_circuit_color,
        dz = base_circuit_height/2)
    {
        color(c, alpha) 
        translate([0, 0, dz])
        union(){
            translate([0, 0, h/2 - pad_h/2])
            {
                rotate([0, 0, 45])
                cube([d+2*pad_l, pad_w, pad_h], center=true);
                rotate([0, 0, -45])
                cube([d+2*pad_l, pad_w, pad_h], center=true);
            }

            cylinder(h=h, d=d, center=true, $fn=fragments);
        }   
    }

    let(d=base_coil_diameter,
        h = base_coil_height,
        dx = base_coil_offset,
        c = base_coil_color,
        dz = base_coil_height/2 +base_mounting_base_height +base_circuit_height)
    {
        color(c, alpha)
        translate([0, 0, dz])
        union()
        {
            translate([dx, 0, 0])
            cylinder(h=h, d=d, center=true, $fn=fragments);

            rotate([0, 0, 90])
            translate([dx, 0, 0])
            cylinder(h=h, d=d, center=true, $fn=fragments);

            rotate([0, 0, 180])
            translate([dx, 0, 0])
            cylinder(h=h, d=d, center=true, $fn=fragments);

            rotate([0, 0, 270])
            translate([dx, 0, 0])
            cylinder(h=h, d=d, center=true, $fn=fragments);
        }
    }
}

base();

translate([0, 0, 43])
floating_magnet();
