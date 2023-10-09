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

thickness = 2;

// phone and holder dampper
damper_z = 2;
phone_z = 70 + damper_z;
phone_x = 8.4;
damper_radius = phone_x/2;
phone_y = 142.2;
phone_color = "SlateGray";
damper_color = "LightSkyBlue";

// phone gaurd
gaurd_thickness = 2.0;
gaurd_z = phone_z + 2 * gaurd_thickness;
gaurd_x = phone_x + 2 * gaurd_thickness;
gaurd_y = phone_y + 2 * gaurd_thickness;
gaurd_color = "RosyBrown";

// gaurd holder
gaurd_holder_thickness = gaurd_thickness;
gaurd_holder_x = gaurd_x + 2 * gaurd_holder_thickness;
gaurd_holder_y = gaurd_y + gaurd_holder_thickness;
gaurd_holder_z = gaurd_z + gaurd_x/2 + 2 * gaurd_holder_thickness;
gaurd_holder_color = "Teal";

// attachment
ball_joint_nut_height = 5;
ball_joint_screw_radius = 5;
ball_joint_screw_length = 20;
ball_joint_ball_radius = 1.8 * ball_joint_screw_radius;
ball_joint_color = "DimGray";