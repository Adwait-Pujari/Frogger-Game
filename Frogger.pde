float frogX,frogY;         // x and y coordinates of FROG
int level;                 // level declared
void setup()
{
  fullScreen();
  level=1;
  bandHeight=height/(level+bandGap);     
  bandWidth=width/(level+bandGap);
  frogX=width/2;
  frogY=height-bandHeight/2;  
  HAZARD_SIZE=1; 
}
//======================================================================================================================================================================

void draw()
{
  frogY_min=height-bandHeight/2;           // bottom band
  
  frogX_min=bandWidth/2;                
  frogX_max=width-bandWidth/2;           
  
  rowHeight=bandHeight;                   
  
  if(win)                                  //Increases level and resets frog position
  {
    level++;
    win=false;
    frogY=frogY_min;
    frogX=width/2;
  }
  
  offset = (offset+SPEED)%rowHeight;       // makes the hazards move
  
  if(collide)                                
  {
  drawWorld(); 
  drawHazards();   
  drawFrog(frogX, frogY, bandHeight/2);
  detectWin();
 }
 displayMessage(display_message);
}
//======================================================================================================================================================================
float SPEED=1;

float bandGap= 4;
float bandHeight=0,bandWidth=0;                       // The gap between two bands 
void drawWorld()
{
  bandHeight=height/(level+bandGap);
  bandWidth=width/(level+bandGap);
  float yband=0,xband=0;                              // x and y coordinate of the band 
  
  for(int i=1;i<=level+4;i++)                         // For drawing the bands
  {
    noStroke();
    if(i==1 || i==level+4){
      fill(#58A4E0);
      rect(xband,yband,width,bandHeight);
    }
    else{
      fill(50);
      rect(xband,yband,width,bandHeight);
    }
    yband=yband+bandHeight;                             
  }
}

//======================================================================================================================================================================
void drawFrog(float x, float y, float diam)
{
  fill(#B2FA00);
  circle(x,y,diam);
  
}
//======================================================================================================================================================================
float frogX_min,frogX_max,frogY_min;                                   

void moveFrog(float xChange, float yChange)                          // checks if frog is in the canvas and the distance travelled by frog
{
  
  if (objectInCanvas(frogX, frogY, bandHeight/2))
  {
   frogX=frogX+xChange;
   frogY=frogY+yChange;
   drawFrog(frogX,frogY,bandHeight/2);
    if(frogX-bandHeight/2<0)
    frogX=frogX_min;
    else if(frogX+bandHeight/2>width)
    frogX=frogX_max;
    else if(frogY>height || frogY<0)
    frogY=frogY_min;
  }
}
//======================================================================================================================================================================
boolean objectInCanvas(float x, float y, float diam)              // Function to ensure that the frog do not hop out of the screen
{
  boolean Canvas = true;
  
  if (  y < 0 || y > height  || x<0 || x> width || diam<0 )
  {
    Canvas = false;
  }  
  return Canvas; 
}
//======================================================================================================================================================================
void keyPressed()                                                   // For frog movement
{
  if(collide)
  {
  if ( key == 'w' || key == 'W' || key == 'i' || key == 'I')
    moveFrog(0,-bandHeight);
  if ( key == 's' || key == 'S' || key == 'k' || key == 'K')
    moveFrog(0,bandHeight);
  if ( key == 'a' || key == 'A' || key == 'j' || key == 'J')
    moveFrog(-bandWidth/2,0);
  if ( key == 'd' || key == 'D' || key == 'l' || key == 'L')
    moveFrog(bandWidth/2,0);
  }
}
//======================================================================================================================================================================
int NUM_TYPES=3;
float rowHeight;
float HAZARD_SIZE;
int numObstacleRows;
float offset=1;
void drawHazard(int type, float x, float y, float size) {                 //based on type 0,1 or 2, draw ellipse, rect and ellipse respectively.    
  
  if(type==0){
     fill(250,0,0);
    circle(x,y,size);
    objectsOverlap(frogX,frogY,x,y,bandHeight/2,size);
  }
  else if(type==1) {
    fill(255);
    rect(x-bandHeight/2,y-bandHeight/2,size,size);
    objectsOverlap(frogX,frogY,x,y,bandHeight/2,size);
  }   
  else if(type==2){ 
    fill(#FFE200);
    circle(x,y,size);
    objectsOverlap(frogX,frogY,x,y,bandHeight/2,size);
  }
}
//======================================================================================================================================================================
float x,y;
void drawHazards()                                                        // makes the hazzards change alternatively in the middle lines and decides their direction
{
  numObstacleRows=level+2;
  for (int line=0; line<numObstacleRows; line++)
  {
    float lineSpacing = (line+3)*rowHeight;
    float lineOffset = (line+3)*offset;
    if (line%2==0) 
      lineOffset = lineSpacing-lineOffset;
     x = -lineSpacing + lineOffset;
     y = height-(line+1.5)*rowHeight;    
      
    do 
    {       
      drawHazard(line%NUM_TYPES, x, y, HAZARD_SIZE*rowHeight);  
      x += lineSpacing;      
    } while (objectInCanvas(x, y, HAZARD_SIZE*rowHeight));        
  }    
}
//======================================================================================================================================================================
String display_message;
void displayMessage(String m)                                          // displays level message and game over when frog collides with a hazzard 
{
  if(collide)
    m="level" + level;
  else
    m="Game Over";
  fill(#DBEDFF);
  textSize(bandHeight/2);
  text(m,width/2-textWidth(m)/2,bandHeight/2);
}
//======================================================================================================================================================================
boolean win=false;
boolean detectWin()                                                    // checks if the frog is at the top band or not.
{  
  if (frogY<bandHeight)
  {
    win=true;
  } 
  return win;
}
//======================================================================================================================================================================
boolean collide=true;
boolean objectsOverlap(float x1, float y1, float x2, float y2, float size1, float size2)   // checks collision between frog and hazzard
{
  //bolean=true; 
  if(dist(x1,y1,x2,y2)< (size1+size2)/2)
    collide=false;
  return collide; 
}
