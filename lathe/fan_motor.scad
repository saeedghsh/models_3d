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

module hole_along_x(diameter, length, position){
    translate(position)
    rotate([0, 90, 0])
    cylinder(h=length+tol, d=diameter, center=true, $fn=fragments);
}

module hole_along_z(diameter, length, position){
    translate(position)
    cylinder(h=length+tol, d=diameter, center=true, $fn=fragments);
}


module fixture(){
    union(){
        // fixture
        color(fixture_color, alpha)
        difference(){
            // outline
            translate([0, 0, fixture_size_z/2])
            cube([fixture_size_x, fixture_size_y, fixture_size_z], center=true);

            // fixture hole
            let(diameter = fixure_hole_diameter,
                length = fixture_size_x,
                dz = fixure_hole_z_offset)
            {
                hole_along_x(diameter=diameter, length=length, position=[0, 0, dz]);
            }
            // four screw holes
            let(diameter = screw_hole_1_diameter,
                length = fixture_size_x+tol,
                dy = screw_hole_1_y_offset,
                dz1=screw_hole_1_z_offset1,
                dz2=screw_hole_1_z_offset2)
            {
                hole_along_x(diameter=diameter, length=length, position=[0, dy, dz1]);
                hole_along_x(diameter=diameter, length=length, position=[0, -dy, dz1]);
                hole_along_x(diameter=diameter, length=length, position=[0, dy, dz2]);
                hole_along_x(diameter=diameter, length=length, position=[0, -dy, dz2]);

            }
            // two screw holes
            let(diameter = screw_hole_2_diameter,
                length = fixture_size_x+tol,
                dy = screw_hole_2_y_offset,
                dz = screw_hole_2_z_offset)
            {
                hole_along_x(diameter=diameter, length=length, position=[0, dy, dz]);
                hole_along_x(diameter=diameter, length=length, position=[0, -dy, dz]);
            }
        }
        // coil
        color(coil_color, alpha)
        translate([0, 0, coil_offset_z])
        cube([coil_size_x, coil_size_y, coil_size_z], center=true);
    }
}

module armature(){
    color(armature_color, alpha)
    rotate([0, 90, 0])
    union(){
        cylinder(h=armature_center_length, d=armature_center_diameter, center=true, $fn=fragments);

        translate([0, 0, armature_shaft_offset])
        cylinder(h=armature_shaft_length, d=armature_shaft_diameter, center=true, $fn=fragments);
    }  
}

module armature_shaft_holder(){
    color(armature_shaft_holder_color, alpha)
    difference(){
        union(){
            // plate 1
            let(x = armature_shaft_holder_plate_1_size_x,
                y = armature_shaft_holder_plate_1_size_y,
                z = armature_shaft_holder_plate_thickness,
                dz = armature_shaft_holder_plate_thickness/2)
            {
                translate([0, 0, dz])
                cube([x, y, z], center=true);
            }
            // plate 1 to plate 2 bridges
            let (x = armature_shaft_holder_plate_1_size_x,
                 y = (armature_shaft_holder_plate_2_size_y - armature_shaft_holder_plate_1_gap_y)/2,
                 z = armature_shaft_holder_plate_2_z_offset + armature_shaft_holder_plate_thickness,
                 dy = armature_shaft_holder_plate_1_gap_y/2 + y/2,
                 dz = z/2)
            {
                translate([0, dy, dz])
                cube([x, y, z], center=true);
                translate([0, -dy, dz])
                cube([x, y, z], center=true);
            }
            // plate 2
            let(x = armature_shaft_holder_plate_2_size_x,
                y = armature_shaft_holder_plate_2_size_y,
                z = armature_shaft_holder_plate_thickness,
                dz = armature_shaft_holder_plate_2_z_offset +armature_shaft_holder_plate_thickness/2)
            {
                translate([0, 0, dz])
                cube([x, y, z], center=true);
            }
            // disk
            let(height = armature_shaft_holder_disk_thickness,
                diameter = armature_shaft_holder_disk_diameter,
                dz = armature_shaft_holder_disk_thickness/2 + armature_shaft_holder_plate_2_z_offset)
            {
                translate([0, 0, dz])
                cylinder(h=height, d=diameter, center=true, $fn=fragments);
            }
        }
        // plate 1 gap
        let(x = armature_shaft_holder_plate_1_size_x+tol,
            y = armature_shaft_holder_plate_1_gap_y,
            z = armature_shaft_holder_plate_thickness+tol,
            dz = armature_shaft_holder_plate_thickness/2)
        {
            translate([0, 0, dz])
            cube([x, y, z], center=true);
        }
        // screw holes
        let(diameter = armature_shaft_holder_screw_diameter,
            length = armature_shaft_holder_plate_thickness+tol,
            dy = armature_shaft_holder_screw_y_offset,
            dz = armature_shaft_holder_plate_thickness/2)
        {
            hole_along_z(diameter=diameter, length=length, position=[0, dy, dz]);
        }
        let(diameter=armature_shaft_holder_screw_diameter,
            length=armature_shaft_holder_plate_thickness+tol,
            dy = -armature_shaft_holder_screw_y_offset,
            dz = armature_shaft_holder_plate_thickness/2)
        {
            hole_along_z(diameter=diameter, length=length, position=[0, dy, dz]);
        }
        // shaft hole
        let(diameter=armature_shaft_holder_disk_hole_diameter,
            length=armature_shaft_holder_disk_thickness+tol,
            dz = armature_shaft_holder_disk_thickness/2 + armature_shaft_holder_plate_2_z_offset)
        {
            hole_along_z(diameter=diameter, length=length, position=[0, 0, dz]);
        }
    }
}

fixture();

translate([0, 0, fixure_hole_z_offset])
armature();

translate([fixture_size_x/2, 0, screw_hole_2_z_offset])
rotate([0, 90, 0])
armature_shaft_holder();

translate([-fixture_size_x/2, 0, screw_hole_2_z_offset])
rotate([0, -90, 0])
armature_shaft_holder();

