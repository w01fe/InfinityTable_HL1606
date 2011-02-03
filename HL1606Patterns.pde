#include <HL1606.h>
#include <Time.h>

#define LEDCount 118    //Set how many LEDs we'll be driving.

HL1606 strip(2, 3, 4, 5, LEDCount);  
const int buttonPin1 = 8;    
const int buttonPin2 = 9;    

void setup() {
  strip.setAll(Command);
  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  randomSeed(analogRead(0));
}

unsigned int auxPresses = 0;
boolean auxPressed = false;
long whenAuxPressed = 0;
unsigned int auxTimer = 1000;

void processAuxButton() {
  int buttonState = digitalRead(buttonPin2);
  if (buttonState == HIGH) {
    long ct = millis();
    if (!auxPressed) {
      auxPressed = true;
      whenAuxPressed = ct - (auxTimer - 100);
    } else if (ct > whenAuxPressed + auxTimer) {
      auxPresses++;
      whenAuxPressed = ct;
    }
  } else {
    auxPressed = false;
  }
}

unsigned int modePressCount = 0;
boolean modePressed = false;
long whenModePressed = 0;

// Return true if should keep going
boolean keepGoing() {
  processAuxButton();
  int buttonState = digitalRead(buttonPin1);
  if (buttonState == HIGH) {
    long ct = millis();
    if (!modePressed) {
      modePressed = true;
      whenModePressed = ct - 900;
    } else if (ct > whenModePressed + 1000) {
      modePressCount++;
      whenModePressed = ct;
      return false;
    }    
  } else {
    modePressed = false;
  }   
  return true;
}

int mode = 6;
void loop() {  

  switch(mode % 7) {
    case 0:
      runSlowWhite();
      break;
    case 1: 
      runStretchToTriRainbow(20, 5000);
      break;
    case 2:
      runClock(1000, 20);
      break;
    case 3:
      runFadingDots(5000, 5, 1);
      break;
    case 4:
      runOneBackwards(1000, 5);
      break;
    case 5:
      runUniformPhysics(1000, 20);
      break;
    case 6:
      runRandFill(100);
      break;
  }
  mode++;
  
}

unsigned char primaryCommands[3] = {
Command | RedOn ,
Command | GreenOn,
Command | BlueOn
};

unsigned char rainbowCommands[6] = {
Command | RedOn ,
Command | GreenOn | RedOn,
Command | GreenOn,
Command | BlueOn | GreenOn,
Command | BlueOn,
Command | BlueOn | RedOn
};
