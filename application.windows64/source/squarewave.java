import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class squarewave extends PApplet {

CircleStack cstack;
Graph graph;
boolean showgraph = false;
boolean showformu = false;
boolean slowmo = true;
boolean infinity = false;
PImage formula;

public void settings(){
  size(600, 400);
}

public void setup(){
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

public void draw(){
  background(255);
  fill(0);
  //text(frameRate, 40, 20);
  if(showformu){
    image(formula, 80, 0);
    if(infinity)
      text("\u221e", 108, 22);
    else
      text(cstack.height + 1, 108, 22);
  }
  //text(cstack.height + 1, 10, 20);
  cstack.render();
  if(showgraph)
    graph.render(cstack.tipy());
}

public void keyPressed(){
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
class Circle{
  float x, y;
  float r, angle;
  
  Circle(float x, float y, float r, float angle){
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.r = r;
  }
  
  public void renderangle(){
    pushMatrix();
    translate(x, y);
    line(0, 0, r * cos(angle), r * sin(angle));
    popMatrix();
  }
  
  public PVector angletip(){
    float i, j;
    pushMatrix();
    translate(x, y);
    line(0, 0, i = r * cos(angle), j = r * sin(angle));
    popMatrix();
    return new PVector(i + x, j + y);
  }
  
  public void render(){
    fill(0, 0);
    ellipse(x, y, 2*r, 2*r);
    fill(0);
    if(cstack.height != 0){
    pushMatrix();
    translate(x, y);
    ellipse(r * cos(angle), r* sin(angle), 4, 4);
    popMatrix();
    }
    
    angle -= TAU/cstack.speed;
    if(angle < 0)
      angle += TAU;
  }
  
  public void render(float i, float j, float theta){
    this.x = i;
    this.y = j;
    this.angle = theta;
    fill(0, 0);
    ellipse(i, j, 2*r, 2*r);
    fill(0);
    pushMatrix();
    translate(i, j);
    ellipse(r * cos(theta), r* sin(theta), 4, 4);
    popMatrix();
  }
  
  public void render(Circle c, float angle){
    render(c.r * cos(c.angle) + c.x, c.r * sin(c.angle) + c.y, angle);
  }
}

class CircleStack{
  Circle base;
  Circle[] stack;
  int height;
  float speed = 600;
  PVector sum = new PVector(0, 0);
  
  CircleStack(int height, float angle, float speed){
    this.speed = speed;
    this.height = height;
    if(height < 0)
      this.height = 0;
    if(height > 20)
      this.height = 20;
    base = new Circle(175, 200, 100, angle);
    
    if(height > 0){
      stack = new Circle[height];
      for(int i = 0; i < stack.length; i ++){
        stack[i] = new Circle(0, 0, 100 / (2 * i + 3), 0);
      }
    }
  }
  
  public void render(){
    /*
    for(int i = stack.length -1; i > 0; i --){
      stack[i].render(stack[i-1], base.angle * (2 * i + 3));
    }
    stack[0].render(base, base.angle * 3);
    base.render();
    */
    base.render();
    base.renderangle();
    if(height > 0){
      stack[0].render(base, base.angle * 3);
      if(height == 1)
        sum = stack[0].angletip();
      else
        stack[0].renderangle();
      for(int i = 1; i < height; i ++){
        stack[i].render(stack[i-1], base.angle * (2 * i + 3));
        if(i == height - 1){
          sum = stack[i].angletip();
        }
        else{
          stack[i].renderangle(); 
        }
      }
    }
  }
  
  public float tipy(){
    if(height == 0) 
      return base.y + base.r * sin(base.angle);
    
    return sum.y;
  }
  
  public float tipx(){
    if(height == 0) 
      return base.x + base.r * cos(base.angle);
      
    return sum.x;
  }
  
  public float infy(){
    if(tipy() > 200)
      return 278.5f;
    else if(tipy() < 200)
      return 121.5f;
    else
      return tipy();
  }
}


class Graph{
  ArrayList<PVector> points;
  float speed = 1;
  PVector prev = new PVector(0, 0);
  
  Graph(){
    points = new ArrayList<PVector>();
  }
  
  public void cleargraph(){
    points = new ArrayList<PVector>();
  }
  
  public void infrender(){
    float theta = cstack.base.angle;
    if(abs(theta - PI) < .5f || TAU - theta < .5f || theta < .5f){
      points.add(new PVector(0, cstack.infy()));
      rendergraph();
    }
    else{
      if(frameCount % 4 == 0)
        points.add(new PVector(0, cstack.infy()));

      rendergraph();
    }
  }
  
  public void render(float y){
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
  
  public void rendergraph(){
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "squarewave" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
