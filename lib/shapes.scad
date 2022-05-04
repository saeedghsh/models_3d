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

// Returns a regular polygon, centered at origin, where radius is the
// distance from center to the middle of edges
module regularPolygon(order, radius)
{
    // the radius is from center to middle of edge
    // node_radius is from center to node
    node_radius = radius / cos(360 / (order * 2));
    nodes = [
        for (i = [0 : order-1])
        [node_radius * cos(i * (360/order)),
         node_radius * sin(i * (360/order))]
    ];
    polygon(nodes);
}
