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
width = 100;

filename = "/home/saeed/code/3d_models/stencils/designs/drawing_01.svg";

module bottom_plate(width, thickness){
  difference(){
    cube(size=[width, width, thickness], center=true);

    color("red", 1.0)
      translate([-(width-thickness+tol)/2, -(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([(width-thickness+tol)/2, +(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([-(width/4+tol), (width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
    
    color("red", 1.0)
      translate([(width/4+tol), -(width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
  }
}

module plate(width, thickness){
  difference(){
    cube(size=[width, width, thickness], center=true);

    color("red", 1.0)
      translate([-(width-thickness+tol)/2, width/4+tol, 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([(width-thickness+tol)/2, -(width/4+tol), 0])
      cube(size=[thickness, width/2, 2*thickness], center=true);

    color("red", 1.0)
      translate([-(width/4+tol), -(width-thickness+tol)/2, 0])
      cube(size=[width/2, thickness, 2*thickness], center=true);
  }
}

module plate_stenciled(width, thickness, file_name){
  difference(){
    plate(width, thickness);
    linear_extrude(3*thickness, center=true)
      import(file=file_name, center=true, $fn=fragments);
  }
}

mode = "cube";
mode = "single";

if (mode == "cube"){
    translate([0, -10, 10])
    translate([0, -width/2+thickness/2, width/2])
    rotate([90, 0, 0])
    plate_stenciled(width, thickness, filename);

    translate([10, 0, 10])
    rotate([0, 0, 90])
    translate([0, -width/2+thickness/2, width/2])
    rotate([90, 0, 0])
    plate_stenciled(width, thickness, filename);

    translate([0, 10, 10])
    rotate([0, 0, 180])
    translate([0, -width/2+thickness/2, width/2])
    rotate([90, 0, 0])
    plate_stenciled(width, thickness, filename);

    translate([-10, 0, 10])
    rotate([0, 0, 270])
    translate([0, -width/2+thickness/2, width/2])
    rotate([90, 0, 0])
    plate_stenciled(width, thickness, filename);

    translate([0, 0, thickness/2])
    bottom_plate(width, thickness);
}

module resize() {
    children();


}

filenames = [
    "/home/saeed/code/3d_models/stencils/designs/drawing_01.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_02.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_03.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_04.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_05.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_06.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_07.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_08.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_09.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_10.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_11.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_12.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_13.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_14.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_15.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_16.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_17.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_18.svg", // has issue
    "/home/saeed/code/3d_models/stencils/designs/drawing_19.svg", // has issue
    "/home/saeed/code/3d_models/stencils/designs/drawing_20.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_21.svg", // has issue
    "/home/saeed/code/3d_models/stencils/designs/drawing_22.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_23.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_24.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_25.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_26.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_27.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_28.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_29.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_30.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_31.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_32.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_33.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_34.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_35.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_36.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_37.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_38.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_39.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_40.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_41.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_42.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_43.svg",
    "/home/saeed/code/3d_models/stencils/designs/drawing_44.svg"
];

module stencil(thickness, width, fn){
    difference(){
        cube(size=[width, width, thickness], center=true);
        scale([width/100, width/100, 1])
        linear_extrude(3*thickness, center=true)
        import(file=fn, center=true, $fn=fragments);
    }
}
stencil(thickness=1, width=70, fn=filenames[28-1]);