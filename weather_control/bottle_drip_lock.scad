thickness = 3;
cylinder_fragments = 300;
tol = 0.2;

// the measured dimensions of the bottle thread
thread_height = 19.9;
thread_diameter = 27.6;

// coloring
color_alpha=0.995;
union(){

     // bottle gripping thread
     scale([1.1, 1.1, 1]) // turned out the thread doesnt fit normal pet bootle, needs adjustment
     difference(){
          color("Red", color_alpha)
               translate([0, 0, (thread_height+tol)/2])
               cylinder(h=thread_height-tol, d=thread_diameter+thickness, center=true, $fn=cylinder_fragments);
          color("Red", color_alpha)
               // from https://www.thingiverse.com/thing:2693686
               import("../thingiverse.com/thing:2693686/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
     }

     // bottle reservoir screwing thread
     translate([0, 0, -thread_height])
     difference(){
          color("Green", color_alpha)
               // from https://www.thingiverse.com/thing:2693686
               import("../thingiverse.com/thing:2693686/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
          color("Green", color_alpha)
               translate([0, 0, (thread_height+tol)/2])
               cylinder(h=thread_height+2*tol, d=thread_diameter-2*thickness, center=true, $fn=cylinder_fragments);
     }

     // the ring at the center connecting all
     difference(){
          color("Orange", color_alpha)
               cylinder(h=thickness, d=thread_diameter+2*thickness, center=true, $fn=cylinder_fragments);
          color("Orange", color_alpha)
               cylinder(h=thickness+tol, d=thread_diameter-4*thickness, center=true, $fn=cylinder_fragments);
     }

     // water blocker cylinder
     translate([0, 0, thread_height/2])
          difference(){
          color("Indigo", color_alpha)
               cylinder(h=thread_height, d=thread_diameter-3*thickness, center=true, $fn=cylinder_fragments);
          color("Indigo", color_alpha)
               cylinder(h=thread_height+tol, d=thread_diameter-4*thickness, center=true, $fn=cylinder_fragments);
     }

     // cross and lock holder at center
     difference(){
          union(){
               // cross hold at center
               color("Yellow", color_alpha)
                    cube(size=[thread_diameter-thickness, thickness, thickness], center=true);
               color("Yellow", color_alpha)
                    rotate([0, 0, 90])
                    cube(size=[thread_diameter-thickness, thickness, thickness], center=true);
               color("Yellow", color_alpha)
                    cylinder(h=5*thickness, d=3*thickness, center=true, $fn=cylinder_fragments);
          }
          color("Yellow", color_alpha)
               cylinder(h=5*thickness+tol, d=2*thickness, center=true, $fn=cylinder_fragments);
     }

     // water lock
     translate([0, 0, thickness*2/3])
          union()
     {
          // shaft
          color("Blue", color_alpha)
               cylinder(h=2*thread_height, d=2*(thickness-tol), center=true, $fn=cylinder_fragments);
          // top disk (water blocker)
          color("Blue", color_alpha)
               translate([0, 0, +thread_height])
               cylinder(h=thickness, d=thread_diameter-3*thickness, center=true, $fn=cylinder_fragments);
          // bottom disk (fall out lock)
          color("Blue", color_alpha)
               translate([0, 0, -thread_height])
               cylinder(h=thickness, d=3*thickness, center=true, $fn=cylinder_fragments);
     }
     
}
