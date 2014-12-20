class Brick {
  
  float brickWidth  = 35;
  float brickHeight = 35;
  float brickX;
  float brickY;
  int   brickState;
  boolean hit = false;
  
  Brick(float x,float y,int state){
    this.brickX = x;
    this.brickY = y;
    this.brickState = state;
  }
  
  void display(){
    rect(brickX,brickY,brickWidth,brickHeight);
  }

}
