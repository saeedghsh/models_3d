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

fragments = 500;

//------------------------------------------------------------
//  Parametric eye-shaped ring  (two-circle intersection)
//
//  width      : full horizontal size  (mm)
//  height     : full vertical size    (mm)
//  wall       : ring wall thickness   (mm)
//  thickness  : extrusion in Z        (mm)
//
//  Geometry (centres on ±c along Y):
//      let  w = width/2 , h = height/2
//      c = (w² − h²) / (2h)
//      r = (w² + h²) / (2h)          (so that r − c = h)
//------------------------------------------------------------

width      = 40;
height     = 16;
wall       =  1.5;
thickness  = 10;

module eye2d(w,h) {
    c = (w*w - h*h) / (2*h);          // centre offset (±c)
    r = (w*w + h*h) / (2*h);          // circle radius
    intersection() {
        translate([0,  c]) circle(r, $fn=fragments);
        translate([0, -c]) circle(r, $fn=fragments);
    }
}

module eye_ring() {
    w = width  / 2;
    h = height / 2;
    linear_extrude(thickness) difference() {
        eye2d(w,h);                       // outer surface
        offset(-wall)
            eye2d(w,h);                   // inner surface (hollow)
    }
}

eye_ring();   // render
