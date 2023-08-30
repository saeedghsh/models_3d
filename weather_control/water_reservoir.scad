tol = 0.01;
thickness = 3;
fragments = 300;

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
inner_hallow_z = 25; // the height of water channel, defines the height of witer in reservior

// trigger to release the bottle cap lock
trigger_height = inner_hallow_z + 7;
trigger_diameter = 5;

// The size of the rectangular part (body) of the outer shell
outer_shell_x = inner_hallow_x;
outer_shell_y = inner_hallow_y + thickness;
outer_shell_z = thread_height + inner_hallow_z + thickness - 1;

// coloring
outer_shell_color = "Green";
inner_hallow_color = "Blue";
bottle_thread_color = "Red";
color_alpha=0.995;

/* use <../lib/splitter.scad> */
/* #split_along_yz(max_size=400, offset=10) */
/* translate([thickness+0.01, 0, 0]) */
/* rotate([0, -90, 0]) */
difference(){
     // outer shell
     union()
     {
          // body
          color(outer_shell_color, color_alpha)
               translate([outer_shell_x/2, 0, outer_shell_z/2])
               cube(size=[outer_shell_x, outer_shell_y, outer_shell_z], center=true);
          
          // humidifier side
          color(outer_shell_color, color_alpha)
               translate([outer_shell_x, 0, outer_shell_z/2])
               cylinder(h=outer_shell_z, d=floatie_diameter+ 2*(floatie_leeway+thickness), center=true, $fn=fragments);
          
          // threaded side
          color(outer_shell_color, color_alpha)
               translate([0, 0, outer_shell_z/2])
               cylinder(h=outer_shell_z, d=outer_shell_y, center=true, $fn=fragments);
     
     }
     
     // inner hallow
     union()
     {
          // body
          color(inner_hallow_color, color_alpha)
               translate([outer_shell_x/2, 0, inner_hallow_z/2 + thickness])
               cube(size=[outer_shell_x, inner_hallow_y, inner_hallow_z], center=true);
          
          // humidifier side
          color(inner_hallow_color, color_alpha)
               translate([outer_shell_x, 0, outer_shell_z/2 + thickness])
               cylinder(h=outer_shell_z, d=floatie_diameter+2*floatie_leeway, center=true, $fn=fragments);
          
          // threaded side
          color(inner_hallow_color, color_alpha)
               translate([0, 0, inner_hallow_z/2 + thickness])
               cylinder(h=inner_hallow_z, d=inner_hallow_y, center=true, $fn=fragments);
     }

     // bottle thread
     color(bottle_thread_color, color_alpha)
          translate([0, 0, outer_shell_z-thread_height])
          // from https://www.thingiverse.com/thing:2693686
          import("../thingiverse.com/thing:2693686/PCO1881__Soda_Bottle__Thread_profile_for_Fusion360_2693686/files/PCO1881_outer_thread.stl");
}

// trigger to release the bottle cap lock
color("magenta")
translate([0, 0, trigger_height/2 + thickness - 10* tol])
cylinder(h=trigger_height, d=trigger_diameter, center=true, $fn=fragments);

