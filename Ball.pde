class Ball {
  
  float ballSize = 15;
  float ballX;
  float ballY;
  float ballSpeedX = 0;
  float ballSpeedY = 0;
  boolean shoot = false;
  boolean gone = false;
  
  Ball(float x,float y,float speedX,float speedY){
    this.ballX = x;
    this.ballY = y;
    this.ballSpeedX = speedX;
    this.ballSpeedY = speedY;
  }

  void display(){
    fill(3,255,236);
    ellipse(ballX,ballY,ballSize,ballSize);
  }
  
  void move(){
    ballX += ballSpeedX;
    ballY += ballSpeedY;
   
    if(ballX < ballSize/2 || ballX > width-ballSize/2){
      ballSpeedX *= -1;
    }
    if(ballY < ballSize/2 ){
      ballSpeedY *= -1;
    }
    
    float ballBottom = ballY + ballSize/2;
    float ballBl   = board.barY - board.barHeight/2;
    float barLeft  = board.barX - board.barWidth/2;
    float barRight = board.barX + board.barWidth/2;
    
    if(ballBottom > ballBl && ballX > barLeft && ballX < barRight){
      ballY -= ballSize;
      ballSpeedY *= -1;
    }
  }
  
  boolean isHit(float ballX,float ballY,float ballSize,
                float objX,float objY,float objW,float objH){
      float ballDistX = abs(ballX - objX);
      float ballDistY = abs(ballY - objY);
      
      if(ballDistX > (objW/2 + ballSize/2) ||
         ballDistY > (objH/2 + ballSize/2)   ){ 
        return false; 
      }
      if(ballDistX <= (objW/2 + ballSize/2) ||
         ballDistY <= (objH/2 + ballSize/2)  ){ 
        return true; 
      }
      
      float cornerDist_sq = pow(ballDistX - objW/2,2) 
                          + pow(ballDistY - objH/2,2);
   
      return (cornerDist_sq <= pow(ballSize/2,2));
  }
  
}
