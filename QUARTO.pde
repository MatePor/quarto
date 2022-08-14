int taken_i, d, difficulty_lvl, move_count;
boolean player_1, place, choose, claim_win, human_first, animation_enabled,
game_finished, m_menu, ch_difficulty;

Piece[] pieces;

PVector [][] b_coord;
String [][]board_state;
  
Button START_B, CLAIM_B, MENU_B, RESET_B, I_START, CLOSE_B,
LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5;

String []message = {"good job!", "nice, keep it up!", "you rock!", "you're killing it!", "..."};
String []informations = {"Piece placement and piece choice are completely random. "+
  "Winning against it should be pretty efortless",  
  "Piece placement is random but engine won't give you any piece that allows you to win immediately."
  + "You have to make your win inevitable",
  "Engine sees winning moves for both sides." +
  "It will always find a winning move if there is one." +
  "You will need to think ahead to win",
  "Minmax with alpha-beta prunning. Should be almost impossible to beat.",
  "Neural network for fun..."};

void setup()
{
  size(800, 600);
  surface.setTitle("QUARTO");
 
  rectMode(CENTER);
  textAlign(CENTER);
  
  START_B = new Button(width/2, height/2, 320, 140, "START");
  RESET_B = new Button(width/2, height/2+160, 320, 140, "RESET");
  CLAIM_B = new Button(width - 106, 80, 120, 60, "CLAIM WIN");
  MENU_B = new Button(80, 80, 60, 60, "M");
  
  LEVEL_1 = new Button(width/2, height/4, 320, 80, "LEVEL 1");
  LEVEL_2 = new Button(width/2, height/4 + 90, 320, 80, "LEVEL 2");
  LEVEL_3 = new Button(width/2, height/4 + 180, 320, 80, "LEVEL 3");
  LEVEL_4 = new Button(width/2, height/4 + 270, 320, 80, "LEVEL 4");
  LEVEL_5 = new Button(width/2, height/4 + 360, 320, 80, "LEVEL 5");
  
  I_START = new Button(width/6, height/4, 180, 80, "Do I start?");
  CLOSE_B = new Button(width/6, height/4, 20, 20, "X");
  
  d = 72;
  taken_i = -1;
  difficulty_lvl = 0;
  move_count = 0;
  
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
  claim_win = true;  // change to false if you want to use CLAIM_B
  game_finished = false;
  m_menu = true;
  ch_difficulty = true;
  human_first = false;
  animation_enabled = false;
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
      
      if(I_START.pressed)
        human_first = !human_first;
        
      if(difficulty_lvl < 4 && difficulty_lvl != 0)    // now it works only for 1st and 2nd lvl
        ch_difficulty = false;  
        
      if(difficulty_lvl != 0)
        START_B.title = "CONTINUE";
      else
        START_B.title = "START";
    }
    
    
    if(MENU_B.pressed)
    {
       m_menu = true;
       MENU_B.pressed = false;
    }
       
    //if(CLAIM_B.pressed)
    //   claim_win = !claim_win;
  }
  
  if(player_1 == human_first)
  {
    if(taken_i != -1 && choose)
    {
        pieces[taken_i].X = 2*width/3;
        pieces[taken_i].Y = 50;  
        
        player_1 = !player_1;
        choose = false;
        //claim_win = false;
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
      move_count++;
      board_state[int(ind.x)][int(ind.y)] = pieces[taken_i].info_ID;
       
      taken_i = -1;
      place = false;
      choose = true;
    }
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
  //fill(120);
  //rect(width - 106, 80, 120, 60);
  //rect(width - 106, height - 80, 120, 60);
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

void chooseDifficulty()
{
    pushStyle();
    stroke(255,0,0);
    strokeWeight(20);
    fill(45);
    rect(width/2, height/2, width-50, height-50);
    popStyle();
    
    pushStyle();
    fill(255);
    textSize(40);
    text("choose difficulty!", width/2, 85);
 
    I_START.show();
    LEVEL_1.show();
    LEVEL_2.show();
    LEVEL_3.show();
    LEVEL_4.show();
    LEVEL_5.show();
    
    if(human_first)
    {
      fill(0,255,0);
      textSize(25);
      text("Yes. ", 130,  height/4 + 90, 80, 30);
      fill(0,255,0);
    }
    else
    {
      fill(255,0,0);
      textSize(25);
      text("No. ", 130,  height/4 + 90, 80, 30);
      fill(60);
    }
   
    ellipse(70,  height/4 + 90, 30, 30);
    fill(255);
    text("TO DO! some more settings here: ", width/6, 2*height/3, 180,100);
    popStyle(); 
    
    pushStyle();
    textAlign(LEFT);
    textSize(15);
    text("VERY EASY", width/2 + 320, height/4, 300, 40);
    text("EASY", width/2 + 320, height/4 + 90, 300, 40);
    text("MEDIUM", width/2 + 320, height/4 + 180, 300, 40);
    text("HARD\n[TO DO!]", width/2 + 320, height/4 + 270, 300, 80);
    text("IMPOSSIBLE\n[TO DO!]", width/2 + 320, height/4 + 360, 300, 80);
    
    for(int i = 0; i < 5; i++)
    {
      if(new PVector(width/2 + 320 - mouseX, height/4 + i*90 - mouseY).magSq() < 900)
      {
        stroke(0);
        noFill();
        strokeWeight(3);
        ellipse(width/2 + 320, height/4 + i*90, 70, 70);
        
        fill(255,240);
        rect(width/2, height/2, 500, 400);
        fill(0);
        textSize(30);
        textAlign(LEFT);
        text(informations[i], width/2, height/2, 450, 350);
        
      }
      noFill();
      stroke(255);
      strokeWeight(8);
      ellipse(width/2 + 320, height/4 + i*90, 60, 60);
      fill(255);
      noStroke();
      rect(width/2 + 320, height/4 + i*90 + 6, 12, 24);
      rect(width/2 + 320 - 2, height/4 + i*90, 12, 12);
      ellipse(width/2 + 320, height/4 + i*90 - 14, 12, 12);
    }

    popStyle();
}


void resetAll()
{
  player_1 = true;
  place = false;
  choose = true;
  claim_win = true; // change to false if you want to use CLAIM_B
  game_finished = false;
  ch_difficulty = true;
  taken_i = -1;
  human_first = false;
  move_count = 0;
  
  difficulty_lvl = 0;
  START_B.title = "START";
  
  for(int i = 0; i < 4; i++)
    for(int j = 0; j < 4; j++)     
        {
          b_coord[i][j] = new PVector(width/3-1.5*d+i*d, height/2-1.5*d+j*d);
          pieces[i*4 + j] = new Piece(2*width/3+int(i*d*0.8), height/3+int(j*d*0.8), i*4 + j);
          board_state[i][j] = "----";
        }  
}

void gamePlay()
{
   //CLAIM_B.y = (player_1)? 80: height - 80;
   
    drawBoard();
    drawPieces();
    MENU_B.show();
    //CLAIM_B.show();
    
    pushStyle();
    fill(100,250,0);
    if(!human_first)
      ellipse(width-145, (player_1)? 20: height - 20, 25, 25);
    else
      ellipse(width-145, (player_1)? height - 20: 20, 25, 25);
    popStyle();
    /*
    if(CLAIM_B.pressed && player_1)
        fill(100,250,0);
    else 
        fill(160);
    ellipse(width-185, 80, 25, 25);
    if(CLAIM_B.pressed && !player_1)
        fill(100,250,0);
    else 
        fill(160);
    ellipse(width-185, height - 80, 25, 25);
    popStyle();
    */
    if(claim_win)
      game_finished = checkWinner(board_state);
    if(move_count == 16)
      game_finished = true;
      
    if(!game_finished)
    {
      nextMove();
      if(player_1 ^ human_first)
        botMove();
    }
    else 
    {
       fill(255, 200);
       rect(width/2, height/2, 300,500);
       textSize(40);
       fill(255,0,0);
       if(move_count < 16)
       {
       if(player_1 ^ human_first)
         text("QUARTO! \nYou lose!", width/2, height/2); 
       else
         text("QUARTO! \nYou win! \n" + message[difficulty_lvl - 1], width/2, height/2);
       }
       else  
         text(".DRAW.", width/2, height/2); 
         
    } 
}

void nextMove()
{
  if(choose && (player_1 == human_first))
  {
    for(int i = 0; i < 16; i++)
    {  
      pieces[i].isChosen();
       if(pieces[i].chosen && !pieces[i].placed)
         taken_i = i;        
    }
  } else if(choose && (player_1 ^ human_first)) 
  {
    delay(500);
    boolean piece_wins;
    int count_iter;
    int k;
    
    switch(difficulty_lvl)
    {
      case 1:
        while(taken_i == -1)
        {
          int i = int(random(0,15));
          if(!pieces[i].placed)
             taken_i = i;      
        }
        break;
      case 2:
        piece_wins = true;
        count_iter = 0;
        k = -1;
        while(piece_wins)
        {
          k = int(random(0,15));
          
          if(!pieces[k].placed)
          {
            count_iter++;
            piece_wins = false;
            for(int i = 0; i < 4; i++)
              for(int j = 0; j < 4; j++)
                 if(board_state[i][j] == "----")
                 {
                    board_state[i][j] = pieces[k].info_ID;
                    if(checkWinner(board_state))  
                       piece_wins = true;
                    
                    board_state[i][j] = "----";   
                 }
            if(count_iter > 50)
              piece_wins = false;
          }      
        }      
        if(k != -1)
          taken_i = k; 
        break; 
      case 3:
        piece_wins = true;
        count_iter = 0;
        k = -1;
        while(piece_wins)
        {
          k = int(random(0,15));
          
          if(!pieces[k].placed)
          {
            count_iter++;
            piece_wins = false;
            for(int i = 0; i < 4; i++)
              for(int j = 0; j < 4; j++)
                 if(board_state[i][j] == "----")
                 {
                    board_state[i][j] = pieces[k].info_ID;
                    if(checkWinner(board_state))  
                       piece_wins = true;
                    
                    board_state[i][j] = "----";   
                 }
            if(count_iter > 50)
              piece_wins = false;
          }      
        }      
        if(k != -1)
          taken_i = k; 
        break;
      case 4:
        // index was chosen in botMove() function
        break;
      case 5:
        break;
      default: break;
    }  
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

boolean checkWinner(String brd[][])
{ 
 // 4 letters to check
 for(int i = 0; i < 4; i++)
 {
   boolean eq_diag1, eq_diag2;
   char comp_0 = brd[0][0].charAt(i);
   char comp_1 = brd[0][3].charAt(i);
   eq_diag1 = true;
   eq_diag2 = true;
   
   // 4 rows and columns
   for(int j = 0; j < 4; j++)
   {  
      boolean all_equal = true;
      char comp_2 = brd[j][j].charAt(i);
      
      if(brd[j][3-j].charAt(i) != comp_1 || 
      brd[j][3-j].charAt(i) == '-')
        eq_diag1 = false;
      if(comp_2 != comp_0 || comp_2 == '-')
        eq_diag2 = false;
        
      for(int k = 0; k < 4; k++) 
        if(brd[j][k].charAt(i) != comp_2 || 
        brd[j][k].charAt(i) == '-')
           all_equal = false;
           
      if(all_equal)
        return true;
      
      all_equal = true;   
      for(int k = 0; k < 4; k++) 
        if(brd[k][j].charAt(i) != comp_2 || 
        brd[k][j].charAt(i) == '-')
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

void botMove()
{
  int chosen_piece_index = -1;
  
  if(taken_i != -1 && choose)
  {
      pieces[taken_i].X = 2*width/3;
      pieces[taken_i].Y = height - 50;
      
      player_1 = !player_1;
      choose = false;
      //claim_win = false;
  } 
  else
  if(!place && taken_i != -1)
      place = true;
  else if(place)
  {
    delay(500);
    PVector mouse_c = new PVector(0,0);
    switch(difficulty_lvl)
    {
      case 1:
        mouse_c.set(random(width), random(height));
        break;
      case 2:
        mouse_c.set(random(width), random(height));
        break;
      case 3:
        boolean can_win = false;
        for(int i = 0; i < 4; i++)
          for(int j = 0; j < 4; j++)
             if(board_state[i][j] == "----")
             {
                board_state[i][j] = pieces[taken_i].info_ID;
                if(checkWinner(board_state))  
                {
                  can_win = true;
                  mouse_c.set(b_coord[i][j].x, b_coord[i][j].y);
                }
                
                board_state[i][j] = "----";   
             }
        if(!can_win)
          mouse_c.set(random(width), random(height));
        break;
      case 4:
        int best_score = -10000000;
        int best_move = -1;
        int score = 0;
     
       for(int i = 0; i < 4; i++)
        for(int j = 0; j < 4; j++)
        {
          if(board_state[j][i] == "----")
          {
            board_state[j][i] = pieces[taken_i].info_ID;
            
            boolean all_taken = true;
            for(int k = 0; k < 15; k++)
            {
              if(!pieces[k].placed)
              {
                all_taken = false;
                score = minimax(board_state, 0, 0, -100000, 100000, false);
                if(score > best_score)
                {
                   best_score = score;
                   best_move = i*4 + j; 
                   chosen_piece_index = k;
                } 
              }    
            }
            
            if(all_taken)
              chosen_piece_index = -1;
              
            board_state[j][i] = "----";
          } 
        }
        
        int i = best_move/4;
        int j = best_move%4;
        mouse_c.set(b_coord[i][j].x, b_coord[i][j].y);
        
        break;
      case 5:
        mouse_c.set(random(width), random(height));
        break;
      default: break;
    }
    
    PVector ind = findNearest(mouse_c);
    pieces[taken_i].X = int(b_coord[int(ind.x)][int(ind.y)].x);
    pieces[taken_i].Y = int(b_coord[int(ind.x)][int(ind.y)].y);
    pieces[taken_i].placed = true;
    move_count++;
    board_state[int(ind.x)][int(ind.y)] = pieces[taken_i].info_ID;
     
   
    if(difficulty_lvl == 4)
      taken_i = chosen_piece_index;
    else
       taken_i = -1;
    place = false;
    choose = true;
  }
  
}
