Piece[] pieces = new Piece[16];
int taken_i;
boolean moving;

int []stages = {1,2,3};
int current_stage;
boolean [][] taken = new boolean[4][4];
int [][] board = new int[4][4];
PVector [][] b_coord = new PVector[4][4];

int d;

void setup()
{
  size(800, 600); 
  //surface.setTitle("QUARTO");
  //surface.setResizable(true); 
  rectMode(CENTER);
  
  d = 72;
  moving = false;
  String []forms = {"hollow","solid" };
  String []colors = {"light","dark"};
  String []heights = {"short","tall" };
  String []shapes = {"square","circle"};
  
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          b_coord[i][j] = new PVector(width/3-1.5*d+i*d, height/2-1.5*d+j*d);
          pieces[i*4 + j] = new Piece(2*width/3+int(i*d*0.8), height/3+int(j*d*0.8), shapes[(i*4 + j)/8], colors[(i*4 + j)%2], heights[((i*4 + j)/4)%2], forms[(i + j*4)/8],i*4 + j);
          board[i][j] = -1;
        } 
    current_stage = 0;  
}

void draw()
{
  //cursor(ARROW);
  background(0);
  
  
  drawBoard();
  drawPieces();
  //checkWinner();
  //nextMove();
  
  if(mousePressed)
   {
      pieces[pieceTaken].X = mouseX;
      pieces[pieceTaken].Y = mouseY;
      strokeWeight(3);
   }
  /*
  if...
  if...
  if...
  if...
  current_stage = (current_stage + 1) % 3;
  */
}
 
void drawBoard()
{ 
  pushStyle();
  stroke(255);
  fill(45);
  strokeWeight(10);
  rect(width/2, height/2, width-60, height-60);
  popStyle();
  
  fill(255,0,0);
  ellipse(width/3, height/2, 5.75*d, 5.75*d);
  fill(0);
  ellipse(width/3, height/2, 5.5*d, 5.5*d);
  
  pushStyle();
  fill(220);
  stroke(0);
  strokeWeight(2);
  ellipse(2*width/3, 0, 200, 200);
  ellipse(2*width/3, height, 200, 200);
  popStyle();
    
  fill(255);
  for(int i = 0; i < 4; i++)
  {
    for(int j = 0; j < 4; j++)
        ellipse(b_coord[i][j].x, b_coord[i][j].y, d, d);    
  }
}

void drawPieces()
{
   
  for(int i = 0; i < 16; i++)
  {
      pieces[i].isChosen();
      if(pieces[i].chosen)
        taken_i = i;
      pieces[i].show();
  }
  
}
