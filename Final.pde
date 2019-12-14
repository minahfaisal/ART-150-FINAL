import processing.serial.*;

float x; //accelerometer
float y; //pressure sensor

int BG;
Serial myPort;


PImage alien;
PImage earth;

float alienX;
float alienY;

float earthX;
float earthY;

float earthXspeed;
float earthYspeed;

int score;


void setup() {
  size(displayWidth, displayHeight);
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');

  noStroke();
  alien = loadImage("alien.png");
  earth = loadImage("earth.png");

  earthX = random(101, width-101);
  earthY = random(101, height-101);

  earthXspeed = 2;
  earthYspeed = 2;
  imageMode(CENTER);
}

void draw() {
  float mappedX = map(x, -180, 180, 0, width);
  float mappedY = map(y, 0, 1000, 0, height);
  
  background(0);
  fill(255);
  for (int i = 0; i < 1000; i++) {
    float r = random(10);
    ellipse(random(width), random(height), r, r);
  }
  textAlign(CENTER);
  textSize(80);
  text("Score: " + score, 200, 100);
  noCursor();
  image(alien, mappedX, mappedY, 200, 300);

  earthX = earthX + earthXspeed;
  earthY = earthY + earthYspeed;
  //three arguements: PImage name, x, y, optional: custom widht, custom height
  image(earth, earthX, earthY, 300, 300);
  if (earthX >= width - 101 || earthX <= 101) {
    earthXspeed = -earthXspeed;
  }
  if (earthY >= height - 101 || earthY <= 101) {
    earthYspeed = -earthYspeed;
  }
  //check to see if the mouse has tagged the furby
  //if so, add a point to score and move furby
  if (dist(mappedX, mappedY, earthX, earthY) < 100) {

    earthX = random(101, width - 101);
    earthY = random(101, height - 101);
    earthXspeed += 3;
    earthYspeed += 3;
    score++;
    println(score);
  }
  if (score == 5) {
    background(255);
    fill(random(255), random(255), random(255));
    textSize(500);
    text("YOU WIN!", width/2, height/2);
  }
}

void serialEvent(Serial myPort) {
  // convert data into a string
  String inString = myPort.readStringUntil('\n');

  // check to see if there's data coming in
  if (inString != null) {
    //trim whitespace around the values
    inString = trim(inString);

    float[] sensors = float(split(inString, ","));
    
    if (sensors.length >= 4) {
      for (int i = 0; i < sensors.length; i++) {
        println("value" + i + '=' + sensors[i]);
        x = sensors[2];
        y = sensors[3];
      }
    }
  }
}
