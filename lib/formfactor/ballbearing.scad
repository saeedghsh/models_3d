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
include <ballbearing_measurement.scad>

module _ballbearing(height, outer_radius, inner_radius, bearing_radius){
  bearing_to_center = outer_radius - (outer_radius - inner_radius)/2;
  number_of_bearings = floor(2* 3.1415 * bearing_to_center / (2*bearing_radius));
  // donut
  %color("red", alpha=0.6)
  difference(){
    cylinder(h=height, d=2*outer_radius, center=true, $fn=fragments);
    cylinder(h=height+tol, d=2*inner_radius, center=true, $fn=fragments);
  }
  // bearings
  for (n=[1:number_of_bearings]) {
    color("black")
    rotate([0, 0, n * 360 / number_of_bearings])
    translate([bearing_to_center, 0, 0])
    sphere(bearing_radius, $fn=fragments);
  }
}

module ballbearing(model){
    if (model=="1"){
        let(height = ballbearing_height_1,
            outer_radius = ballbearing_outer_radius_1,
            inner_radius = ballbearing_inner_radius_1,
            bearing_radius = ballbearing_brearing_radius_1)
        {_ballbearing(height, outer_radius, inner_radius, bearing_radius);}
    } else if (model=="2"){
        let(height = ballbearing_height_2,
            outer_radius = ballbearing_outer_radius_2,
            inner_radius = ballbearing_inner_radius_2,
            bearing_radius = ballbearing_brearing_radius_2)
        {_ballbearing(height, outer_radius, inner_radius, bearing_radius);}
    }
}

module _mock_ballbearing(height, outer_radius, inner_radius){
    difference(){
        cylinder(h=height, r=outer_radius, center=true, $fn=fragments);
        cylinder(h=height+tol, r=inner_radius, center=true, $fn=fragments);
    }
}

module mock_ballbearing(model){
    if (model=="1"){
        let(height = ballbearing_height_1,
            outer_radius = ballbearing_outer_radius_1,
            inner_radius = ballbearing_inner_radius_1)
        {_mock_ballbearing(height, outer_radius, inner_radius);}
    } else if (model=="2"){
        let(height = ballbearing_height_2,
            outer_radius = ballbearing_outer_radius_2,
            inner_radius = ballbearing_inner_radius_2)
        {_mock_ballbearing(height, outer_radius, inner_radius);}
    }
}