Brick [][]brick;
Ball []ball;
Ball initBall;
Bar bar;

final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_WIN     = 2;
final int GAME_LOSE    = 3;
final int GAME_OPENING = 4;

final int BRICK_NORMAL = 0;
final int BRICK_RED    = 1;
final int BRICK_BLUE   = 2;

int gameState;
int brickCol = 10;
int brickRow = 5;
int countBrick;
int brickTotal;
int translateY;
float ballInitY;


void setup(){
  size(640,480);
  background(0,0,0);
  rectMode(CENTER);
  textAlign(CENTER);
  
  brick = new Brick[brickCol][brickRow];
  bar   = new Bar(width/2 ,440,80,3);
  ball     = new Ball[bar.life];
  initBall = new Ball(0,0,0,0);
  
  translateY = -height;
  ballInitY = bar.barY - bar.barHeight/2 - initBall.ballSize/2;
  
  gameState = GAME_START;
  reset();
}

void draw(){
  background(250,255,150);
  noStroke();
  
  switch(gameState){
    case GAME_START:
      printText();
      break;
      
    case GAME_PLAYING:
    ---------BONUS:BRICK FALL DOWN--------------
      translate(0,translateY);
      translateY += 20;
      if(translateY > 0){
        translateY = 0;
      }
    //--------------------------------------------- 
      drawLife();
      drawBrick();
      drawBar();
      drawInitBall();
      drawBall(); 
      checkBrickBounce();
      checkBrickHit();
      checkGameEnd();
      break;
      
    case GAME_WIN:
      printText();
      translateY = -height;
      break;
      
    case GAME_LOSE:
      printText();
      translateY = -height;
      break; 
  }
}

void reset(){
  for(int i = 0; i < brickCol;i++){
    for(int j = 0; j < brickRow;j++){   
    brick[i][j] = null;
    }
  }
  for(int i = 0; i < ball.length; i++){
    ball[i] = null;
  }
  brickMaker();
  setSpecial();
  bar.life = 3;
  brickTotal = countBrick;
  initBall.gone = false;
  drawInitBall();
}

void drawInitBall(){
  if(!initBall.gone){
    initBall  = new Ball(bar.barX,ballInitY,0,0);
    initBall.display();
  }
}

void drawBall(){
  for(int i = 0;i < ball.length;i++){
    if(ball[i] != null && !ball[i].gone){   
      ball[i].move();
      ball[i].display();
      
      if(ball[i].ballY+ball[i].ballSize/2 > height){
        bar.life--;
        drawLife();
        removeBall(ball[i]);
        initBall.gone = false;
        drawInitBall();
      }
    }
  }
}

void drawBar(){
  bar.move();
  bar.display();
}

void drawBrick(){
  for(int i = 0;i < brickCol; i++){
    for(int j = 0;j < brickRow; j++){
      if (brick[i][j]!=null && !brick[i][j].hit){
        if(brick[i][j].brickState == BRICK_NORMAL){
          fill(255/(brickRow-1)*j,255,255/(brickRow-1)*j);
          brick[i][j].display();
        }else if(brick[i][j].brickState == BRICK_RED){
          fill(255,0,0);
          brick[i][j].display();
        }else if(brick[i][j].brickState == BRICK_BLUE){
          fill(0,0,255);
          brick[i][j].display();
        }
      }
    }
  }
}

void brickMaker(){
  Brick brickA = new Brick(0,0,BRICK_NORMAL);
  float space = 45;
  float bWidth;
  float iX;
  countBrick = brickCol*brickRow;
  bWidth = brickCol*brickA.brickWidth + (brickCol-1)*(space-brickA.brickWidth);
  iX = width/2 - bWidth/2 + brickA.brickWidth/2;

  for(int i = 0;i < brickCol;i++){
    for(int j = 0;j < brickRow;j++){
      brick[i][j] = new Brick(iX+(space*i),50+(space*j),BRICK_NORMAL);
    }
  }
}

void setSpecial(){
  for(int i = 0; i < 3;i++){
    int col=int(random(brickCol));
    int row=int(random(brickRow));
    if(brick[col][row].brickState==BRICK_NORMAL){
       brick[col][row].brickState = BRICK_RED;
    }else{
       i -= 1;
    }
  }
  for(int i = 0; i < 3;i++){
    int col=int(random(brickCol));
    int row=int(random(brickRow));
    if(brick[col][row].brickState==BRICK_NORMAL){
       brick[col][row].brickState = BRICK_BLUE;
    }else{
       i -= 1;
    }
  }   
}

void drawLife(){
  fill(230, 74, 96);
  text("LIFE:",40, 467);
  for(int life = 0 ;life < bar.life ;life++){
    ellipse(78+(25*life),460,15,15);
  }
}

