final int BIG_DIAMETER = 50;
final int SMALL_DIAMTER = 34;
final int HOLE_RADIUS = 21;
final color LIGHT_COL = color(220);
final color DARK_COL = color(110);

class Piece
{
  int X, Y, d; // coordinates and diameter 
  String info_ID; 
  //  "BBBB" B = (0/1):
  // - light/dark 
  // - square/circle
  // - solid/hollow
  // - short/tall
  // e.g. "0101" - light, circle, solid, tall
  boolean chosen, placed;
 
  Piece(int pX, int pY, int id)
  {
    info_ID = binary(id, 4);
    X = pX;
    Y = pY;
    chosen = false;
    placed = false;

    if (info_ID.charAt(3) == '1')
      d = BIG_DIAMETER;
    else 
      d = SMALL_DIAMTER;
  }

  void show()
  {
    if(chosen)
      stroke(255,0,0);
    else
      stroke(0); 
       
    if (info_ID.charAt(0) == '1')
      fill(DARK_COL);
    else 
      fill(LIGHT_COL);

    if (info_ID.charAt(1) == '1')
      ellipse(X, Y, d, d);
    else 
      rect(X, Y, d, d);

    if (info_ID.charAt(2) == '1')
    {
      fill(0);
      ellipse(X, Y, HOLE_RADIUS, HOLE_RADIUS);
    }
  }

  void isChosen()
  {
    if (mousePressed && dist(mouseX, mouseY, X, Y) < d/2)
      chosen = true;
    else 
      chosen = false;
  }
}
