//used in perc()
depth = 105;
width = 30;
thickness = 2;
holeSize = 1;
tube = 10;
numHoles = 20;
bore = tube/2-thickness;

//used in lid()
twistRes = 1000;  //render at 300?
pitch = 5.9;
mouthOD = 66.1;
threadHeight = 6;
tolerance = .2;
$fn=50;

//used in slide
vinyl = 8;  //ID for vinyl tubing. 5/16" is 7.9375mm, 8 will be snug
tubeOffset = mouthOD/2-6;

display();
//OR
//print();
//OR individually
// perc();
// lid();
// slide();

module print(){
	translate([-mouthOD+8,0,0]) perc();
	translate([0,0,thickness*2]) lid();
	translate([-mouthOD+3,width,0]) slide();
}

module display(){
	translate([0,0,-depth-thickness]) perc();
	translate([0,0,0]) rotate([180,0,0]) lid();
	translate([0,0,30]) rotate([180,0,0]) slide();
}

module slide(){
	difference(){
		union(){
			intersection(){
				cylinder(r=tube, h=30);
				cylinder(r1=30, r2=0, h=43);
			}
			translate([15,0,20]) cube([tubeOffset,thickness*2,10], center=true);
			translate([tubeOffset,0,0]) intersection(){
				cylinder(r=vinyl/2, h=30);
				translate([0,0,0]) cylinder(r1=30, r2=0, h=33);
			}
		}
		//holes
		translate([0,0,-.01]) cylinder(r2=0, r1=14.3/2+1, h=120);
		translate([tubeOffset,0,-1]) cylinder(r=vinyl/4+tolerance, h=42);
	
	}	
}

module lid(){
	color("orange") {
		difference(){
			//flat lid area
			intersection(){
				translate([0,0,-thickness*2]) union(){
					translate([0,0,17+thickness]) cylinder(r1=mouthOD/2+thickness*5, r2=mouthOD/2+thickness*3, h=thickness*2);
					translate([0,0,thickness*2]) cylinder(r=mouthOD/2+thickness*5, h=17-thickness);
					cylinder(r2=mouthOD/2+thickness*5, r1=mouthOD/2+thickness*3, h=thickness*2);
				}
				union(){
					scale(1.02) import("regular_mouth_jar_lid.stl", convexity=10);
					difference(){
						cylinder(r=mouthOD/2+thickness*4, h=17);
						cylinder(r=mouthOD/2+4, h=21);
					}
					translate([0,0,-thickness*2]) cylinder(r=mouthOD/2+thickness*4, h=thickness*2);
					cylinder(r=tube/2+thickness, h=20);
					//bevel
					translate([0,0,thickness]) cylinder(r1=tube, r2=tube/2+thickness, h=thickness*2);
					//grips
					for(i=[0:360/numHoles:360]){
						rotate([0,0,i]) translate([mouthOD/2+thickness*4,0,-thickness*2]) cylinder(r= 2, h=17+thickness*2);
					}
				}
			}
			//HOLES BELOW
			//center
			translate([0,0,-depth/2]) cylinder(r=tube/2+tolerance, h=depth);
			translate([0,0,-.1]) cylinder(r1=tube+tolerance, r2=tube/2, h=thickness*2);
			translate([0,0,-thickness*2-.25]) cylinder(r=tube+tolerance, h=thickness*2+.2);
			//for exhaust
			translate([tubeOffset,0,-thickness*2.01]) cylinder(r=vinyl/2+tolerance, h=thickness*2);
			translate([tubeOffset,0,-.1]) cylinder(r2=vinyl/4+tolerance, r1=vinyl/2+tolerance, h=2.5);
			translate([tubeOffset,0,-5]) cylinder(r=vinyl/4+tolerance, h=10);	
			
			//carb
			translate([-tubeOffset,0,-5]) cylinder(r=vinyl/4+tolerance, h=10);	
			
		}

	}
}

module threads(){
	union(){
		screw();
		translate([0,0,pitch]) screw();
		translate([0,0,pitch*2,]) screw();
		translate([0,0,pitch*3,]) screw();
		translate([0,0,0]) cylinder(r=mouthOD/2, h=4*pitch);
	}
}

module screw(){
	for(i=[ 0 : 360/twistRes : 360 ]){
		 rotate([0,0,i]) translate([mouthOD/2, 0, pitch*(i/360)]) sphere(1.5, $fn=20);
	}
}

module perc(){
	color("YellowGreen") difference(){
		//drop tube
		translate([0,0,0]) union(){
			//positive tube
			cylinder(r=tube/2, h = depth-width/2, $fn=36);
			//positive cone
			cylinder(r1=width/2+thickness, r2=tube/2, h = width/2+thickness, $fn=36);
		}
		
		//negative tube
		translate([0,0,thickness]) cylinder(r=bore, h = depth-width/2+2);
		//negative cone
		translate([0,0,thickness]) cylinder(r1=(width-thickness*4)/2, r2=(tube-thickness*3)/2, h = width/2);
		//holes
		translate([0,0,thickness+holeSize]) for(i = [0 : 360/numHoles*2 : 360]){
			rotate([0,45,i]) cube([holeSize,width+thickness, holeSize], center = true);
		}
		translate([0,0,3*thickness+holeSize]) for(i = [0 : 360/numHoles*2 : 360]){
			rotate([0,45,i+360/numHoles]) cube([holeSize,width+thickness, holeSize], center = true);
		}
	
	}
}