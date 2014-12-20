Brick [][]brickList;
Ball []ballList;
Ball initBall;
Bar board;

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
float ballInitY;
//float translateY;


float [] ballXPos;
float [] ballYPos;


void setup(){
  size(640,480);
  background(0,0,0);
  rectMode(CENTER);
  textAlign(CENTER);
  
  brickList = new Brick[brickCol][brickRow];
  board    = new Bar(width/2 ,435,80,3);
  ballList = new Ball[board.life];
  initBall = new Ball(0,0,0,0);
  
  ballXPos = new float[30];
  ballYPos = new float[30];
  
  //translateY = -height;
  ballInitY = board.barY - board.barHeight/2 - initBall.ballSize/2;
  
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
    //---------BONUS:BRICK FALL DOWN--------------
     /*
      translate(0,translateY);
      translateY += 20;
      if(translateY > 0){
        translateY = 0;
      }*/
    //--------------------------------------------- 
      drawLife();
      drawBrick();
      drawBar();
      drawInitBall();
      drawBall(); 
      checkBrickBounce();
      checkBrickHit();
      checkGameEnd();
      ballPath();
      break;
      
    case GAME_WIN:
      printText();
      //translateY = -height;
      break;
      
    case GAME_LOSE:
      printText();
      //translateY = -height;
      break; 
  }
}

void reset(){
  for(int i = 0; i < brickCol;i++){
    for(int j = 0; j < brickRow;j++){   
    brickList[i][j] = null;
    }
  }
  for(int i = 0; i < ballList.length; i++){
    ballList[i] = null;
  }
  for (int i = 0; i < ballXPos.length; i ++ ) {
    ballXPos[i] = 1000;
    ballYPos[i] = 1000;
  }

  brickMaker();
  setSpecial();
  board.life = 3;
  brickTotal = countBrick;
  initBall.gone = false;
  drawInitBall();
}

void drawInitBall(){
  if(!initBall.gone){
    initBall  = new Ball(board.barX,ballInitY,0,0);
    initBall.display();
  }
}

void drawBall(){
  for(int i = 0;i < ballList.length;i++){
    if(ballList[i] != null && !ballList[i].gone){   
      ballList[i].move();
      ballList[i].display();
      
      if(ballList[i].ballY-ballList[i].ballSize/2 > height){
        board.life--;
        drawLife();
        removeBall(ballList[i]);
        initBall.gone = false;
        drawInitBall();
      }
    }
  }
}

void drawBar(){
  board.move();
  board.display();
}

void drawBrick(){
  for(int i = 0;i < brickCol; i++){
    for(int j = 0;j < brickRow; j++){
      if (brickList[i][j]!=null && !brickList[i][j].hit){
        if(brickList[i][j].brickState == BRICK_NORMAL){
          fill(255/(brickRow-1)*j,255,255/(brickRow-1)*j);
          brickList[i][j].display();
        }else if(brickList[i][j].brickState == BRICK_RED){
          fill(255,0,0);
          brickList[i][j].display();
        }else if(brickList[i][j].brickState == BRICK_BLUE){
          fill(0,0,255);
          brickList[i][j].display();
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
      brickList[i][j] = new Brick(iX+(space*i),50+(space*j),BRICK_NORMAL);
    }
  }
}

void setSpecial(){
  for(int i = 0; i < 3;i++){
    int col=int(random(brickCol));
    int row=int(random(brickRow));
    if(brickList[col][row].brickState==BRICK_NORMAL){
       brickList[col][row].brickState = BRICK_RED;
    }else{
       i -= 1;
    }
  }
  for(int i = 0; i < 3;i++){
    int col=int(random(brickCol));
    int row=int(random(brickRow));
    if(brickList[col][row].brickState==BRICK_NORMAL){
       brickList[col][row].brickState = BRICK_BLUE;
    }else{
       i -= 1;
    }
  }   
}

void drawLife(){
  fill(230, 74, 96);
  textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),20);
  text("LIFE:",40, 467);
  for(int life = 0 ;life < board.life ;life++){
    ellipse(78+(25*life),460,15,15);
  }
}

