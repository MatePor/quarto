Piece[] pieces = new Piece[16];
int taken_i, d;
boolean player_1, place, done, choose, claim_win, to_release;

boolean [][] taken = new boolean[4][4];
boolean [][] board = new boolean[4][4];
PVector [][] b_coord = new PVector[4][4];


void setup()
{
  size(800, 600); 
  //surface.setTitle("QUARTO");
  //surface.setResizable(true); 
  rectMode(CENTER);
  
  d = 72;
  player_1 = true;
  place = false;
  done = false;
  choose = true;
  claim_win = false;
  to_release = false;
  taken_i = -1;
  
  String []forms = {"hollow","solid" };
  String []colors = {"light","dark"};
  String []heights = {"short","tall" };
  String []shapes = {"square","circle"};
  
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          b_coord[i][j] = new PVector(width/3-1.5*d+i*d, height/2-1.5*d+j*d);
          pieces[i*4 + j] = new Piece(2*width/3+int(i*d*0.8), height/3+int(j*d*0.8), shapes[(i*4 + j)/8], colors[(i*4 + j)%2], heights[((i*4 + j)/4)%2], forms[(i + j*4)/8],i*4 + j);
          board[i][j] = true;
        }  
}

void draw()
{
  //cursor(ARROW);
  background(0);
  
  drawBoard();
  nextMove();
  drawPieces();
  checkWinner();
  
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
      pieces[i].show();
}

void checkWinner()
{
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          fill(255,0,0);
          if(board[i][j] && claim_win)      
            text("QUARTO", width/2, height/2); 
        } 
  
  
  
}

void mouseReleased()
{
  if(place && to_release && done) 
  {
    pieces[taken_i].X = mouseX;
    pieces[taken_i].Y = mouseY;
    
    taken_i = -1;
    done = false;
    place = false;
    choose = true;
    to_release = false;
  }

}

void nextMove()
{
  if(place && mousePressed && !to_release)
    to_release = true;
  
  if(choose)
  {
    taken_i = -1;
    for(int i = 0; i < 16; i++)
    {  
      pieces[i].isChosen();
       if(pieces[i].chosen)
         taken_i = i;
         
    }
    
    if(taken_i != -1 && !done)
    {
        pieces[taken_i].X = 2*width/3;
        pieces[taken_i].Y = (player_1)? height - 50: 50;
        player_1 = !player_1;
        done = true;
    }
  }
  

  if(choose && taken_i != -1 && !to_release)
  {
    place = true;
    choose = false;
  }
  
  
}