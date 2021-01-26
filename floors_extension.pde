import java.awt.Robot;

//color
color white = #FFFFFF; //empty space
color black = #000000; //oak plank
color purple = #AE81FF;  
color lime = #9BF0C3;
color dullBlue = #7092BE; //mossybricks

//texture
PImage mossyStone;
PImage oakPlank;
PImage dirt;
PImage grass_top, grass_side;

//map variables
int gridSize;
PImage map;

Robot rbt;

//Camera variables
float eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz;

//Interaction
boolean wkey, akey, skey, dkey;

//Rotation variables
float leftRightAngle;
float upDownAngle; 

PImage[] gif;
String leadingZeroI;
String leadingZeroII;
int frame;
float c;


void setup() {
  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  leftRightAngle = 0;
  upDownAngle = 0;

  size(displayWidth, displayHeight, P3D);

  eyex = height/2;
  eyey = 9*height/10;
  eyez = height/2; 

  focusx = eyex;
  focusy = eyey;
  focusz = eyez - 100;

  upx = 0;
  upy = 1;
  upz = 0;

  frame = 0;
  leadingZeroI = "0";
  leadingZeroII = "0";
  gif = new PImage[347];
  c = 0;
  
  for (int i = 0; i < 347; i++) {
    if ( i >= 10) {
      leadingZeroII = "";
    }
    if(i >= 100) {
      leadingZeroI = "";
    }
    gif[i] = loadImage("frame_" + leadingZeroI + leadingZeroII + i + "_delay-0.05s.gif");
  }
  
  //initialize texture
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  oakPlank = loadImage("Oak_Planks.png");
  dirt = loadImage("dirt.png");
  grass_top = loadImage("grass_top.png");
  grass_side = loadImage("grass_side.png");
  textureMode(NORMAL);
  
  //initialize map
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() { 
  background(0);
  pushMatrix();
  translate(-350, 1300, 1890);
  image(gif[frame], 0, 0, 480,  270);
  c = c++;
  if (c < 1.5) {
    c++;
  } else {
    c = 0;
    frame++;
  }

  if (frameCount < 2) {
    rbt.mouseMove(width/2, height/2);
    mouseX = width/2;
    mouseY = height/2;
  }
  
  if (frame >= 346) {
     frame = 0; 
  }
  popMatrix();
  
  lights();

  //line(x1, y1, z1, x2, y2, z2);

  camera(eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz);
  move();
  drawAxis();
  drawFloor(-2000, 2000, height, gridSize);                 //floor
  //drawFloor(-2000, 2000, height-gridSize*3, 100);      //ceiling
  drawInterface();
  drawMap();
  
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for(int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue || c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
      }
    }
  }

}

void drawInterface() { 
  pushMatrix();
  stroke(200, 0, 0);
  strokeWeight(5);
  line(width/2-10, height/2, width/2+10, height/2);
  line(width/2, height/2-10, width/2, height/2+10);
  popMatrix();
}

void move() { 
  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(5);
  popMatrix();


  if(akey && canMoveLeft() ) {
   eyex += cos(leftRightAngle - PI/2)*10;
   eyez += sin(leftRightAngle - PI/2)*10;
 }
 if(dkey && canMoveRight() ) {
   eyex += cos(leftRightAngle + PI/2)*10;
   eyez += sin(leftRightAngle + PI/2)*10; 
 }
 if(wkey && canMoveForward() ) {
   eyex += cos(leftRightAngle)*10;
   eyez += sin(leftRightAngle)*10;
 }
 if(skey && canMoveBack() ) {
   eyex -= cos(leftRightAngle)*10;
   eyez -= sin(leftRightAngle)*10;
 }

  focusx = eyex + cos(leftRightAngle)*300;
  focusy = eyey + tan(upDownAngle)*300;
  focusz = eyez + sin(leftRightAngle)*300;

  leftRightAngle += (mouseX - pmouseX)*0.002;
  upDownAngle += (mouseY-pmouseY)*0.002;

  if (upDownAngle > PI/2.5) upDownAngle = PI/2.5;
  if (upDownAngle < -PI/2.5) upDownAngle = -PI/2.5;

  if (mouseX > width-2) rbt.mouseMove (3, mouseY);
  if (mouseX < 2) rbt.mouseMove(width-3, mouseY); //3 so it doesn't trigger the other if statement 

  //leftRightAngle += 0.01;
  //upDownAngle += 0.01
}

boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;
  
  fwdx = eyex + cos(leftRightAngle)*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle)*200;
  
  mapx = int(fwdx+2000)/gridSize;
  mapy = int(fwdz+2000)/gridSize;
  
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveLeft() {
  float leftx, lefty, leftz;
  int mapx, mapy;
  
  leftx = eyex - cos(leftRightAngle+radians(90))*200;
  lefty = eyey;
  leftz = eyez - sin(leftRightAngle+radians(90))*200;
  
  mapx = int(leftx+2000)/gridSize;
  mapy = int(leftz+2000)/gridSize;
  
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }

}

boolean canMoveRight () {
  float rightx, righty, rightz;
  int mapx, mapy;
  
  rightx = eyex - cos(leftRightAngle-radians(90))*200;
  righty = eyey;
  rightz = eyez - sin(leftRightAngle-radians(90))*200;
  
  mapx = int(rightx+2000)/gridSize;
  mapy = int(rightz+2000)/gridSize;
  
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }

}

boolean canMoveBack() {
  float backx, backy, backz;
  int mapx, mapy;
  
  backx = eyex - cos(leftRightAngle)*200;
  backy = eyey;
  backz = eyez - sin(leftRightAngle)*200;
  
  mapx = int(backx+2000)/gridSize;
  mapy = int(backz+2000)/gridSize;
  
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }

}

void drawAxis() {
  stroke(200, 0, 0);
  strokeWeight(3);
  line(0, 0, 0, 1000, 0, 0); //x axis
  line(0, 0, 0, 0, 1000, 0); //y axis
  line(0, 0, 0, 0, 0, 1000); //z axis
}

void drawFloor(int start, int end, int floorHeight, int floorSpacing) { 
  stroke(255);
  //line(width/2, height, -1000, width/2, height, 1000);

  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, floorHeight, z, oakPlank, floorSpacing);
    x += floorSpacing;
    if (x >= end) {
      x = start;
      z += floorSpacing;
    }
  }

  //for (int x = -2000; x < 2000; x += 100) {
}
