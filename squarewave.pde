float theta = 0;
PVector pos = new PVector(175, 200);

ArrayList<Float> points = new ArrayList();

int circleCount = 1;

void setup(){
  size(600, 400);
  //All lines will be drawn in grey
  stroke(128);
  //Circles will not be filled (transparent)
  noFill();
}

/**
 * Draws a circle and line representing the sine of theta times the coefficient.
 * @param center A PVector whose x and y represent the center of the circle
 * @param radius The radius of the circle
 * @param coefficient The angle of the line will be drawn as coefficient * theta
 * @return The tip of the sine line where the next circle will be drawn
 */
PVector drawCircle(PVector center, float radius, float coefficient){
    //Draw the base circle
    ellipse(center.x, center.y, radius * 2, radius * 2);

    //PVector tip is where the line ends and where the next circle is centered
    PVector tip = new PVector();
    /*
    The end is found by adding the cosine (horizontal) to the center's x position
    and the sine (vertical) to the center's y position
     */
    tip.x = center.x + radius * PApplet.cos(coefficient * theta);
    tip.y = center.y + radius * PApplet.sin(coefficient * theta);

    //Draw a line from the center of the circle to the end point
    line(center.x, center.y, tip.x, tip.y);
    //Return the end point as the result of the function
    return tip;
}

/**
 * The main body of the program which loops infinitely.
 */
void draw(){
    //Clear the background with white
    background(250);

    //Update the global theta value to animate rotation
    theta -= 0.02;
    if(theta < TAU){
        theta += TAU;
    }

    //Start the fist circle at pos
    PVector tip = pos;
    /*
    Draws the series of circles

    The formula for a square wave is the sum sin(theta * (2i + 1))/(2i + 1),
    where i ranges from 0 to infinity.

    The denominator is represented as 100f/(2*i + 1). The amplitude is divided
    by 2i+1 for the ith sine. This is equivalent to having the ith circle have a
    radius 1/(2i+1) times the size of the largest circle.

    The coefficient is represented as the 2*i + 1 inside the sine. The ith circle
    spins at a rate 2i+1 times faster than the largest circle.

    Finally, the summation is found by taking the result of drawCircle, the endpoint
    of the line for that particular circle, and feeding it back in to the next
    iteration of drawCircle. The next circle will be drawn with its center at the new tip,
    which is equivalent to summing all the x and y's of the circles before it.
     */
    for(int i = 0; i < circleCount; i ++){
        tip = drawCircle(tip, 100f/(2*i + 1), 2*i + 1);
    }

    //Draw a horizontal line from the last circle tip to the graph
    stroke(192);
    line(tip.x, tip.y, 400, tip.y);
    stroke(128);

    //Draw dots at the ends of the line
    fill(0);
    ellipse(tip.x, tip.y, 4, 4);
    ellipse(400, tip.y, 4,  4);
    noFill();

    //Add the last circle tip's y coordinate to the graph
    points.add(0, tip.y);
    //Iterate through the y coordinates, drawing a line between each pair of points
    for(int i = 1; i < points.size(); i ++){
        //Draw the x coordinate for the ith point in the list at 401+i to create a scrolling effect
        line(400 + i, points.get(i - 1), 401 + i, points.get(i));
    }
    //Remove points off the end if there are more than 200 points
    if(points.size() > 200)
        points.remove(points.size() - 1);
}

public void keyPressed(){
    switch(keyCode){
        case LEFT:
            if(circleCount > 0) {
                circleCount--;
                points.clear();
            }
            break;
        case RIGHT:
            if(circleCount < 20) {
                circleCount++;
                points.clear();
            }
            break;
    }
}