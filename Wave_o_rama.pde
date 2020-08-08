// Wavinator a.k.a Wave Counter a.k.a Waveorama EX
// 10/16/17 Kevin Fredericks
// The more you know, the less you need

import processing.io.*;
//SPI MCP;
//int CHANNELS = 8; // 8 channels on the MCP3008
//int[] channel = new int[CHANNELS];

// Define and initialize variables for wave display
int wave1 = 1;
int wave2 = 2;
int textHeight = 220;
int padding = 20;
int UImargin = 40;
int delta = 0;// Delta for input-delay
int ldelta = 0;
int rdelta = 0;
int delay = 10;

// GPIO Pins

int pedal = 2;
int leftSwitch = 3;
int rightSwitch = 15;

void setup() { 
  fullScreen(); 
  textSize(textHeight);
  frameRate(10);
  stroke(255); // Changes color of center divider
  strokeWeight(10); // Changes center divider thickness
  smooth();
  GPIO.pinMode(pedal, GPIO.INPUT);
  GPIO.pinMode(leftSwitch, GPIO.INPUT);
  GPIO.pinMode(rightSwitch, GPIO.INPUT);
} 

void draw() {
  // Receive data from GPIO
  //GPIOlow(pedal, 1);
  //GPIOlow(pedal, 2);
  GPIOhandler();
  // Needs refactoring of GPIOlow function

  // Refresh screen
  fill(0, 100, 0);
  rect(0, 0, displayWidth, displayHeight);

  // Text and divider color
  fill(0);

  // Draw vertical line to separate waves.
  line(width/2, 0, width/2, height);

  // Draw waves as alphanumeric characters
  drawWave(wave1, 0);
  drawWave(wave2, 1);
}

// UI/control functions

// GPIO Handler

void GPIOlow(int channel, int wave) {
 if ( GPIO.digitalRead(channel) == GPIO.LOW ) {
    if ( delta < 1 ) {
      if(wave==1) {wave1 += 1;}
      if(wave==2) {wave2 += 1;}
    }
    // Increment delta at frameRate
    delta += 1;
    if ( delta%delay == 0 && wave1>1 && wave2>2) {
      if(wave==1) {wave1 -= 1;}
      if(wave==2) {wave2 -= 1;}
    }
  } else {
    delta = 0; // Delta resets for press-delay
  } 
}

void GPIOhandler() {
 if ( GPIO.digitalRead(pedal) == GPIO.LOW ) {
    if ( delta < 1 ) {
      wave1 += 1;
      wave2 += 1;
    }
    // Increment delta at frameRate
    delta += 1;
    if ( delta%delay == 0 && wave1>1 && wave2>2) {
      wave1 -= 1;
      wave2 -= 1;
    }
  } else if ( GPIO.digitalRead(pedal) == GPIO.HIGH ) {
    delta = 0; // Delta resets for press-delay
  }
  // Repeating for leftSwitch
  if ( GPIO.digitalRead(leftSwitch) == GPIO.LOW ) {
    if ( ldelta < 1 ) {
      wave1 += 1;
    }
    // Increment delta at frameRate
    ldelta += 1;
    if ( ldelta%delay == 0 && wave1>1) {
      wave1 -= 1;
    }
  } else if ( GPIO.digitalRead(leftSwitch) == GPIO.HIGH ) {
    ldelta = 0; // Delta resets for press-delay
  }
  
  // Repeating for rightSwitch
  if ( GPIO.digitalRead(rightSwitch) == GPIO.LOW ) {
    if ( rdelta < 1 ) {
      wave2 += 1;
    }
    // Increment delta at frameRate
    rdelta += 1;
    if ( rdelta%delay == 0 && wave2>2) {
      wave2 -= 1;
    }
  } else if ( GPIO.digitalRead(rightSwitch) == GPIO.HIGH ) {
    rdelta = 0; // Delta resets for press-delay
  }
}



// Draws wave numbers
void drawWave(int wave, int side) {
  if (side == 0) {
    // Center single digits
    if (wave < 10) {
      text(wave, width/8+padding, textHeight);
    } else {
      text(wave, padding, textHeight);
    }
  } else if (side == 1) {
    // Center single digits
    if (wave < 10) {
      text(wave, padding+width/2+width/8, textHeight);
    } else {
      text(wave, padding+width/2, textHeight);
    }
  }
}

// Control function (not used in client)
/* void mouseReleased() { 
 // Check if mouse is on left side of UI
 
 if(mouseX < width/2) {
 
 if(mouseY < UImargin) {
 wave1 += 1;
 } 
 if(mouseY > height-UImargin) {
 wave1 -= 1;
 }
 // Check if mouse is on right side of UI
 
 } else if(mouseX > width/2) {
 if(mouseY < UImargin) {
 wave2 += 1;
 }
 if(mouseY > height-UImargin) {
 wave2 -= 1;
 }
 }
 
 // Hotfix to prevent negative waves
 wave1 = incNegative(wave1);
 wave2 = incNegative(wave2);
 }
 */