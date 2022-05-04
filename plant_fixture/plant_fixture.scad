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

/******************************************************************************/
module rodCap(height, rod_radius, thickness, fill_rod_cap)
{
     outer_radius = rod_radius + thickness;
     inner_height = height - thickness;
     difference()
     {
          cylinder(h=height, r=outer_radius, center=true);
          if (!fill_rod_cap)
          {
               translate([0, 0, thickness+tol])
               cylinder(h=inner_height, r=rod_radius, center=true);
          }
     }
}

module baseRing(pot_radius, pot_inclination, thickness, width)
{
     /// Returns a combination of cylinder and a ring
     
     // incline_shrink is the amount that the bottom of the cylinder
     // should move inward to create a conic shape that would fit the
     // inner inclination of the pot.
     incline_shrink = width * sin(pot_inclination);
     translate([0, 0, -thickness])
     union()
     {
          // top ring
          color("Blue", 1.0)
          difference()
          {
               cylinder(h=thickness,
                        r=pot_radius-thickness+width,
                        center=false);
               translate([0, 0, -tol/2])
               cylinder(h=thickness+tol,
                        r=pot_radius-thickness,
                        center=false);
          }
          // inside cylinder
          color("Green", 1.0)
          translate([0, 0, -width])
          difference()
          {
               cylinder(h=width,
                        r1=pot_radius-incline_shrink,
                        r2=pot_radius,
                        center=false);
               translate([0, 0, -tol/2])
               cylinder(h=width+tol,
                        r1=pot_radius-thickness-incline_shrink,
                        r2=pot_radius-thickness,
                        center=false);
          }

     }
}

module rodCapsOnBase(
     rod_radius,
     rod_count,
     rod_cap_height,
     rod_cap_thickness,
     rod_cap_pitch,
     rod_cap_dip,
     rod_cap_offset,
     fill_rod_caps
     ){
     /// Returns a distribution of rod caps aligned to base ring
     start = 0;
     step = 360 / rod_count;
     end = 360 -  step;
     for (theta = [start:step:end])
     {
          rotate([0, 0, theta])
          translate([rod_cap_offset, 0, -rod_cap_dip])
          rotate([0, rod_cap_pitch, 0])
          rodCap(
               height=rod_cap_height,
               rod_radius=rod_radius,
               thickness=rod_cap_thickness,
               fill_rod_cap=fill_rod_caps
               );
     }
}

/******************************************************************************/
// Adding some tolerance for safety and MOSTLY for better visual rendering
// IT IS NOT USED FOR BETTER FITTING OF PARTS
tol = 0.04;

rod_length = 480;                // millimeter
rod_radius = 5/2;                // millimeter
rod_count = 3;                   // count

rod_cap_height = 15;             // millimeter

/// pot_radius: the inner radius of the top of the pot
/// pot_inclination: the angle at the edge of the pot
pot_radius = 138/2;              // millimeter
pot_inclination = 10;            // degrees
pot_thickness = 8;               // millimeter

top_ring_radius = 50;            // millimeter

/// thickness is of the body design throughout
thickness = 2;
/// rod_cap_pitch is the angle of tilting the rod caps so that the
/// bottom and top caps would aling. The angle is caused by the
/// difference in radius of top and bottom rings, but it is also a
/// function of the rods
rod_cap_pitch = asin((pot_radius-top_ring_radius)/rod_length); // deg
/// rod_cap_dip is the translation of the rod caps along -z, so
/// that the lowest part of the cap would align with the top of the
/// base ring
rod_cap_dip = (rod_cap_height/2) * cos(rod_cap_pitch) -
     (rod_radius+thickness) * sin(rod_cap_pitch); // mm
/// bottom_rod_cap_offset is the amount translation away from z-axis
/// so that the space between the most inner side of the bottom rod
/// cap and the cylinder part of the base ring is exactly equal to pot
/// thickness (so that the pot would fit in between)
bottom_rod_cap_offset = pot_radius + pot_thickness +
     (rod_cap_height/2) * sin(rod_cap_pitch) +
     (rod_radius+thickness) * cos(rod_cap_pitch); // mm
/// top_rod_cap_offset is the amount of translation away from z-axis
/// so that the most inner side of the top rod cap aligns with the
/// inside of the top ring
top_rod_cap_offset = top_ring_radius
     + (rod_cap_height/2) * sin(rod_cap_pitch)
     + (rod_radius + thickness) * cos(rod_cap_pitch)
     - (rod_radius + thickness);
/// base_ring_width is the amount the base ring spans, computed to
/// fully cover the rod caps
base_ring_width = pot_thickness + thickness +
     2 * (rod_radius + thickness) / cos(rod_cap_pitch); // millimeter

/******************************************************************************/
// base ring
difference()
{
     union()
     {
          // get the base ring
          difference(){
               baseRing(
                    pot_radius=pot_radius,
                    pot_inclination=pot_inclination,
                    thickness=thickness,
                    width=base_ring_width
                    );
               // cut out holes for rod caps
               rodCapsOnBase(
                    rod_radius=rod_radius,
                    rod_count=rod_count,
                    rod_cap_height=rod_cap_height,
                    rod_cap_thickness=thickness,
                    rod_cap_pitch=-rod_cap_pitch,
                    rod_cap_dip=rod_cap_dip,
                    rod_cap_offset=bottom_rod_cap_offset,
                    fill_rod_caps=true
                    );
          }
          // add rod caps
          color("Red", 1.0)
          rodCapsOnBase(
               rod_radius=rod_radius,
               rod_count=rod_count,
               rod_cap_height=rod_cap_height,
               rod_cap_thickness=thickness,
               rod_cap_pitch=-rod_cap_pitch,
               rod_cap_dip=rod_cap_dip,
               rod_cap_offset=bottom_rod_cap_offset,
               fill_rod_caps=false
               );
     }
     // cut anything above the zero (i.e. the tilted parts of the rod caps)
     color("Blue", 1.0)
     cylinder(h=thickness+rod_cap_height, // going over to be sure
              r=pot_radius+base_ring_width,
              center=false);
}

// top ring
/* translate([0, 0, rod_length - 2 * rod_cap_height]) */
difference()
{
     union()
     {
          // get a ring
          color("Blue", 1.0)
          translate([0,0,-thickness])
          cylinder(h=thickness,
                   r=top_ring_radius + rod_radius + thickness,
                   center=false);
          // add rod caps
          color("Red", 1.0)
          rodCapsOnBase(
               rod_radius=rod_radius,
               rod_count=rod_count,
               rod_cap_height=rod_cap_height,
               rod_cap_thickness=thickness,
               rod_cap_pitch=180-rod_cap_pitch,
               rod_cap_dip=rod_cap_dip,
               rod_cap_offset=top_rod_cap_offset,
               fill_rod_caps=false
               );
     }
     // remove inside disk
     color("Blue", 1.0)
     translate([0, 0, -thickness - tol/2])
     cylinder(h=thickness+tol,
              r=top_ring_radius - rod_radius - thickness,
              center=false);
     // remove anything on top
     color("Blue", 1.0)
     cylinder(h=10*thickness, // going over to be sure
              r=top_ring_radius + rod_radius + rod_cap_height, // going over to be sure
              center=false);
}
