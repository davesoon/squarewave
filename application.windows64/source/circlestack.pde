class Circle{
  float x, y;
  float r, angle;
  
  Circle(float x, float y, float r, float angle){
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.r = r;
  }
  
  void renderangle(){
    pushMatrix();
    translate(x, y);
    line(0, 0, r * cos(angle), r * sin(angle));
    popMatrix();
  }
  
  PVector angletip(){
    float i, j;
    pushMatrix();
    translate(x, y);
    line(0, 0, i = r * cos(angle), j = r * sin(angle));
    popMatrix();
    return new PVector(i + x, j + y);
  }
  
  void render(){
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
  
  void render(float i, float j, float theta){
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
  
  void render(Circle c, float angle){
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
  
  void render(){
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
  
  float tipy(){
    if(height == 0) 
      return base.y + base.r * sin(base.angle);
    
    return sum.y;
  }
  
  float tipx(){
    if(height == 0) 
      return base.x + base.r * cos(base.angle);
      
    return sum.x;
  }
  
  float infy(){
    if(tipy() > 200)
      return 278.5;
    else if(tipy() < 200)
      return 121.5;
    else
      return tipy();
  }
}