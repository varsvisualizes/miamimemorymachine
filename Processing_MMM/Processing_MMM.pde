/*

 Miami Memory Machine
 
 The Miami Memory Machine is recounts memories of growing up in Miami.
 A Circuit Playground Bluefruit attached to a coffee mug is your controller.
 When you fill the mug with a hot drink, the Machine wakes up. Every sip of
 your drink will take you through a new memory. 
 
 Please run "ProcessingHandoff_SipPing_Test" before executing
 this Processing sketch.
 
 13 Dec 2022
 Carmen Vargas
 
 */

/*------------- Start Variables —------------*/

// Importing the Serial and Video libraries
import processing.serial.*;
import processing.video.*;

// Establish Arduino and variables for incoming values
Serial myPort;
String val;
int[] intVals;

// variables we want to have for the Circuit Playground

int sipTaken; // if a sip is taken, sipTaken = 1; otherwise, sipTaken = 0
int sipCount; // total number of sips taken thus far
float tempF; // the temperature noted by the sensor

// the minimum temperature for a drink to be considered hot 
float tempHot = 70; 

// Movie array
String[] movies = {"birdbowlResized2.mp4", "birdsResized2.mp4", "movingResized2.mp4",
                  "pathfinderResized2.mp4", "stripmallsResized2.mp4", "tropicalparkResized2.mp4",
                  "vaquitaResized2.mp4", "ventanitaResized2.mp4", "palacioResized2.mp4",
                  "Disney_resized.mp4", "roosters_resized_captioned.mp4"
                };

Movie[] clips = new Movie[movies.length];
Movie startingAnim;

// Introductory Image
PImage startImg;

// Movie Choices

int choice;

/*------------- End Variables —------------*/

void setup() {

  size(1450, 900);

  // Arduino setup
  myPort = new Serial(this, Serial.list()[1], 9600);

  // fill the movie clips array
  for (int i = 0; i < movies.length; i++) {
    clips[i] = new Movie(this, movies[i]);
  }

  startImg = loadImage("startinganim.png");
  startingAnim = new Movie(this, "startinganim.mp4");

  sipCountRandomizer();
}

// Assign Arduino readings into an array
void serialEvent (Serial myPort) {
  // if the Arduino is available
  if (myPort.available() > 0) {

    // read the values as they come in
    val = myPort.readStringUntil('\n');

    // So long as we have values . . .
    if (val != null) {

      // Trim off any whitespace in the incoming values
      val = trim(val);

      // Split the values based on the delimiter, "split", and place them
      // in the intVals array
      intVals = int(split(val, "split"));

      // assign the value for the number of sips taken
      sipTaken = intVals[0];

      // for each sip taken, increment sip counter
      if (sipTaken == 1) {
        sipCount++;
        println("Sip count is " + sipCount);
      }

      tempF = intVals[1];
      //println("temperature is " + tempF);
    }
  }
}

void movieEvent(Movie movie) {
  movie.read();
}

void sipCountRandomizer() {

  choice = int(random(0, clips.length-1));
  println("Choice is " + choice);
}

void draw() {

  if (sipTaken == 1) { 
    sipCountRandomizer();
  }

  if (tempF > tempHot) {
    if (sipCount < 1) {
      startingAnim.play();
      image(startingAnim, 0, 0);
    } else {
      clips[choice].loop();
      image(clips[choice], 0, 0);
    }
  }
  else {
    startImg.resize(1450,875);
    image(startImg, 0, 0);
  }

  delay(250);
}
