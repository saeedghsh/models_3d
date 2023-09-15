include <../lib/color_names.scad>

tol = 0.1;
fn = 100;
alpha = 0.9;

module add_peg_hole(diameter, height, thickness, rotation_axis, concentric_offset){
    hole_diameter = height /2;
    peg_height = concentric_offset + thickness / 2;
    peg_diameter = 0.7 * hole_diameter;

    // for the square ring
    x_outer = (diameter+thickness) * sqrt(2) / 2;
    x_inner = (diameter-thickness) * sqrt(2) / 2;

    angle = rotation_axis=="x" ? 0 : 90;
    rotate([0, 0, angle])
        union(){    
        
        difference(){
            // the ring
  	        children();

    	      // holes
  	        rotate([90, 0, 0])
  	        cylinder(h=diameter+thickness+tol, d=hole_diameter, center=true, $fn=fn);
        }

        // peg to positive sides (+x and +y)
        translate([(diameter + peg_height) / 2, 0, 0])

        rotate([0, 90, 0])
        union(){
            // peg shaft
            cylinder(h=peg_height + thickness, d=peg_diameter, center=true, $fn=fn);
            // peg end disk
            translate([0, 0, (peg_height+thickness)/2])
  	        cylinder(h=thickness/2, d=peg_diameter*2, center=true, $fn=fn);
        }

        // peg to negative sides (-x and -y)
        translate([-(diameter + peg_height) / 2, 0, 0])
        rotate([0, 90, 0])
        union(){
            // peg shaft
            cylinder(h=peg_height + thickness, d=peg_diameter, center=true, $fn=fn);
            // peg end disk
            translate([0, 0, -(peg_height+thickness)/2])
  	        cylinder(h=thickness/2, d=peg_diameter*2, center=true, $fn=fn);
        }
    }
}

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
	      cylinder(h=height, d=diameter+thickness, center=true, $fn=fn);
	      cylinder(h=height+tol, d=diameter-thickness, center=true, $fn=fn);
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


thickness = 3;
height = 8;
concentric_offset = thickness + height;
max_diameter = 150;

for (i = [0: 6]) {
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
