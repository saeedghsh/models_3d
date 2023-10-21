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
include <dremel_678-01_measurement.scad>
use <../lib/shapes.scad>
tol = 0.001;
fragments = 300;
alpha = 1.0;
thickness = 2;

module screw(){
    color(screw_hex_color, alpha)
    union()
    {
        translate([0, 0, screw_stem_length/2+tol])
        cylinder(h=screw_stem_length, d=screw_stem_diameter, center=true, $fn=fragments);

        translate([0, 0, screw_stem_length])
        linear_extrude(height=screw_hex_height, center=false)
        regularPolygon(order=6, radius=screw_hex_radius);
    }
}

module metal_bar_profile(width, radius, length){
    union()
    {
        cube([width, 2*radius, length], center=true);
        translate([width/2, 0, 0])
        cylinder(h=length, r=radius, center=true, $fn=fragments);
        translate([-width/2, 0, 0])
        cylinder(h=length, r=radius, center=true, $fn=fragments);
    }
}

module metal_bar(length=metal_bar_length){
    color(metal_bar_color, alpha)
    difference(){
        let(r=metal_bar_radius + metal_bar_thickness,
            w=metal_bar_width,
            l=length
        ){
            metal_bar_profile(w, r, l);
        }
        let(r=metal_bar_radius,
            w=metal_bar_width,
            l=length + tol
        ){
            metal_bar_profile(w, r, l);
        }
        translate([0, metal_bar_radius, 0])
        cube([metal_bar_gap, metal_bar_gap, length+tol], center=true);
    }
}

module metal_pin(){
    color(metal_pin_color, alpha)
    union(){
        cylinder(h=metal_pin_length_1, d=metal_pin_diameter_1, center=true, $fn=fragments);
        cylinder(h=metal_pin_length_2, d=metal_pin_diameter_2, center=true, $fn=fragments);
    }
}

module sliding_block_pivotal(){
    difference(){
        color(sliding_block_color, alpha)
        let(
            radius=metal_bar_radius,
            width=metal_bar_width,
            length=sliding_block_length,
            gap=metal_bar_gap,
            thickness=metal_bar_thickness
        )
        {
            translate([0, -radius-thickness, 0.5*screw_hex_radius])
            {
                translate([0, thickness, 0])
                cube([gap, 2*radius, length], center=true);
                metal_bar_profile(width, radius, length);
            }
        }
        translate([0, -(screw_hex_height+screw_stem_length-tol), 0])
        rotate([-90, 30, 0])
        scale(1+tol)
        screw();

        translate([0, 0, 1.5*screw_hex_radius])
        rotate([90, 0, 0])
        metal_pin();
    }
}

module sliding_block_parallel(){
    difference(){
        color(sliding_block_color, alpha)
        let(
            radius=metal_bar_radius,
            width=metal_bar_width,
            length=sliding_block_length,
            gap=metal_bar_gap,
            thickness=metal_bar_thickness
        )
        {
            translate([0, -radius-thickness, 0.5*screw_hex_radius])
            {
                translate([0, thickness, 0])
                cube([gap, 2*radius, length], center=true);
                metal_bar_profile(width, radius, length);
            }
        }
        translate([0, -(screw_hex_height+screw_stem_length-tol), 0])
        rotate([-90, 30, 0])
        scale(1+tol)
        screw();
    }
    color(sliding_block_color, alpha)
    let(
        width=sliding_block_parallel_bar_width,
        length=sliding_block_parallel_bar_length,
        height=sliding_block_parallel_bar_height
    ){
        translate([0, length/2-tol, -0.5*height + 0.5*sliding_block_length +0.5*screw_hex_radius])
        cube([width, length, height], center=true);
    }
}

module dremel_screw_tip() {
    color(dremel_screw_tip_color, alpha)
    {
        difference(){
            let(r1=dremel_screw_tip_radius_1,
                r2=dremel_screw_tip_radius_2,
                h1=dremel_screw_tip_height_1,
                h2=dremel_screw_tip_height_2
            ){
                union(){
                    translate([0, 0, -h1])
                    union(){
                        // the treaded part
                        rotate([90, 0, 0])
                        import("../thingiverse.com/Dremel_8220_Protection_2861524/files/Dremel_Coke_protect.stl", center=true);
                        translate([0, 0, h1/2])

                        // fill in the ourter tread of the stl model
                        difference(){
                            cylinder(h=h1, r=r2, center=true, $fn=fragments);
                            cylinder(h=h1+2*tol, r=r1, center=true, $fn=fragments);
                        }
                    }

                    // extend the cylinder
                    translate([0, 0, -h2/2 + 5*tol])
                    difference(){
                        cylinder(h=h2, r=r2, center=true, $fn=fragments);
                        cylinder(h=h2 + 2*tol, r=r1, center=true, $fn=fragments);
                    }
                }
            }

            // remove the space for the main metal bar
            let(radius = metal_bar_radius + metal_bar_thickness,
                width = metal_bar_width,
                length = 3* dremel_screw_tip_radius_2,
                h2 = dremel_screw_tip_height_2
            ){
                translate([0, 0, radius - h2])
                rotate([90, 0, 0])
                scale(1.005)
                metal_bar_profile(width, radius+tol, length);
            }
        }

        difference(){
            // add stablizing cross bar
            let(radius = metal_bar_radius + metal_bar_thickness,
                width = metal_bar_width,
                length = 6* dremel_screw_tip_radius_2,
                h2 = dremel_screw_tip_height_2
            ){
                translate([0, 0, radius - h2])
                rotate([90, 0, 90])
                metal_bar_profile(width, radius, length);
            }

            // remove the space for the main metal bar
            let(radius = metal_bar_radius + metal_bar_thickness,
                width = metal_bar_width,
                length = 3* dremel_screw_tip_radius_2,
                h2 = dremel_screw_tip_height_2
            ){
                translate([0, 0, radius - h2])
                rotate([90, 0, 0])
                scale(1.005)
                metal_bar_profile(width, radius+tol, length);
            }
            // just for fun, remove the cynlder for it 
            let(r1=dremel_screw_tip_radius_1,
                r2=dremel_screw_tip_radius_2,
                h1=dremel_screw_tip_height_1,
                h2=dremel_screw_tip_height_2
            ){
                translate([0, 0, -h2/2])
                cylinder(h=h2 + 2*tol, r=r1, center=true, $fn=fragments);
            }
        }

        let(width = metal_bar_width,
            length = 20,
            height = 5,
            radius = metal_bar_radius + metal_bar_thickness,
            r1=dremel_screw_tip_radius_1,
            h2=dremel_screw_tip_height_2            
        ){
            
            translate([0, -length/2 -r1, +height/2 -h2 + 2*radius + tol])
            difference(){
                cube([width, length, height], center=true);
                translate([0, -5, -10])
                screw();
            }
        }
    }
}


#translate([0, 40, metal_bar_radius + metal_bar_thickness])
rotate([-90, 0, 0])
metal_bar(length=150);

translate([0, 50, 0])
rotate([-90, 0, 0]) 
sliding_block_pivotal();

translate([0, 100, 0])
rotate([-90, 0, 0]) 
sliding_block_parallel();

translate([0, 0, dremel_screw_tip_height_2])
dremel_screw_tip();
