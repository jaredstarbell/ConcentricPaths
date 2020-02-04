class Particle {

  float theta;      // angle of travel in radians
  float radius;     // radius of travel path
  float td;         // theta increment
  float rd;         // radius increment
  float x;          // pen x
  float y;          // pen y
  float xx;         // last pen x
  float yy;         // last pen y
  float ox;         // centroid x  
  float oy;         // centroid y
  float strokeWidth;// width of line
  int i;            // index number
  int age, maxage;  // age and maximum age
  int chanceDrop;   // percentage chance of moving to next outer ring
  int chanceSwitch; // percentage chance of changing radial direction after a drop
  int spinSign = 1; // direction of travel
  color myc = somecolor();  // color
  float fadeIn = 0; // fade in ratio

  Particle(float _ox, float _oy) {    // origin
    ox = _ox;    // origin x
    oy = _oy;    // origin y
    
    birth();
  }
  
  void birth() {
    // cycles through the machine
    age = 0;
    maxage = floor(random(10,200));

    // direction
    theta = random(TWO_PI);

    // alpha value of the drawing
    fadeIn = 0;

    // luck of life
    chanceDrop=int(random(15)+10);
    chanceSwitch=int(random(50)+25);

    // movement magnitudes
    td = random(4,24);   // radially
    rd = random(4,64);   // outwardly
    
    // default initial radius
    radius = 1;
    
    // pen position and last position
    x = 0;             // position x
    y = 0;             // position y
    xx = 0;            // position x'
    yy = 0;            // position y'
    
    strokeWidth = 1.0;
    
    // adjust the color and fade in rate
    if (blackout==true) {
      // BLACK
      
      if (random(1000)<2) {
        // random chance we have an outlier white line
        radius = random(0,height*.4);
        fadeIn = 0;
        myc = color(255);
        strokeWidth = 1.0;
      } else {
        // otherwise make the particle black
        myc = color(0);
        fadeIn = 55;
        strokeWidth = 2.0;
        rd = pow(2,floor(random(1,6)));
      }        
     
    } else {
      // WHITE
      if (random(1000)<2) {
        // random chance we have a dark streak in the whiteness
        myc = color(0);
        fadeIn = 0;
        strokeWidth = 1.0;
      } else {
        // otherwise make the particle white
        myc = color(255);
        fadeIn = random(10);
        strokeWidth = 1.0;
      }
    }
  }

  void move() {
    // mark current pen position
    xx=x;
    yy=y;

    // move radially along path
    float omega = atan(td/radius);
    theta+=spinSign*omega;

    // randomly loose momentum and drop out faster 
    if (random(10000)<2) {
      td = 0;
      chanceDrop*=10;
    }

    // calculate next pen position
    x=radius*cos(theta);
    y=radius*sin(theta);

    if (blackout) {
      if (fadeIn<128) fadeIn++;
    } else {
      if (fadeIn<73) fadeIn++;
    }

    // draw transparent line from old position to new
    strokeWeight(strokeWidth);
    stroke(myc,fadeIn);
    line(ox+xx,oy+yy,ox+x,oy+y);

    // modify current path
    //float edge = 50*noise(radius*.05);//,theta*.05);
    float edge = chanceDrop*20;
    if (random(100*sqrt(radius))<edge) {
      // particle will drop to next concentric radius
      xx=x;
      yy=y;
      radius+=rd;
      
      if (!blackout) {
        // white lines tend to shorten radial deltas
        if (random(100)<8) rd/=2;
        if (rd<2) rd = 2;
      }
      
      // calculate actual pen position
      x=int(radius*cos(theta));
      y=int(radius*sin(theta));
      // draw transparent line from old position to new
      // shadow
      //stroke(0,32);
      //line(ox+xx+1,oy+yy+1,ox+x+1,oy+y+1);
      stroke(myc,fadeIn);
      line(ox+xx,oy+yy,ox+x,oy+y);

      if (random(100)<chanceSwitch) {
        // particle will change direction of orbit
        spinSign*=-1;
      }
      
    }

    // grow old
    age++;
    if (age>maxage) {
      // explode into white light
      noStroke();
      
      // shadow
      float r = 1.2 - 1.2*log(random(1.0));
      fill(0,64);
      ellipse(ox+x+1,oy+y+1,r,r);
      fill(somecolor());
      ellipse(ox+x,oy+y,r,r);
      fill(255,128);
      ellipse(ox+x-r*.2,oy+y-r*.2,r*.2,r*.2);

      // die and be reborn
      birth();
    }
      
  }
}  
