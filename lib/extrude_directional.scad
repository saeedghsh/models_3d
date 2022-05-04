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

// Extrudes the shadow of the object projected at yz plan
module extrude_along_x(length=0)
{
    union(){
        // original object
        children();
        
        // extrusion of the object
        translate([max(0, length), 0, 0])
        rotate([0, -90, 0])
        linear_extrude(height=abs(length), center=false)
        projection()
        rotate([0, 90, 0])
        children();
    }    
}

// Extrudes the shadow of the object projected at zx plan
module extrude_along_y(length=0)
{
    union(){
        // original object
        children();
        
        // extrusion of the object
        rotate([-sign(length) * 90, 0, 0])
        linear_extrude(height=abs(length), center=false)
        projection()
        rotate([sign(length) * 90, 0, 0])
        children();
    }    
}

// Extrudes the shadow of the object projected at xy plan
module extrude_along_z(length=0)
{
    union(){
        // original object
        children();
        
        // extrusion of the object
        translate([0, 0, min(0, length)])
        linear_extrude(height=abs(length), center=false)
        projection()
        children();
    }    
}

// examples
module toy_example(size=5)
{
    union(){
        cube(2*size, true);

        translate([size, 0, 0])
        sphere(size);
        translate([-size, 0, 0])
        sphere(size);
        
        translate([0, size, 0])
        sphere(size);
        translate([0, -size, 0])
        sphere(size);
        
        translate([0, 0, size])
        sphere(size);
        translate([0, 0, -size])
        sphere(size);
    }
}


%extrude_along_x(length=20)
translate([0, 20, 0])
toy_example(size=5);

%extrude_along_y(length=20)
translate([0, 0, 20])
toy_example(size=5);

%extrude_along_z(length=20)
translate([20, 0, 0])
toy_example(size=5);