void checkBrickHit(){
  for(int i = 0;i < ballList.length;i++){
    for(int j = 0;j < brickCol;j++){
      for(int k = 0; k < brickRow;k++){
        if(    ballList[i] != null 
           && !ballList[i].gone && !brickList[j][k].hit 
           &&  ballList[i].isHit(ballList[i].ballX,
                             ballList[i].ballY,
                             ballList[i].ballSize,
                             brickList[j][k].brickX,
                             brickList[j][k].brickY,
                             brickList[j][k].brickWidth,
                             brickList[j][k].brickHeight) == true){
          if(brickList[j][k].brickState == BRICK_NORMAL){
            removeBrick(brickList[j][k]);
            brickTotal--;
          }else if(brickList[j][k].brickState == BRICK_RED){
            board.barWidth -= 10;
            removeBrick(brickList[j][k]);
            brickTotal--;
          }else if(brickList[j][k].brickState == BRICK_BLUE){
            board.barWidth += 15;
            removeBrick(brickList[j][k]);
            brickTotal--;
          }
                             
        }
      }
    }
  }
}

void checkBrickBounce(){
  for(int i = 0;i < ballList.length;i++){
    for(int j = 0;j < brickCol;j++){
      for(int k = 0; k < brickRow;k++){ 
        if(    ballList[i] != null  
           && !ballList[i].gone && !brickList[j][k].hit 
           &&  ballList[i].isHit(ballList[i].ballX,
                             ballList[i].ballY,
                             ballList[i].ballSize,
                             brickList[j][k].brickX,
                             brickList[j][k].brickY,
                             brickList[j][k].brickWidth,
                             brickList[j][k].brickHeight) == true){
                               
          float distX = abs(ballList[i].ballX - brickList[j][k].brickX);
          float distY = abs(ballList[i].ballY - brickList[j][k].brickY);
          float ballR  = ballList[i].ballSize/2;     
          float brickH = brickList[j][k].brickHeight/2;
          float brickW = brickList[j][k].brickHeight/2;
          float brickTop    = brickList[j][k].brickY - brickH - 5;
          float brickBottom = brickList[j][k].brickY + brickH + 5;
          float brickLeft   = brickList[j][k].brickX - brickW - 5;
          float brickRight  = brickList[j][k].brickX + brickW + 5;
          float cornerDist_sq =   pow(distX - brickW,2) + pow(distY - brickH,2);
          
          
          
          if(ballList[i].ballX >= brickLeft && ballList[i].ballX <= brickRight){
            if(distX <= brickW +ballR){
              ballList[i].ballSpeedY *= -1;
            }
          }
          
          else if(ballList[i].ballY >= brickTop && ballList[i].ballY <= brickBottom){
            if(distY <= brickH +ballR){
              ballList[i].ballSpeedX *= -1;
            }
          } 
            
          else if((cornerDist_sq <= pow(ballR,2)) == true){
            ballList[i].ballSpeedX *= -1;
            ballList[i].ballSpeedY *= -1;
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
    }else if(board.life == 0){
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
    ballNum = ballList.length - board.life;
    ballList[ballNum] = new Ball(board.barX,ballInitY,random(-5,5),-5);
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
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),titleSize);
      text("PONG",width/2,240);
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),subTitleSize);
      text("Press ENTER to Start",width/2,280);
      break;
    
    case GAME_WIN:
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),titleSize);
      text("WIN",width/2,240);
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),subTitleSize);
      text("Press ENTER to Restart",width/2,280);
      break;
      
    case GAME_LOSE:
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),titleSize);
      text("LOSE",width/2,240);
      textFont(loadFont("data/SourceSansPro-Regular-60.vlw"),subTitleSize);
      text("Press ENTER to Restart",width/2,280);
      break;
  }
}

//---------BONUS:Ball Path--------------------------------
void ballPath(){
  for(int i = 0; i < ballXPos.length-1;i++){
    ballXPos[i] = ballXPos[i+1];
    ballYPos[i] = ballYPos[i+1];
  }
  for(int i = 0;i < ballList.length;i++){
    if(ballList[i] != null && !ballList[i].gone){
      ballXPos[ballXPos.length-1] = ballList[i].ballX;
      ballYPos[ballXPos.length-1] = ballList[i].ballY;
    }
  }
  for(int i = 0; i < ballXPos.length;i++){
    float pathSize;
    pathSize = initBall.ballSize/ballXPos.length*i;
    fill(3/ballXPos.length*i,255/ballXPos.length*i,236/ballXPos.length*i);
    ellipse(ballXPos[i],ballYPos[i],pathSize,pathSize);
  }
}
//--------------------------------------------------------
