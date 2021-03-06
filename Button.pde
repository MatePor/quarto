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
    pushStyle();
    if (mousePressed && mouseX > x-w/2 && mouseX < x+ w/2 
      && mouseY > y - h/2 && mouseY < y + h/2)  
      pressed = true;  
    else 
      pressed = false;
     
    color frame_c = lerpColor(color(255,0,0), color(255,0,150), 0.5);
    color button_c = lerpColor(color(160), color(80), 0.5);

    if (pressed) 
    {  
      strokeWeight(5);
      fill(90, 180);
    } 
    else
    {  
      strokeWeight(2);
      fill(frame_c, 180);
    }
    
    rect(x, y, w, h); 
    
    fill(button_c, 180);
    rect(x, y, w - h/5, h - h/5);

    if (h != 0)
    {
      fill(0, 150);
      textSize(0.4*h);
      textAlign(CENTER, CENTER);
      text(title, x, y, w, h);
    }
    popStyle();
  }
}
