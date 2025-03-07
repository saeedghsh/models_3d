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

tol = 0.02;
fragments = 10;

thickness = 1;
// measurement
increase_bin_gap = 0.15;
ball_diameter = 3;
ball_count = 600;

// ICA frame 18x24
total_frame_height = 241;
total_frame_width = 181;

// bin_count = 55;
bin_height = 75; // as in hist-bin height, i.e. when board seen from front
bin_width = ball_diameter + increase_bin_gap;

bin_wall_thickness = 0.5;
bin_wall_height = 3.3;

bin_count = floor(total_frame_width / (bin_width + bin_wall_thickness)) - 1;

// for the reservoir: assuming a ratio of 1 to 4 is ideal
function nubmer_of_rows(ball_count, ratio=4) = sqrt(ball_count / ratio);
function nubmer_of_cols(ball_count, ratio=4) = ratio * sqrt(ball_count / ratio);

// 
bin_offset = 1.4;  // offset to center bins
function bin_wall_position(index) = bin_offset + (index+1) * bin_width + index * bin_wall_thickness + bin_wall_thickness/2;

// height lose in hexagonal stacking of the balls
function hexagonal_stacking_height_loss(ball_diameter) = ball_diameter * (1- sin(60));

module bottom_plate(){
    color("LightSalmon")
    let(w = total_frame_width,
        l = total_frame_height,
        h = thickness)
    {
        translate([0, 0, -h])
        cube([w, l, h], center=false);
    }
}
bottom_plate();

module bin_walls()
{
    color("Maroon")
    let(w = bin_wall_thickness,
        l = bin_height,
        h = bin_wall_height)
    {
        for (i = [0:bin_count-1]){
            translate([bin_wall_position(i), l/2, h/2])
            cube([w, l, h], center=true);
        }
    }
}
bin_walls();

module pins(){
    half_bin_d = 0.5*(ball_diameter+bin_wall_thickness);
    for (row = [1:29]){
        _dx = row%2 == 0 ? 0 : -half_bin_d;
        _dy= bin_height + (row * 1.5*ball_diameter);

        _max = row%2 == 0 ? bin_count-2 : bin_count-1;
        color("Maroon")
        translate([_dx, _dy, bin_wall_height/2])
        for (i = [1 : _max]){
            translate([bin_wall_position(i), 0, 0])
            scale([1, 4, 1])
            cylinder(h=bin_wall_height, d=bin_wall_thickness, center=true, $fn=fragments);
        }
    }
}
pins();

module balls_in_bins(){
    ball_per_bin = floor(ball_count / bin_count);
    color("SteelBlue")
    for (i = [0:bin_count]){
        dx = i * (bin_width+ bin_wall_thickness) + bin_offset;
        translate([dx, 0, 0])
        for (j = [0:ball_per_bin-1]){
            translate([0, j*ball_diameter, 0])
            translate([ball_diameter/2, ball_diameter/2, ball_diameter/2])
            sphere(d=ball_diameter, $fn=fragments);
        }
    }
}
// balls_in_bins();

h = hexagonal_stacking_height_loss(ball_diameter);
n_rows = nubmer_of_rows(ball_count, ratio=5);
n_cols = nubmer_of_cols(ball_count, ratio=5);
_reserve_h = n_rows * (ball_diameter - h) + ball_diameter/2;
_reserve_c = (n_cols - 0.5) * n_rows;
_reserve_w = ball_diameter * n_cols;
echo("------------------------------ BALLS IN RESERVE:");
echo("----- count:", _reserve_c);
echo("----- width(mm):", _reserve_w);
echo("----- height(mm):", _reserve_h);

module reservoir_wall(){

    _dw = 0.5 * total_frame_width - 0.8 * ball_diameter;
    left_bar_points = [
        [0, total_frame_height - _reserve_h - ball_diameter],
        [_dw, total_frame_height - _reserve_h ],
        [_dw, total_frame_height - _reserve_h ],
        [0, total_frame_height - _reserve_h + ball_diameter]
    ];
    right_bar_points = [
        [total_frame_width, total_frame_height - _reserve_h - ball_diameter],
        [total_frame_width - _dw, total_frame_height - _reserve_h],
        [total_frame_width - _dw, total_frame_height - _reserve_h],
        [total_frame_width, total_frame_height - _reserve_h + ball_diameter]
    ];
    color("Maroon")
    union(){
        linear_extrude(height = bin_wall_height)
        polygon(left_bar_points);

        linear_extrude(height = bin_wall_height)
        polygon(right_bar_points);
    }
}
reservoir_wall();

module balls_in_reserve(){
    color("SteelBlue")
    translate([ball_diameter/2, total_frame_height - _reserve_h + ball_diameter, 0])
    for (r = [0:n_rows-1]){
        // every second row has one less ball
        n_cols_adjusted = r%2 == 0 ? n_cols : n_cols -1;
        dy = r * (ball_diameter - h);
        dx = r%2 == 0 ? 0 : ball_diameter/2;
        translate([dx, dy, 0])
        for (c = [0:n_cols_adjusted-1]){
            dx = c*ball_diameter;
            translate([dx, 0, 0])
            translate([ball_diameter/2, ball_diameter/2, ball_diameter/2])
            sphere(d=ball_diameter, $fn=fragments);
        }
    }
}
// balls_in_reserve();


// module balls_in_bins_gaussian(){
//     include <normal_distribution_samples.scad>
//     // Use the data in your design
//     for (i = [0 : len(data) - 1]) {
//         x = data[i];
//         // at this point we need the center of all bin bin_walls
//         translate([data[i], 0, 0])
//             sphere(1); // Example: place a sphere at each data point
//     }
//     // TODO: distribute balls according to gaussian and see how high should be the board
//     ball_per_bin = floor(bin_height / ball_diameter);
//     echo("-->>> BALL COUNT:", ball_per_bin * (bin_count+1));
//     color("SteelBlue")
//     for (i = [0:bin_count]){
//         dx = i * (bin_width+ bin_wall_thickness);
//         translate([dx, 0, 0])
//         for (j = [0:ball_per_bin-1]){
//             translate([0, j*ball_diameter, 0])
//             translate([ball_diameter/2, ball_diameter/2, ball_diameter/2])
//             sphere(d=ball_diameter, $fn=fragments);
//         }
//     }    
// }
// balls_in_bins_gaussian();