class Bar {
  
  float barHeight = 20;
  float barWidth;
  float barX;
  float barY;
  int life;
  
  Bar(int x,int y,int barLength,int l){
    this.barX = x; 
    this.barY = y;
    this.barWidth = barLength;
    life = l;
  }
  
  void display(){
    fill(100,100,100);
    rect(barX,barY,barWidth,barHeight);
    
   //---------BONUS:FACE--------------------------
    if(frameCount%200 >= 0 && frameCount%200 < 10){
    fill(255);
    ellipse(barX-barWidth/3,barY,0,0);
    ellipse(barX+barWidth/3,barY,0,0);
    fill(0);
    ellipse(barX-barWidth/3,barY,0,0);
    ellipse(barX+barWidth/3,barY,0,0);
    fill(255,0,0);
    rect(barX,barY+5,barHeight,3);
    }else{
    fill(255);
    ellipse(barX-barWidth/3,barY,barHeight*3/2,barHeight*3/2);
    ellipse(barX+barWidth/3,barY,barHeight*3/2,barHeight*3/2);
    fill(0);
    ellipse(barX-barWidth/3,barY-3,barHeight,barHeight);
    ellipse(barX+barWidth/3,barY-3,barHeight,barHeight);
    fill(255,0,0);
    arc(barX,barY+5,barHeight,barHeight,0,PI,CHORD);
    }
  //-------------------------------------------------
  }
  
  void move(){ 
    if(mouseX < barWidth/2){
      barX = barWidth/2;
    }else if(mouseX > width - barWidth/2){
      barX = width - barWidth/2;
    }else{
      barX = mouseX;
    }
  }
  
}
