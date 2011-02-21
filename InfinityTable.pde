#include <HL1606.h>
#include <Time.h>

/*****************************************
* Set up the LED strip and 2 push-buttons
******************************************/

#define LEDCount 120    //Set how many LEDs we'll be driving.

HL1606 strip(2, 3, 4, 5, LEDCount);  
const int buttonPin1 = 8;    
const int buttonPin2 = 9;    

void setup() {
  strip.setAll(Command);
  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  randomSeed(analogRead(0));
  Serial.begin(9600);
}

/*****************************************
* Global vars and fns 
******************************************/

// Global vars for aux button state

unsigned int auxPresses = 0;
boolean auxPressed = false;
long whenAuxPressed = 0;
unsigned int auxTimer = 1000;

// Global vars for primary button state
// These are reserved for main mode
unsigned int modePressCount = 0;
boolean modePressed = false;
long whenModePressed = 0;

// Should call this in your inner loop to break out
// with mode switches, and process aux button presses. 
// If it returns false, your function should terminate.
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

/*****************************************
* Main loop -- loops through patterns,
* switching with primary button presses or 
* when previous mode times out.
******************************************/

int mode = 0;
void loop() {  
  switch(mode % 15) {
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
    case 7:
      runVariablePhysics(1000,2);
      break;
    case 8:
      runBinaryCA(90,200,100);
      break;
    case 9:
      runBinaryCA(102,200,100);
      break;
    case 10:
      runBinaryCA(30,200,100);
      break;
    case 11:
      runTrinaryCA(177,100,200);
      break;
    case 12:
      runTrinaryCA(912,600,50);
      break;
    case 13:
      runTrinaryCA(2040,2000,20);
      break;
    case 14:
      runStandingWaves(100,10);
      break;
  }
  mode++;
}



/*****************************************
* Misc. utilities, useful for other files.
******************************************/

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