void checkBrickHit(){
  for(int i = 0;i < ball.length;i++){
    for(int j = 0;j < brickCol;j++){
      for(int k = 0; k < brickRow;k++){
        if(    ball[i] != null 
           && !ball[i].gone && !brick[j][k].hit 
           &&  ball[i].isHit(ball[i].ballX,
                             ball[i].ballY,
                             ball[i].ballSize,
                             brick[j][k].brickX,
                             brick[j][k].brickY,
                             brick[j][k].brickWidth,
                             brick[j][k].brickHeight) == true){
          if(brick[j][k].brickState == BRICK_NORMAL){
            removeBrick(brick[j][k]);
            brickTotal--;
          }else if(brick[j][k].brickState == BRICK_RED){
            bar.barWidth -= 10;
            removeBrick(brick[j][k]);
            brickTotal--;
          }else if(brick[j][k].brickState == BRICK_BLUE){
            bar.barWidth += 10;
            removeBrick(brick[j][k]);
            brickTotal--;
          }   
        }
      }
    }
  }
}

void checkBrickBounce(){
  for(int i = 0;i < ball.length;i++){
    for(int j = 0;j < brickCol;j++){
      for(int k = 0; k < brickRow;k++){ 
        if(    ball[i] != null  
           && !ball[i].gone && !brick[j][k].hit 
           &&  ball[i].isHit(ball[i].ballX,
                             ball[i].ballY,
                             ball[i].ballSize,
                             brick[j][k].brickX,
                             brick[j][k].brickY,
                             brick[j][k].brickWidth,
                             brick[j][k].brickHeight) == true){
                               
          float distX = abs(ball[i].ballX - brick[j][k].brickX);
          float distY = abs(ball[i].ballY - brick[j][k].brickY);
          float ballR  = ball[i].ballSize/2;     
          float brickH = brick[j][k].brickHeight/2;
          float brickW = brick[j][k].brickHeight/2;
          float brickTop    = brick[j][k].brickY - brickH;
          float brickBottom = brick[j][k].brickY + brickH;
          float brickLeft   = brick[j][k].brickX - brickW;
          float brickRight  = brick[j][k].brickX + brickW;
          float cornerDist_sq =   pow(distX - brickW,2) + pow(distY - brickH,2);
          
          if(ball[i].ballX >= brickLeft && ball[i].ballX <= brickRight){
            if(distX <= brickW +ballR){
              ball[i].ballSpeedY *= -1;
            }
          }
          
          if(ball[i].ballY >= brickTop && ball[i].ballY <= brickBottom){
            if(distY <= brickH +ballR){
              ball[i].ballSpeedX *= -1;
            }
          } 
            
          if((cornerDist_sq <= pow(ballR,2)) == true){
            ball[i].ballSpeedX *= -1;
            ball[i].ballSpeedY *= -1;
          } 
        }
      }
    }
  }
}

void checkGameEnd(){
  if(gameState == GAME_PLAYING){
    if(brickTotal == 0){
      gameState = GAME_WIN;
    }else if(bar.life == 0){
      gameState = GAME_LOSE;
    }
  }
}

void removeBall(Ball byeBall){
  byeBall.gone = true;
  byeBall.ballX = 1000;
  byeBall.ballY = 1000;
}

void removeBrick(Brick byeBrick){
  byeBrick.hit    = true;
  byeBrick.brickX = 1000;
  byeBrick.brickY = 1000;
  
}

void keyPressed(){
  if (key == ENTER) {
    switch(gameState) {
      case GAME_START:
        gameState = GAME_PLAYING;
        break;
  
      case GAME_WIN:
        reset();
        gameState = GAME_PLAYING;
        break;
        
      case GAME_LOSE:
        reset();
        gameState = GAME_PLAYING;
        break;
    }
  }
}

void mousePressed(){
  int ballNum;
  if(mouseButton == RIGHT && gameState == GAME_PLAYING 
     && initBall.shoot == false){
    ballNum = ball.length - bar.life;
    ball[ballNum] = new Ball(bar.barX,ballInitY,random(-5,5),-5);
    initBall.shoot = true;
    removeBall(initBall);
  }
}

void mouseReleased(){ 
  if(initBall.gone){
    removeBall(initBall);
  }
}

void printText(){
  int titleSize = 60;
  int subTitleSize = 20;  
  fill(0,0,0);
  
  switch(gameState){
    case GAME_START:
      textSize(titleSize);
      text("PONG",width/2,240);
      textSize(subTitleSize);
      text("Press ENTER to Start",width/2,280);
      break;
    
    case GAME_WIN:
      textSize(titleSize);
      text("WIN",width/2,240);
      textSize(subTitleSize);
      text("Press ENTER to Restart",width/2,280);
      break;
      
    case GAME_LOSE:
      textSize(titleSize);
      text("LOSE",width/2,240);
      textSize(subTitleSize);
      text("Press ENTER to Restart",width/2,280);
      break;
  }
}
