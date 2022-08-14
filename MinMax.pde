int MAX_DEPTH = 20;

// void bot_move()
// {
//   int best_score = -10000000;
//   int best_move = -1;
//   int score = 0;
//   int [][]scores = new int[3][3];
   
//   for(int i = 0; i < 3; i++)
//    for(int j = 0; j < 3; j++)
//    {
//      if(board[j][i] == ' ')
//      {
//        board[j][i] = ai;
//        score = minimax(board, 0, false);
//        scores[j][i] = score;
//        board[j][i] = ' ';
        
//        if(score > best_score)
//        {
//           best_score = score;
//           best_move = i*3 + j; 
//        } 
//      } else
//        scores[j][i] = 99;
//    }
  
//   for(int i = 0; i < 3; i++)
//      println("|" + scores[0][i] + " | " + scores[1][i] + " | " + scores[2][i] + " | ");  
  
//  int y = best_move/3;
//  int x = best_move%3;
  
//  //println("x: " + x + ", y: " + y);
  
//  if(y > -1 && X  > -1 && y < 3 && x < 3 && board[x][y] == ' ')
//  {
//    board[x][y] = ai;
//    move_done = true;
//  }
// }
 
 int minimax(String [][]brd, int pc_index, int depth, float alpha, float beta, boolean is_maximizing)
 {
   int sc = 0;
   
   if(depth > MAX_DEPTH)
      return 0;
   
   if(is_maximizing)
   { 
     int best_sc = -100000;
     
     // put piece
     for(int i = 0; i < 4; i++)
      for(int j = 0; j < 4; j++)
      {
        if(brd[j][i] == "----")
        {
          brd[j][i]= pieces[pc_index].info_ID;
          if(checkWinner(brd))
          {
           int result = 0;
           if(depth % 2 == 0)  // human won
             result = 2*(1+MAX_DEPTH-depth);
           else
             result = -2*(1+MAX_DEPTH-depth); 
      
           return result; 
           }
          // choose piece
          boolean all_taken = true;
          for(int k = 0; k < 15; k++)
          {
            if(!pieces[k].placed)
            {
              all_taken = false;
              sc = minimax(brd, k, depth+1, alpha, beta, false);
              best_sc = max(sc, best_sc);
              alpha = max(alpha, sc);
              if(beta <= alpha)
                 break;
            }    
          }
          
          if(all_taken)
            return 0;
            
          brd[j][i] = "----"; 
        }
      }
      
      return best_sc;
   } 
   else
   {
     int best_sc = 100000;
     
     // put piece
     for(int i = 0; i < 4; i++)
      for(int j = 0; j < 4; j++)
      {
        if(brd[j][i] == "----")
        {
          brd[j][i]= pieces[pc_index].info_ID;
          if(checkWinner(brd))
          {
           int result = 0;
           if(depth % 2 == 0)  // human won
             result = 2*(1+MAX_DEPTH-depth);
           else
             result = -2*(1+MAX_DEPTH-depth); 
      
           return result; 
           }
          // choose piece
          boolean all_taken = true;
          for(int k = 0; k < 15; k++)
          {
            if(!pieces[k].placed)
            {  
              all_taken = false;
              sc = minimax(brd, k, depth+1, alpha, beta, true);
              best_sc = min(sc, best_sc);
              beta = min(beta, sc);
              if(beta <= alpha)
                 break;
            }        
          }
          
          if(all_taken)
            return 0;
          
          brd[j][i] = "----";
        }
      }
      
      //println("best score (min): " + best_sc);
      return best_sc;
   }
 }
 
 
