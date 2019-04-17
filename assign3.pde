final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;
int grid=80; 
float groundhogX=grid*4, groundhogY=grid;
float soiloffset=0;
float soldierX=-80; float soldierY;
float cabbageX, cabbageY;
final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144,START_BUTTON_H = 60,START_BUTTON_X = 248, START_BUTTON_Y = 360;
final int STOP=0; final int LEFTWARD=1;final int DOWNWARD=2; final int RIGHTWARD=3;
int movement=STOP;
PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24;
PImage soilImage[] = new PImage[6];
PImage groundhog;
PImage life;
PImage stone1, stone2,soldier,cabbage;
// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;
boolean rollup=false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24 = loadImage("img/soil8x24.png");
  groundhog = loadImage("img/groundhogIdle.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  for(int i=0;i<soilImage.length;i++){soilImage[i] = loadImage("img/soil"+i+".png");}
  playerHealth =2;
  //set soldierY randomly
  soldierY =grid*2+grid*floor(random(0,4));
  //set cabbage position radomly
  cabbageX =grid*floor(random(0,8));
  cabbageY =grid*2+grid*floor(random(0,4));
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game
    
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

    //rolluptranslate
    pushMatrix();
    translate(0,soiloffset);    
		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);
		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    //soil
    for(int y=0;y<24;y++){
    for(int x=0;x<8;x++){
    image(soilImage[floor(y/4)],grid*x,grid*2+grid*y);}}
    //1-8
    for(int i=0;i<8;i++){
      image(stone1,i*grid,(i+2)*grid);
    }
    ////9-16  
    for(int y=10;y<18;y++){
      for(int x=0;x<10;x++){         
      if(floor((y+1)/2)%2==0){
        if(floor(x/2)%2==0 ){image(stone1,(x-1)*grid,y*grid);}}
      else{if(floor(x/2)%2==0 ){image(stone1,(x+1)*grid,y*grid);}}
    }
    }
    //17-24
    for(int x=0;x<8;x++){
    for(int y=0;y<8;y++){
     if((x+y)%3==1){image(stone1,grid*x,grid*y+18*grid);}
     if((x+y)%3==2){image(stone1,grid*x,grid*y+18*grid);
     image(stone2,grid*x,grid*y+18*grid);}
     if((x+y)%3==0){}
    }
    }
   //draw cabbage
   image(cabbage,cabbageX,cabbageY);
   //soldier
   soldierX+=5;
   if(soldierX>640+soldier.width){
   soldierX=-80;}//loop from left to right
   image(soldier,soldierX,soldierY);
    popMatrix();
    
		// Player
      //movement
      switch(movement){
        case STOP:
          groundhog = loadImage("img/groundhogIdle.png");
          groundhogY+=0;
        break;
        case DOWNWARD:  
        groundhog = loadImage("img/groundhogDown.png");
        if(soiloffset<=-20*grid){         
          groundhogY+=5;
          if(groundhogY%grid==0){movement=STOP;}  
        }
        else{
        soiloffset-=5;
        if(soiloffset%grid==0){movement=STOP;}
        }
        break;
        case LEFTWARD:
          groundhogX-=5;
          groundhog = loadImage("img/groundhogLeft.png");
          if(groundhogX%grid==0){movement=STOP;}
        break;
        case RIGHTWARD:
          groundhogX+=5;
          groundhog = loadImage("img/groundhogRight.png");
          if(groundhogX%grid==0){movement=STOP;}
        break;
          
        
        }
          //draw groundhog
          image(groundhog,groundhogX,groundhogY);
		// Health UI
      for(int i=0;i<playerHealth;i++){
      image(life,10+(life.width+20)*i,10);
      }
    //collision
      //groundhog & soldier
      if(groundhogX<soldierX+soldier.width && groundhogX+groundhog.width>soldierX
      &&groundhogY<soldierY+soldier.height+soiloffset 
      && groundhogY+groundhog.height>soldierY+soiloffset){
      movement=STOP;
      groundhogX=grid*4;
      groundhogY=grid;
      soiloffset=0;
      playerHealth = playerHealth-1;}
     //groundhog & cabbage
      if(groundhogX==cabbageX && groundhogY==cabbageY+soiloffset){
        cabbageX=width;
        cabbageY=height;
        if(playerHealth<5){playerHealth = playerHealth+1;}
      }
        //lose
          if(playerHealth<=0){gameState=GAME_OVER;}
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
        playerHealth=2;
        groundhogX=grid*4; groundhogY=grid;
        soiloffset=0;
        //set soldierY randomly
        soldierY =grid*2+grid*floor(random(0,4));
        //set cabbage position radomly
        cabbageX =grid*floor(random(0,8));
        cabbageY =grid*2+grid*floor(random(0,4));
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here
    if(groundhogX%grid==0 && groundhogY%grid==0){
    switch(keyCode){
    case DOWN:
    if(groundhogY+grid<height){movement=DOWNWARD;}
    break;
    case RIGHT:
    if(groundhogX+grid<width){movement=RIGHTWARD;}
    break;
    case LEFT:
    if(groundhogX>0){movement=LEFTWARD;}
    break;
  }}
	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
      

    }
}

void keyReleased(){
}
