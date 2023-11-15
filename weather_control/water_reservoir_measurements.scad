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

thickness = 3;

// the measured dimensions of the "floatie", the water vaporizer
floatie_diameter = 51;
floatie_height = 20;
floatie_leeway = 5;

// the measured dimensions of the bottle thread
thread_height = 19.9;
thread_diameter = 27.6;

// The dimensions of the inner hallow section
inner_hallow_x = 135; //  floatie_diameter/2  + floatie_leeway + thickness + 45 (half of pet bottle) + 35 (box lid offset)
inner_hallow_y = thread_diameter;
// inner_hallow_z = 25; // the height of water channel, defines the height of witer in reservior
inner_hallow_z = 40; // for the bigger "smoke machine"

// trigger to release the bottle cap lock
trigger_height = inner_hallow_z + 7;
trigger_diameter = 5;

// The size of the rectangular part (body) of the outer shell
outer_shell_x = inner_hallow_x;
outer_shell_y = inner_hallow_y + thickness;
outer_shell_z = thread_height + inner_hallow_z + thickness - 1;

// splash gaurd
splash_gaurd_arm_count = 3;
splash_gaurd_arm_width = 5;
splash_gaurd_arm_height = 180;

splash_gaurd_radius = 1.5 * floatie_diameter;
splash_gaurd_height = 25;

// coloring
outer_shell_color = "Green";
inner_hallow_color = "Blue";
bottle_thread_color = "Red";
color_alpha=0.995;
