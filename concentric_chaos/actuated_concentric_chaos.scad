include <../lib/color_names.scad>
include <../lib/formfactors.scad>
include <peg_and_hole.scad>
include <rings.scad>

//
alpha = 1;
tol = 0.01;
fragments = 300;

circle_count = 5; // Including the center one that holds the motors
height = 5;
thickness = 2;
concentric_offset = 2*(thickness + height)/3;

inner_circle_diameter = 2 * propeller_length;
outer_circle_diameter = inner_circle_diameter + (circle_count-1) * 2*concentric_offset;

module add_dc_motor_holder(dx, dy){
    motor_holder_height = 0.5 * motor_body_length;

    difference(){
        union(){
            children();

            translate([dx, dy, 0])
            cylinder(h=motor_holder_height, d=motor_body_diameter+2*thickness, center=true, $fn=fragments);
        }
        translate([dx, dy, 0])
        cylinder(h=motor_holder_height+tol, d=motor_body_diameter, center=true, $fn=fragments);
    }
}

module cross(){
    union(){
        cube([inner_circle_diameter+tol, thickness, height-tol], center=true);
        cube([thickness, inner_circle_diameter+tol, height-tol], center=true);
    }
}

module aaa_holder_grip(tran, rot){
    wall_height = aaa_holder_notch_height;
    wall_width = aaa_holder_notch_width;
    notch_depth = aaa_holder_thickness;

    translate(tran)
    rotate(rot)
    union(){
        translate([0, 0, thickness/2])
            cube(size=[aaa_holder_width+2*thickness, wall_width, thickness], center=true);
        translate([(aaa_holder_width+thickness)/2, 0, wall_height -thickness/2 -tol])
            cube(size=[thickness, wall_width, wall_height], center=true);
        translate([-(aaa_holder_width+thickness)/2, 0, wall_height -thickness/2 -tol])
            cube(size=[thickness, wall_width, wall_height], center=true);
        translate([-(aaa_holder_width+thickness)/2 +notch_depth/2, 0, wall_height +1.5*thickness -tol])
            cube(size=[thickness+notch_depth, wall_width, thickness], center=true);
        translate([(aaa_holder_width+thickness)/2 -notch_depth/2, 0, wall_height +1.5*thickness -tol])
            cube(size=[thickness+notch_depth, wall_width, thickness], center=true);
    }
}

aaa_holder_offset = 11;

color("red")
{
    aaa_holder_grip(tran=[0, -aaa_holder_offset, +(height/2 -thickness)], rot=[0, 0, 0]);
    aaa_holder_grip(tran=[-aaa_holder_offset, 0, -(height/2 -thickness)], rot=[180, 0, 90]);
}

union()
{
    formfactor_motor_and_propeller(tran=[0, propeller_length/2, 0], rot=[0, 0, 0]);
    formfactor_motor_and_propeller(tran=[propeller_length/2, 0, 0], rot=[180, 0, 0]);
    formfactor_aaa_holder(tran=[-aaa_holder_offset, 0, -(aaa_holder_height+height-tol)/2], rot=[180, 0, 90]);
    formfactor_aaa_holder(tran=[0, -aaa_holder_offset, +(aaa_holder_height+height-tol)/2], rot=[0, 0, 0]);
}

add_dc_motor_holder(dx=0, dy=propeller_length/2)
add_dc_motor_holder(dx=propeller_length/2, dy=0)
cross();

for (i = [0: circle_count-1]) {
    rotation_axis = i%2==0 ? "x" : "y";
    diameter = outer_circle_diameter - i * 2 * concentric_offset; // x2 because offset corresponds to radius

    color(color_names[1+5*i], alpha)
    add_peg_hole(
        diameter=diameter,
        height=height,
        thickness=thickness,
        rotation_axis=rotation_axis,      
        concentric_offset=concentric_offset)
    ring_ring(diameter=diameter, height=height, thickness=thickness);
}

