//WHAT WE ARE USING
  //Projection Matrix: takes 4D point and put in 3D space
  //Rotation Matrix: rotates the tesseract in weird shapes

float angle = 0;

  //Do the math of making a 4D shape into 3D and project it onto a 2D surface

//A hypercube is mad eof 16 verticies
P4Vector[] points = new P4Vector[16];

void setup(){
  //set mode to 3D
  rectMode(CENTER);
  size(600, 600, P3D);
  
  
  
  //POINT DECLARATION
  //x, y, z, w
  //if you move the points along the w axis, you'll get the points moving into a diagonal type thing
  points[0] = new P4Vector(-1, -1, -1, 1);
  points[1] = new P4Vector(1, -1, -1, 1);
  points[2] = new P4Vector(1, 1, -1, 1);
  points[3] = new P4Vector(-1, 1, -1, 1);
  points[4] = new P4Vector(-1, -1, 1, 1);
  points[5] = new P4Vector(1, -1, 1, 1);
  points[6] = new P4Vector(1, 1, 1, 1);
  points[7] = new P4Vector(-1, 1, 1, 1);
  //second cube
  points[8] = new P4Vector(-1, -1, -1, -1);
  points[9] = new P4Vector(1, -1, -1, -1);
  points[10] = new P4Vector(1, 1, -1, -1);
  points[11] = new P4Vector(-1, 1, -1, -1);
  points[12] = new P4Vector(-1, -1, 1, -1);
  points[13] = new P4Vector(1, -1, 1, -1);
  points[14] = new P4Vector(1, 1, 1, -1);
  points[15] = new P4Vector(-1, 1, 1, -1);
}

void draw (){
  background(0);      //173, 216, 230
  ambientLight(128, 128, 128);
  translate(width/2, height/2);
  rotateX(-PI/2);

  PVector[] projected3D = new PVector[16];
  
  //DRAW THE POINTS
  for (int i = 0; i < points.length; i++) {
    P4Vector v = points[i];
    stroke(255);
    //strokeWeight(8);
    noFill();
    
    
 //ROTATION MATRIX
    //https://en.wikipedia.org/wiki/Rotation_matrix
    
    float[][] rotationXY = {
      {cos(angle), -sin(angle), 0, 0},
      {sin(angle), cos(angle), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
    };
    
    float[][] rotationZW = {
      //rows down: x, y, z, w 
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, cos(angle), -sin(angle)},
      {0, 0, sin(angle), cos(angle)},
    };
   
   //Definition of Rotations
   P4Vector rotated = matmul(rotationXY, v, true);
    rotated = matmul(rotationZW, rotated, true);
    
    //the camera is two units away
    float distance = 2;
    
    //PERSPECTIVE PROJECTION FORMULA
    //https://www.scratchapixel.com/lessons/3d-basic-rendering/perspective-and-orthographic-projection-matrix/building-basic-perspective-projection-matrix
    //get the w of the value created after rotation
    float w = 1/(distance - rotated.w);  
    
    
    //PROJECTION MATRIX
    float[][] projection = {
      {w, 0, 0, 0},
      {0, w, 0, 0},
      {0, 0, w, 0}
    };
    
    //MULTIPLY THE PROJECTION AND ROTATION MATRICIES
    PVector projected = matmul(projection, rotated);
    //multiplication operator so the cube scales up from the unit vector sizes we defined in setup
    projected.mult(100);
    
    projected3D[i] = projected;
    
    point(projected.x, projected.y, projected.z);
    
}

  //INSIDE LINES
  for(int i = 0; i < 4; i++){
    connect(0, i, (i+1) % 4, projected3D);
    connect(0, i+4, ((i+1) % 4)+4, projected3D);
    connect(0, i, i+4, projected3D);
  }
  
  //OUTSIDE LINES
  for(int i = 0; i < 4; i++){
    connect(8, i, (i+1) % 4, projected3D);
    connect(8, i+4, ((i+1) % 4)+4, projected3D);
    connect(8, i, i+4, projected3D);
  }
  
  //DIAGONAL LINES
  for(int i = 0; i < 8; i++){
    connect(0, i, i+8, projected3D);
  }
  

angle +=0.02;
}

//The function which defines how the points will be connected
//because this is a 4D shape, it's necessary to introduce an offset, which basically keeps the cube from doing the weird cross-diagonal connecting lines thing
void connect(int offset, int i, int j, PVector[] points){
  PVector a = points[i+offset];
  PVector b = points[j+offset];
  strokeWeight(5);
  stroke(0, 100, 100);
  //translate(a.x + a.y, a.z + b.x, b.y + b.z);
 // box(a.x + a.y, a.z + b.x, b.y + b.z);
  // quad(x1, y1, x2, y2, x3, y3, x4, y4)
   line(a.x, a.y, a.z, b.x, b.y, b.z);
}

//void drawCylinder(int sides, float r, float h)
//{
//    float angle = 360 / sides;
//    float halfHeight = h / 2;
//    // draw top shape
//    beginShape();
//    for (int i = 0; i < sides; i++) {
//        float x = cos( radians( i * angle ) ) * r;
//        float y = sin( radians( i * angle ) ) * r;
//        vertex( x, y, -halfHeight );    
//    }
//    endShape(CLOSE);
//    // draw bottom shape
//    beginShape();
//    for (int i = 0; i < sides; i++) {
//        float x = cos( radians( i * angle ) ) * r;
//        float y = sin( radians( i * angle ) ) * r;
//        vertex( x, y, halfHeight );    
//    }
//    endShape(CLOSE);
    
//    // draw body
//    beginShape(TRIANGLE_STRIP);
//      for (int i = 0; i < sides + 1; i++) {
//      float x = cos( radians( i * angle ) ) * r;
//      float y = sin( radians( i * angle ) ) * r;
//      vertex( x, y, halfHeight);
//      vertex( x, y, -halfHeight);    
//      }
//    endShape(CLOSE);
//}
