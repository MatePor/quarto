
class Piece
{
  
  int X, Y, d; // coordinates and diameter
  String shape_type; // square/circle
  String color_type; // light/dark
  String height_type; // tall/short
  String form_type; // solid/hollow
  
  int ID;

  Piece(int pX, int pY, String shape, String colour, String height_, String form, int id_)
  {
    ID = id_;
    X = pX;
    Y = pY;
    shape_type = shape; 
    color_type = colour; 
    height_type = height_; 
    form_type = form;   
    if(height_type == "tall")
       d = 48;
    else 
       d =36;
  }
  
  void draw_piece()
 {
    if(color_type == "dark")
       fill(85);
    else 
       fill(215);
        
    if(shape_type == "circle")
       ellipse(X, Y, d, d);
    else 
         rect(X-d/2, Y-d/2, d, d);
       
    if(form_type == "hollow")
    {
       fill(0);
       ellipse(X, Y, 22, 22);
    }   
  }
}
  
