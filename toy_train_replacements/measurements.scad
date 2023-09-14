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

// wheel
shaft_diameter = 2;

wheel_flange_diameter = 11.5;
wheel_flange_thickness = 1;

wheel_diameter = 7.4;
wheel_thickness = 3.5;

wheel_peg_diameter = 2;
wheel_peg_height = 2.1;
wheel_peg_offset = 2;

// rail track
gauge = 11 + 1;

rail_thickness = 1;

rail_h_beam_flange_width = 4;
rail_h_beam_web_height = 5;

sleeper_count = 10;
sleeper_width = 5;
sleeper_length = gauge + wheel_thickness + 2*sleeper_width;
sleeper_height = 2;
sleeper_spacing = 20;

rail_length = sleeper_count * sleeper_spacing + sleeper_width;
groove_depth = sleeper_height / 4;

curved_rail_radius = 4 * rail_length / (2 * PI);