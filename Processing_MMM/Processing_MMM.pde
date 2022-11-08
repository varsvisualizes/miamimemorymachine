/*

 Miami Memory Machine
 
 The Miami Memory Machine is recounts memories of growing up in Miami.
 A Circuit Playground Bluefruit attached to a coffee mug is your controller.
 When you fill the mug with a hot drink, the Machine wakes up. Every sip of
 your drink will take you through a new memory. 
 
 Please run "ProcessingHandoff_SipPing_Test" before executing
 this Processing sketch.
 
 7 Nov 2022
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
float tempHot = 75; 

// Movie array
String[] movies = {"birdbowl_muted_resized.mp4", "birds_muted_resized.mp4", 
  "moving_muted_resized.mp4", "palacio_muted_resized.mp4", "pathfinder_muted_resized.mp4", 
  "stripmalls_muted_resized.mp4", "tropicalpark_muted_resized..mp4", "vaquita_muted_resized.mp4", 
  "ventanita_mute_captioned_resized.mp4"};

Movie[] clips = new Movie[movies.length];
Movie startingAnim;

// Introductory Image
PImage img;

// Movie Choices

int choice;

/*------------- End Variables —------------*/

void setup() {

  size(1400, 800);

  // Arduino setup
  myPort = new Serial(this, Serial.list()[1], 9600);

  // fill the movie clips array
  for (int i = 0; i < movies.length; i++) {
    clips[i] = new Movie(this, movies[i]);
  }

  img = loadImage("startinganim.png");
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
    if (sipCount == 0) {
      startingAnim.play();
      image(startingAnim, 0, 0);
      //delay(2000);
      //clips[choice].loop();
      //image(clips[choice], 0, 0);
    } else {
      clips[choice].loop();
      image(clips[choice], 0, 0);
    }
  }
  else {
    image(img, 0, 0);
  }

  delay(250);
}
