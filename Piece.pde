class Piece
{

  int X, Y, d; // coordinates and diameter
  String shape_type; // square/circle
  String color_type; // light/dark
  String height_type; // tall/short
  String form_type; // solid/hollow

  boolean chosen, placed;
  int ID;

  Piece(int pX, int pY, String shape, String colour, String height_, String form, int id_)
  {
    ID = id_;
    X = pX;
    Y = pY;
    chosen = false;
    placed = false;
    shape_type = shape; 
    color_type = colour; 
    height_type = height_; 
    form_type = form;  

    if (height_type == "tall")
      d = 48;
    else 
      d = 36;
  }

  void show()
  {
    if(chosen)
      stroke(255,0,0);
    else
      stroke(0); 
       
    if (color_type == "dark")
      fill(110);
    else 
      fill(215);

    if (shape_type == "circle")
      ellipse(X, Y, d, d);
    else 
      rect(X, Y, d, d);

    if (form_type == "hollow")
    {
      fill(0);
      ellipse(X, Y, 22, 22);
    }
  }

  void isChosen()
  {
    if (mousePressed && dist(mouseX, mouseY, X, Y) < d/2)
      chosen = true;
  }
}
