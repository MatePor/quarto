int taken_i, d, difficulty_lvl;
boolean player_1, place, choose, claim_win, 
game_finished, m_menu, ch_difficulty;

Piece[] pieces;

PVector [][] b_coord;
String [][]board_state;
  
Button START_B, CLAIM_B, MENU_B, RESET_B, I_START,
LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5;

void setup()
{
  size(800, 600);
  surface.setTitle("QUARTO");
 
  rectMode(CENTER);
  
  START_B = new Button(width/2, height/2, 320, 140, "START");
  RESET_B = new Button(width/2, height/2+160, 320, 140, "RESET");
  CLAIM_B = new Button(width - 110, 80, 120, 60, "CLAIM WIN");
  MENU_B = new Button(80, 80, 60, 60, "M");
  
  LEVEL_1 = new Button(width/2, height/4, 320, 80, "LEVEL 1");
  LEVEL_2 = new Button(width/2, height/4 + 90, 320, 80, "LEVEL 2");
  LEVEL_3 = new Button(width/2, height/4 + 180, 320, 80, "LEVEL 3");
  LEVEL_4 = new Button(width/2, height/4 + 270, 320, 80, "LEVEL 4");
  LEVEL_5 = new Button(width/2, height/4 + 360, 320, 80, "LEVEL 5");
  
  I_START = new Button(width/4, height/3, 320, 80, "Do I start?");
  
  d = 72;
  taken_i = -1;
  difficulty_lvl = 0;
  
  b_coord = new PVector[4][4];
  board_state = new String[4][4];
  pieces = new Piece[16];
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
      {
        b_coord[i][j] = new PVector(width/3-1.5*d+i*d, height/2-1.5*d+j*d);
        pieces[i*4 + j] = new Piece(2*width/3+int(i*d*0.8), height/3+int(j*d*0.8), i*4 + j);
        board_state[i][j] = "----";
      }  
  
  player_1 = true;
  place = false;
  choose = true;
  claim_win = false;
  game_finished = false;
  m_menu = true;
  ch_difficulty = true;
}


void draw()
{

  background(0);
  
  if(m_menu)
  {
    pushStyle();
    stroke(255,0,0);
    strokeWeight(20);
    fill(45);
    rect(width/2, height/2, width-50, height-50);
    popStyle();

    fill(255);
    textSize(50);
    text("QUARTO", width/2, 150);
    START_B.show();
    RESET_B.show();
  }
  else
  {
      if(ch_difficulty)
         chooseDifficulty();
      else
         gamePlay();
  }
}

void mouseDragged()
{
  if(place && taken_i != -1)
   {
     pieces[taken_i].X =  mouseX;
     pieces[taken_i].Y = mouseY;
   }
   
  if(taken_i != -1 && choose)
  {
    pieces[taken_i].X =  mouseX;
    pieces[taken_i].Y = mouseY;
  }
  
}

void mouseReleased()
{
  if(m_menu)
  {
    if(START_B.pressed)
    {
       m_menu = false;
       START_B.pressed = false;
    }
    
    if(RESET_B.pressed)
       resetAll();     
  }
  else
  {
    if(ch_difficulty)
    {
      if(LEVEL_1.pressed)
        difficulty_lvl = 1;
        
      if(LEVEL_2.pressed)
        difficulty_lvl = 2;
        
      if(LEVEL_3.pressed)
        difficulty_lvl = 3;
      
      if(LEVEL_4.pressed)
        difficulty_lvl = 4;
      
      if(LEVEL_5.pressed)
        difficulty_lvl = 5;
      
      if(difficulty_lvl != 0)
        ch_difficulty = false;  
    }
    
    
    if(MENU_B.pressed)
    {
       m_menu = true;
       MENU_B.pressed = false;
    }
       
    if(CLAIM_B.pressed)
       claim_win = !claim_win;
  }
  if(taken_i != -1 && choose)
  {
      pieces[taken_i].X = 2*width/3;
      pieces[taken_i].Y = (player_1)? height - 50: 50;
      player_1 = !player_1;
      choose = false;
      claim_win = false;
  } 
  else
  if(!place && taken_i != -1)
      place = true;
  else if(place && dist(mouseX, mouseY, width/3, height/2) < 5.5*d/2)
  {
    PVector mouse_c = new PVector(mouseX, mouseY);
    PVector ind = findNearest(mouse_c);
    pieces[taken_i].X = int(b_coord[int(ind.x)][int(ind.y)].x);
    pieces[taken_i].Y = int(b_coord[int(ind.x)][int(ind.y)].y);
    pieces[taken_i].placed = true;
    board_state[int(ind.x)][int(ind.y)] = pieces[taken_i].info_ID;
     
    taken_i = -1;
    place = false;
    choose = true;
  }

}
 
