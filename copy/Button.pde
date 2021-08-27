class Button
{
  // coordinates, width and height
  private int x, y, w, h;
  public String title;  
  public boolean pressed;

  Button(int px, int py, int pw, int ph, String txt)
  {
    x = px;
    y = py;
    w = pw;
    h = ph;
    title = txt;
    pressed = false;
  }

  public void show()
  {
    if (mousePressed && mouseX > x-w/2 && mouseX < x+ w/2 
      && mouseY > y - h/2 && mouseY < y + h/2)  
      pressed = true;  
    else 
      pressed = false;
      
    if (pressed) 
    {  
      strokeWeight(5);
      fill(90, 180);
    } 
    else
    {  
      strokeWeight(2);
      fill(200,120,40, 180);
    }
    
    rect(x, y, w, h); 
    
    fill(180, 180);
    rect(x, y, w - h/5, h - h/5);

    if (h != 0)
    {
      fill(0, 150);
      textSize(0.4*h);
      textAlign(CENTER, CENTER);
      text(title, x, y, w, h);
    }
  }
}
