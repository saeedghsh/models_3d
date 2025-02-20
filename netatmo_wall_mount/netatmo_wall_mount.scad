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

fragments = 300;
tol = 0.1;
thickness = 2;

// components
// holder_cylinder
// mount_cube


// 3M no-nail adhesive tape
adhesive_tape_width = 15.5;
adhesive_tape_height = 22;

// Distance from bottom of the camera to bottom of the usb micro cable is 52.
// Setting it to two times the adhesive tape height allows for a good grip
// while not being too high to reach the usb micro cable.
// But it will take too much print time, so we set it to adhesive_tape_height
// mount_height = 2 * adhesive_tape_height;
mount_height = adhesive_tape_height;

camera_diameter = 45.2 + tol;
camera_center_to_wall = 70 - camera_diameter/2;

vent_holes_radius = 3;
vent_holes_count = 5; // will be multiplied by 2

micro_usb_cable_radius = 6;

let(){
    let(){ // holder_cylinder
        translate([0, 0, mount_height/2])
        difference()
        {
            // outer cylinder
            cylinder(r = camera_diameter/2 + thickness, h = mount_height, $fn=fragments, center=true);
            // hole inside
            translate([0, 0, +thickness])
            cylinder(r = camera_diameter/2, h = mount_height + 2*tol, $fn=fragments, center=true);
            // cuts
            // translate([0, 0, -3*vent_holes_radius]) 
            union(){
                rotation = 180 / vent_holes_count;
                // cylinder cuts
                for (i =[0:vent_holes_count-1]){
                    rotate([90, 0, i*rotation])
                    cylinder(h = 3*camera_diameter/2, r=vent_holes_radius, $fn=fragments, center=true);
                }
                // cube cuts
                for (i =[0:vent_holes_count-1]){
                    translate([0, 0, mount_height/2]) 
                    rotate([0, 0, i*rotation])
                    cube(size=[2*vent_holes_radius, 3*camera_diameter/2, mount_height], center=true);
                }
            }
        }
    }

    let( // mount_cube
        // setting width (i.e. x) to camera diameter makes good alignment with the hold
        // while not being wide enough to cover the 3 x adhesive tape width ()
        // 3 * adhesive_tape_width
        x = camera_diameter + 2*thickness,
        y = camera_center_to_wall,
        z = mount_height // adhesive_tape_height
    ){
        difference() {
            // the mount cube
            translate([0, y/2, z/2])
            cube(size=[x, y, z], center=true);
            // the cut
            translate([0, 0, z/2+thickness])
            cylinder(r = camera_diameter/2, h = z + 2*tol, $fn=fragments, center=true);
            // usb micro cable hole
            translate([0, y -micro_usb_cable_radius -thickness, z/2])
            cylinder(h = z + tol, r = micro_usb_cable_radius, $fn=fragments, center=true);
        }
    }
}