void drawBoard()
{ 
  pushStyle();
  stroke(255);
  fill(45);
  strokeWeight(10);
  rect(width/2, height/2, width-60, height-60);
  stroke(0);
  strokeWeight(1); 
  fill(255,0,0);
  ellipse(width/3, height/2, 5.75*d, 5.75*d);
  fill(0);
  ellipse(width/3, height/2, 5.5*d, 5.5*d);
 
  fill(220);
  strokeWeight(2);
  ellipse(2*width/3, 0, 200, 200);
  ellipse(2*width/3, height, 200, 200);
  fill(120);
  rect(width - 110, 80, 120, 60);
  rect(width - 110, height - 80, 120, 60);
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

boolean checkWinner()
{ 

 // 4 letters to check
 for(int i = 0; i < 4; i++)
 {
   boolean eq_diag1, eq_diag2;
   char comp_0 = board_state[0][0].charAt(i);
   char comp_1 = board_state[0][3].charAt(i);
   eq_diag1 = true;
   eq_diag2 = true;
   
   // 4 rows and columns
   for(int j = 0; j < 4; j++)
   {  
      boolean all_equal = true;
      char comp_2 = board_state[j][j].charAt(i);
      
      if(board_state[j][3-j].charAt(i) != comp_1 || 
      board_state[j][3-j].charAt(i) == '-')
        eq_diag1 = false;
      if(comp_2 != comp_0 || comp_2 == '-')
        eq_diag2 = false;
        
      for(int k = 0; k < 4; k++) 
        if(board_state[j][k].charAt(i) != comp_2 || 
        board_state[j][k].charAt(i) == '-')
           all_equal = false;
           
      if(all_equal)
        return true;
      
      all_equal = true;   
      for(int k = 0; k < 4; k++) 
        if(board_state[k][j].charAt(i) != comp_2 || 
        board_state[k][j].charAt(i) == '-')
           all_equal = false;
       
      if(all_equal)
        return true;            
    }
    
    if(eq_diag1)
      return true;
    if(eq_diag2)
      return true;
  }
  
  return false;
}

void nextMove()
{
  if(choose)
  {
    for(int i = 0; i < 16; i++)
    {  
      pieces[i].isChosen();
       if(pieces[i].chosen && !pieces[i].placed)
         taken_i = i;        
    }
  }
}

void gamePlay()
{
   CLAIM_B.y = (player_1)? 80: height - 80;
   
    drawBoard();
    drawPieces();
    MENU_B.show();
    CLAIM_B.show();
    
    pushStyle();
    fill(100,250,0);
    ellipse(width-355, (player_1)? 80: height - 80, 25, 25);
    if(claim_win && player_1)
        fill(100,250,0);
    else 
        fill(160);
    ellipse(width-185, 80, 25, 25);
    if(claim_win && !player_1)
        fill(100,250,0);
    else 
        fill(160);
    ellipse(width-185, height - 80, 25, 25);
    popStyle();
    
    if(!game_finished)
    {
      nextMove();
      if(claim_win)
        game_finished = checkWinner();
    }
    else 
    {
       fill(255);
       rect(width/2, height/2, 300,500);
       textSize(40);
       fill(255,0,0);
       text("QUARTO! \n player " + str(2 - int(player_1)) + " won.", width/2, height/2);  
    } 
}

PVector findNearest(PVector point)
{
  float minDist = 1000;
  PVector retVec = new PVector(0,0);
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
      {
        float dis = dist(b_coord[i][j].x,b_coord[i][j].y, point.x, point.y);
        if(dis < minDist && (board_state[i][j] == "----"))
        {
          minDist = dis;
          retVec.x = i;   
          retVec.y = j;    
        }
      }
  
   return retVec;
}

void resetAll()
{
  player_1 = true;
  place = false;
  choose = true;
  claim_win = false;
  game_finished = false;
  ch_difficulty = true;
  taken_i = -1;
  
  difficulty_lvl = 0;
  
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          b_coord[i][j] = new PVector(width/3-1.5*d+i*d, height/2-1.5*d+j*d);
          pieces[i*4 + j] = new Piece(2*width/3+int(i*d*0.8), height/3+int(j*d*0.8), i*4 + j);
          board_state[i][j] = "----";
        }  
}

void chooseDifficulty()
{
    pushStyle();
    stroke(255,0,0);
    strokeWeight(20);
    fill(45);
    rect(width/2, height/2, width-50, height-50);
    popStyle();
    fill(255);
    textSize(40);
    text("choose difficulty!", width/2, 70);

    LEVEL_1.show();
    LEVEL_2.show();
    LEVEL_3.show();
    LEVEL_4.show();
    LEVEL_5.show();
    
    I_START.show();
    
    
}
