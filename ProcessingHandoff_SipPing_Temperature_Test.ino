#include <Adafruit_CircuitPlayground.h>

/*
 * Processing Hand-Off
 * 
 * This is the code that'll click into Processing, and tell Processing
 * when a sip has been taken and what the temperature currently is.
 * 
 *
 * Last Updated October 17 2022
 * by Carmen Vargas
 */

// Sip count variables
float sip = 0;
float Z;
float tiltMin = 9;
bool sipFlag = false;

// temperature variables
float temp;

// the number of values we're sending to Processing
// at the moment - we're sending the sipCount and the temperature to Processing
int values[2];

void setup() {

  CircuitPlayground.begin();
  Serial.begin(9600);

}

void loop() {

  // Sip Count Segment

  Z = CircuitPlayground.motionZ();

  /*
   * Values Testing - uncomment to see what's the current Z values & constant sip count
   * 
  Serial.print("Z: ");
  Serial.print(Z);
  Serial.print(" Sips: ");
  Serial.println(sip);
  */

  

  if(Z < tiltMin && sipFlag == false) {
    sipFlag = true;
    //Serial.println("sipFlag is up!");
  }
  else if(Z > tiltMin && sipFlag == true) {
    //Serial.println("sipFlag is down!");
    sipFlag = false;
    sip = 1;
    
//    Serial.print("Sip taken!");
//    Serial.print("\t");
//    Serial.println(sip);
  }
  else if(Z > tiltMin && sipFlag == false) {
    
    sip = 0;

//    Serial.print("No sip taken");
//    Serial.print("\t");
//    Serial.println(sip);
  
  }

  temp = CircuitPlayground.temperatureF();
//  Serial.print("Temperature ");
//  Serial.print(temp);
//  Serial.println(" *F");

  // Send the sip count and temperature to Processing!
  values[0] = sip;
  values[1] = temp;
  Serial.println(String(values[0]) + "split" + String(values[1]));

  delay(500);
}
