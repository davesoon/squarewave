CircleStack cstack;
Graph graph;
boolean showgraph = false;
boolean showformu = false;
boolean slowmo = true;
boolean infinity = false;
PImage formula;

void settings(){
  size(600, 400);
}

void setup(){
  cstack = new CircleStack(0, PI, slowmo ? 300 : 100);
  graph = new Graph();
  if(slowmo)
    graph.speed = 1;
  else
    graph.speed = 1;
  cstack.render();
  formula = loadImage("squarewave.png");
  textSize(14);
  textAlign(CENTER);
}

void draw(){
  background(255);
  fill(0);
  //text(frameRate, 40, 20);
  if(showformu){
    image(formula, 80, 0);
    if(infinity)
      text("∞", 108, 22);
    else
      text(cstack.height + 1, 108, 22);
  }
  //text(cstack.height + 1, 10, 20);
  cstack.render();
  if(showgraph)
    graph.render(cstack.tipy());
}

void keyPressed(){
  if(keyCode == LEFT && cstack.height != 0){
    if(cstack.height == 20 && infinity){
      infinity = false;
      cstack = new CircleStack(20, cstack.base.angle, cstack.speed);
      graph.cleargraph();
      return;
    }
    cstack = new CircleStack(cstack.height - 1, cstack.base.angle, cstack.speed);
    graph.cleargraph();
  }
  else if(keyCode == RIGHT){
    if(cstack.height == 20 && infinity){
      return;
    }
    if(cstack.height == 20 && !infinity){
      infinity = true;
    }
    cstack = new CircleStack(cstack.height + 1, cstack.base.angle, cstack.speed);
    graph.cleargraph();
  }
  else if(keyCode == UP)
    showgraph = true;
  else if(keyCode == DOWN){
    showgraph = false;
    graph.cleargraph();
  }
    
  if(key == 'e')
    showformu = !showformu;
    
  if(key == 'w'){
    if(slowmo){
      cstack.speed = 100;
      graph.speed = 1;
    }
    else{
      cstack.speed = 300;
      graph.speed = 1;
    }
    graph.cleargraph();
    slowmo = !slowmo;
  }
  /*
  if(key == ' '){
    println(cstack.tipy());
  }
  */
}