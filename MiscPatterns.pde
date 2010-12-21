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

void runSlowWhite() {
//  strip.setAll(Command | RedOn | BlueOn | GreenOn);
//  strip.latch();
//  delay(1000);
  long int ind = 0;
  float d = 0.8;
  while(keepGoing() && d < 1000) {
    strip.sendByte(primaryCommands[ind % 3]);
//    strip.sendByte(rainbowCommands[ind % 6]);
    strip.latch();
    delay((int) d);
    ind++;    
    d = d * pow(1.5, d / 1000.0);
  } 
  delay(1000);
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
