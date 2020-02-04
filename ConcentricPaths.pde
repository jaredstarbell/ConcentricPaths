// Concentric Paths
//   Jared S Tarbell
//   February 2, 2020
//   Levitated Toy Factory
//   Albuquerque, New Mexico, USA
//
// Processing 3.5.3

int num = 0;               // actual number of concentric path particles
int max = 5000;            // maximum number
boolean blackout = false;  // rendering flag if true, particles are black, if false particles are white (mostly)

Particle[] kaons;          // collection of particles

// some color palettes
color[] goodcolor = {#f8f7f1, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };
color[] flourescentColor = {#ff9966, #ccff00, #ff9933, #ff00cc, #ee34d3, #4fb4e5, #abf1cf, #ff6037, #ff355e, #66ff66, #ffcc33, #ff6eff, #ffff66, #fd5b78};

color somecolor() {
  // pick some random good color
  return flourescentColor[int(random(flourescentColor.length))];
}

void setup() {
  fullScreen(FX2D);
  colorMode(RGB,255);
  background(0);
  smooth(8);
  
  // list of all particles  
  kaons = new Particle[max];

  // create any initially specified particles (otherwise add one per frame until maximum limit)
  for (int i=0;i<num;i++) kaons[i] = new Particle(width/2,height/2);
  
}

void draw() {
  // move and draw all the particles
  for (int i=0;i<num;i++) kaons[i].move();
  
  // randomly flip between black and white ages
  //if (random(1000)<1) blackout = !blackout;

  // add another particle if limit not yet met
  if (num<max) kaons[num++] = new Particle(width/2,height/2);  
   
}

void keyPressed() {
  // press spacebar to toggle blackout ages
  if (key==' ') blackout = !blackout;
}
