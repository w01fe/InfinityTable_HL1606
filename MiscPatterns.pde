void runRandFill(int initDelay) {
  int nLeft = LEDCount;
  int ind = 0;
  int arr[LEDCount];
  for(ind = 0; ind < LEDCount; ind++) arr[ind] = Command;
  ind = 0;
  strip.setAll(Command);
  boolean fill = false;
  while(keepGoing() && nLeft > 0) {
    int boost = nLeft * nLeft / LEDCount;
    if (random(boost * nLeft / LEDCount) < 2) fill = true;
    if (fill && arr[ind] == Command) {
      fill = false;
      arr[ind] = randPrimaryCommand();
      nLeft--;
    }
    fill = false;
    strip.sendByte(arr[ind]);
    strip.latch();
    ind = (ind + 1) % LEDCount;
    delay(boost / 2 + 5);
  } 
}

void runBars() {
  strip.setAll(Command);
  int ind = 0;
  while(keepGoing()) {
    int nPer = auxPresses % 20 + 1;
    if ((ind % (2 * nPer)) < nPer) strip.sendByte(Command | BlueOn);
    else strip.sendByte(Command);
    strip.latch();
    delay(50);
    ind++;
  } 
}

void delayLongMicroseconds(long x) {
  while(x > 1000) {
    delayMicroseconds(1000);
    x -= 1000;
  }
  delayMicroseconds(x); 
}

void runSlowWhite() {
  long int ind = 0;
  float d = 0.8;
  float base = 1.5;
  for(int i = 0; i < 5; i++) {
    while(keepGoing() && d < 1000.0 && d > 0.79) {
      strip.sendByte(primaryCommands[ind % 3]);
      strip.latch();
      delayLongMicroseconds((long)(d * 1000));
      ind++;    
      d = d * pow(base, d / 1000.0);
    } 
    if (d >= 1000) {
      base = 1.0 - 0.12 * (i + 3); 
      d = 999;      
      delay(500);          
    } else if (d <= 0.79) {
      base = 1 + 0.5 * (i+1);
      d = 0.8;
    }
  }
}

void runFadingDots(int cycles, int nFades, int ms) {
  strip.setAll(Command);
  strip.latch(); 
  while(keepGoing() && cycles > 0) {
    if (random(nFades) == 0) {
      strip.setOne(random(LEDCount), Command | RedDown, Noop);
      strip.latch();
    }
    strip.fades(1, 250);
    delay(ms);
    cycles--;
  }
}
