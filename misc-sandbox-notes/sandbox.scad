fragments = 300;
tol = 0.1;


// -------------------------------------------------------
// ----------------- Plexiglass holder - plant's cat guard
// -------------------------------------------------------
thickness_part = 10;
thickness_lack = 50;
thickness_plexiglass = 4;

let(){
    dx = 2 * thickness_part + thickness_lack + thickness_plexiglass;
    dy = 30; //(2 * thickness_part + thickness_lack) / 2;
    dz = 2 * thickness_part + thickness_lack;
    echo(dy);

    difference(){
        dist_end_to_plexiglas_center = -dx + thickness_part+thickness_plexiglass/2;
        translate([dist_end_to_plexiglas_center, 0, -dz/2])
        difference(){
            translate([dx/2, 0, 0])
            cube(size = [dx, dy, dz], center=true);
            cube(size = [2*thickness_lack, 2* thickness_lack, thickness_lack], center=true);
        }

        translate([0, 0, -(thickness_lack+thickness_part)/2])
        cube(size = [thickness_plexiglass, 2*thickness_lack, thickness_lack+thickness_part+tol], center=true);

        dist = (thickness_part+thickness_plexiglass)/2;
        translate([dist, 0, dz/2 - (dz-4*thickness_part)])
        cube(size = [thickness_part+tol, dy+tol, dz+tol], center=true);
    }
}


// // -------------------------------------------------------
// // ---------------------------- water transfer pipe holder
// // -------------------------------------------------------
// inner_diameter = 7;
// bend_radius = 10;
// bend_arc = 90;
// straight_length = 50;
// thickness = 2;

// module bend(){
//     difference(){
//         rotate_extrude(angle=bend_arc, convexity=10)
//         translate([bend_radius, 0, 0])
//         circle(r=(thickness+inner_diameter)/2, $fn=fragments);

//         rotate([0, 0, -1]) 
//         rotate_extrude(angle=bend_arc+2, convexity=10)
//         translate([bend_radius, 0, 0])
//         circle(r=inner_diameter/2, $fn=fragments);
//     }
// }
// module straight() {
//     difference(){
//         cylinder(h=straight_length, d=inner_diameter+thickness, center=true, $fn=fragments);
//         cylinder(h=straight_length+1, d=inner_diameter, center=true, $fn=fragments);

//     }    
// }

// difference(){
//     union() {
//         rotate([0, 90, 0])
//         straight();

//         translate([straight_length/2-tol, -bend_radius, 0])
//         rotate([0, 0, 90-bend_arc])
//         bend();

//         translate([-(straight_length/2-tol), -bend_radius, 0])
//         rotate([0, 0, 90])
//         bend();
//     }
//     cut_ratio = 1/5;
//     translate([0, 0, (2- cut_ratio)*inner_diameter/2])
//     cube([3*straight_length, 3*straight_length, inner_diameter], center=true);
// }

// translate([0, 0, 20]) 
// let(h = 2*thickness,
//     inner_d = inner_diameter-1,
//     outer_d = 3*inner_diameter)
// {
//     difference(){
//         cylinder(h =h, d=outer_d, $fn=fragments, center=true);
//         cylinder(h =h+tol, d=inner_d, $fn=fragments, center=true);
//     }
// }

// // -------------------------------------------------------
// // -------------------------------- guitar stand-extension
// // -------------------------------------------------------
// sleeve_height = 5;
// inner_diameter = 23;
// bottom_height = 1.5;
// thickness = 2;

// let(d = inner_diameter,
//     h = sleeve_height + bottom_height)
// {
//     difference()
//     {
//         translate([0, 0, h/2])
//         cylinder(h = h, d = d + 2* thickness, center = true, $fn=fragments);

//         cylinder(h = 10 * h, d = 0.7 * d, center = true, $fn=fragments);

//         translate([0, 0, h/2 + bottom_height])
//         cylinder(h = h, d = d, center = true, $fn=fragments);

//     }
// }

// -------------------------------------------------------
// -------------------------- stand for the woven triangle
// -------------------------------------------------------
// length = 40;
// width = 10;
// height = 7;
// gap_width = 16;
// thickness = 2;
// thread_diameter = 1.5;

// points = [
//     [length/2, 0],
//     [length/2, thickness],
//     [0, height],
//     [-length/2, thickness],
//     [-length/2, 0],
// ];

// let()
// {
//     difference(){
//         translate([0, width/2, 0])
//         rotate([90, 0, 0]) 
//         linear_extrude(height=width)
//         polygon(points);
    
//         translate([0, 0, height/2 + thickness])
//         cube([gap_width, width+tol, height], center=true);

//         translate([0, 0, thickness])
//         rotate([90, 0, 0])
//         cylinder(h=width+tol, d=thread_diameter, center=true, $fn=fragments);
//     }
// }

// -------------------------------------------------------
// -------------------------------- experiment with fillet
// -------------------------------------------------------
// module fillet(x, y, r) {
//     translate([x, y]) {
//         difference() {
//             union() {
//                 circle(r);
//                 translate([r, r]) square([width - 2*r, height - 2*r]);
//                 translate([width - 2*r, r]) circle(r);
//                 translate([r, height - 2*r]) circle(r);
//                 translate([width - 2*r, height - 2*r]) circle(r);
//             }
//             square([width, height]);
//         }
//     }
// }
// width = 40; // Width of the rectangle
// height = 20; // Height of the rectangle
// radius = 5; // Fillet radius
// fillet(0, 0, radius);


// -------------------------------------------------------
// --------------------------- pin to turn armature to top
// -------------------------------------------------------
// module center_pin(){
//     union(){
//         let(h=30, d=5){
//             translate([0, 0, +h/3])
//             cylinder(h=h, d=d, $fn=fragments, center=true);
//         }
//         let(h=10, d=5){
//             translate([0, 0, -h+tol])
//             cylinder(h=h, r1=0, r2=d/2, $fn=fragments, center=true);
//         }
//     }
// }
// module core_lock(){
//     union()
//     {
//         let(h=3, d=12.1){
//             translate([0, 0, +h/2])
//             cylinder(h=h, d=d, $fn=fragments, center=true);
//         }
//         let(h=6, d=10){
//             translate([0, 0, -h/2])
//             cylinder(h=h, d=d, $fn=fragments, center=true);
//         }
//         let(h=6, d=1.9, dx=5){
//             translate([0, dx, -h/2])
//             cylinder(h=h, d=d, $fn=fragments, center=true);
//         }
//     }
// }
// difference(){
//     core_lock();
//     center_pin();
// }
// translate([0, 0, 20])
// scale([0.97, 0.97, 1])
// center_pin();

// // -------------------------------------------------------
// // ------------------------------------ magnet cube holder
// // -------------------------------------------------------
// use <lib/extrude_directional.scad>
// thickness = 1;
// magnet_height = 2.7;
// magnet_diameter = 5;
// box_d = magnet_diameter + 2 * thickness;
// sphere_d = sqrt(magnet_diameter^2 + magnet_height^2) + 2 * thickness;

// module magnet()
// {
//     cylinder(h=magnet_height, d=magnet_diameter, $fn=fragments, center=true);
// }

// difference(){
//     cube([box_d, box_d, box_d], center=true);    
//     extrude_along_y(length=box_d)
//     magnet();

//     rotate([90, 0, 0])
//     cylinder(h=2*box_d, r=thickness, center=true, $fn=fragments);
// }