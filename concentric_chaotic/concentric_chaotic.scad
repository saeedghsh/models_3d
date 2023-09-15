include <../lib/color_names.scad>
include <peg_and_hole.scad>

alpha = 0.9;

module octagon_ring(diameter, height, thickness){
    x_outer = (diameter+thickness) * sqrt(2) / 2;
    x_inner = (diameter-thickness) * sqrt(2) / 2;

  	difference(){
  	  union(){
  	    rotate([0, 0, 45])
  	      cube(size=[x_outer, x_outer, height], center=true);
  	    cube(size=[x_outer, x_outer, height], center=true);
  	  }
  	  union(){
  	    rotate([0, 0, 45])
  	      cube(size=[x_inner, x_inner, height+tol], center=true);
  	    cube(size=[x_inner, x_inner, height+tol], center=true);
  	  }
  	}
}

module ring_ring(diameter, height, thickness){
	  difference(){
	      cylinder(h=height, d=diameter+thickness, center=true, $fn=fragments);
	      cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fragments);
	  }
}

module square_ring(diameter, height, thickness){
    x_outer = (diameter+thickness) * sqrt(2) / 2;
    x_inner = (diameter-thickness) * sqrt(2) / 2;
	  rotate([0, 0, 45])
	  difference(){
	      cube(size=[x_outer, x_outer, height], center=true);
	      cube(size=[x_inner, x_inner, height+tol], center=true);
	  }
}

max_diameter = 150;
circle_count = 7;
thickness = 3;
height = 8;

concentric_offset = thickness + height;
for (i = [0: circle_count-1]) {
    rotation_axis = i%2==0 ? "x" : "y";
    diameter = max_diameter - i * 2 * concentric_offset; // x2 because offset corresponds to radius

    color(color_names[1+5*i], alpha)
    add_peg_hole(
        diameter=diameter,
        height=height,
        thickness=thickness,
        rotation_axis=rotation_axis,      
        concentric_offset=concentric_offset)
    octagon_ring(diameter=diameter, height=height, thickness=thickness);
}
