import java.util.Iterator;

class Graph{
  ArrayList<PVector> points;
  float speed = 1;
  PVector prev = new PVector(0, 0);
  
  Graph(){
    points = new ArrayList<PVector>();
  }
  
  void cleargraph(){
    points = new ArrayList<PVector>();
  }
  
  void infrender(){
    float theta = cstack.base.angle;
    if(abs(theta - PI) < .5 || TAU - theta < .5 || theta < .5){
      points.add(new PVector(0, cstack.infy()));
      rendergraph();
    }
    else{
      if(frameCount % 4 == 0)
        points.add(new PVector(0, cstack.infy()));

      rendergraph();
    }
  }
  
  void render(float y){
    stroke(200, 100, 0);
    //y = round(y);
    if(infinity){
      y = cstack.infy();
      line(cstack.tipx(), cstack.infy(), 375, cstack.infy());
      ellipse(375, cstack.infy(), 4, 4);
      ellipse(cstack.tipx(), y, 4, 4);
      stroke(0);
      infrender();
      return;
    }
    else{
      line(cstack.tipx(), cstack.tipy(), 375, cstack.tipy());
      ellipse(375, cstack.tipy(), 4, 4);
      ellipse(cstack.tipx(), cstack.tipy(), 4, 4);
    }
    stroke(0);
    rendergraph();
    if(frameCount % 2 == 0)
      points.add(new PVector(0, y));
  }
  
  void rendergraph(){
    Iterator<PVector> itr = points.iterator();
    pushMatrix();
    translate(375, 0);
    prev = new PVector(0, 0);
    while(itr.hasNext()){
      PVector temp = itr.next();
      if(prev.y == 0)
        point(temp.x, temp.y);
      else{
        //ellipse(temp.x, temp.y, 2, 2);
        line(temp.x, temp.y, prev.x, prev.y);
      }
      prev = temp;
      temp.x += speed;
      if(temp.x > 200)
        itr.remove();
    }
    popMatrix();
  }
}