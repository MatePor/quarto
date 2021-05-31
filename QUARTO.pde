int num_of_pieces = 0;
Piece[] pieces = new Piece[16];
int pieceTaken = 0;
boolean moving;

int []stages = {1,2,3};
boolean [][] taken = new boolean[4][4];
int [][] board = new int[4][4];

int w, h, W_BOARD, H_BOARD, W_TABLE, H_TABLE;

void setup()
{
  size(960, 640);
  
  surface.setTitle("QUARTO");
  surface.setResizable(true);
  
   w = 100;
   h = 100;
   W_BOARD = w*5;
   H_BOARD = h*5;
   W_TABLE = 200;
   H_TABLE = 200;
  
  String []forms = {"hollow","solid" };
  String []colors = {"light","dark"};
  String []heights = {"short","tall" };
  String []shapes = {"square","circle"};
  
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          pieces[i*4 + j] = new Piece(632+i*72, 144+j*72, shapes[(i*4 + j)/8], colors[(i*4 + j)%2], heights[((i*4 + j)/4)%2], forms[(i + j*4)/8],i*4 + j);
          board[i][j] = -1;
        }
}


void draw()
{
  cursor(ARROW);
  background(0);
  
  drawBoard();
  drawPieces();
  if(mousePressed)
   {
      pieces[pieceTaken].X = mouseX;
      pieces[pieceTaken].Y = mouseY;
      strokeWeight(3);
   }

}
 
void drawBoard()
{ 
  fill(255);
  ellipse(320, 252, 426, 426);
  fill(0);
  ellipse(320, 252, 400, 400);
    
  fill(255);
  for(int i = 0; i < 4; i++)
  {
    for(int j = 0; j < 4; j++)
    {
      ellipse(216+i*72, 144+j*72, 72, 72);
      ellipse(216+i*72, 144+j*72, 72, 72);
      ellipse(216+i*72, 144+j*72, 72, 72);
      ellipse(216+i*72, 144+j*72, 72, 72);
    }
  }
  
}

void drawPieces()
{
   
  for(int i = 0; i < 16; i++)
  {
      if(dist(pieces[i].X, pieces[i].Y, mouseX, mouseY) < pieces[i].d/2.)
      {
        
        cursor(HAND);
        pieceTaken = i;
        
      }
      pieces[i].draw_piece();
  }
  
}
