// Simulations -- physics, cellular automata

// Round and round with color changing

unsigned char nextColor(unsigned char c) {
  if (c == (Command | RedOn)) return Command | GreenOn;
  if (c == (Command | GreenOn)) return Command | BlueOn;
  if (c == (Command | BlueOn)) return Command | RedOn;
  else  return Command;
}

void runOneBackwards(int steps, int stepMs) {
  unsigned char init[LEDCount];
  int ind;
  for(ind = 0; ind < LEDCount; ind++) {
//    if (random(2) == 0) 
    init[ind] = Command | RedOn;
//    else init[ind] = Command;    
  }
  ind = 0;
  int whiteInd = 25;
  while(keepGoing() && steps > 0) {
    unsigned char oldC = init[whiteInd];
    unsigned char newC = nextColor(oldC);
    init[whiteInd] = Command | RedOn | BlueOn | GreenOn;
    strip.setRing(init, ind, LEDCount);
    init[whiteInd] = newC;
    whiteInd = (whiteInd + 1) % LEDCount;
    if (steps % 2 == 0) ind = (ind + 1) % LEDCount; 
    delay(stepMs);
    steps--;
  }  
}

void runUniformPhysics(int steps, int stepMs) {
  unsigned char left[LEDCount];
  unsigned char right[LEDCount];
  int ind;
  for(ind = 0; ind < LEDCount; ind++) {
    left[ind] = right[ind] = Command;
    if (random(2) == 0) {
      if (random(2) == 0) left[ind] = randPrimaryCommand();
      else  right[ind] = randPrimaryCommand();
    }
  }
  int leftInd = 0;
  int rightInd = 0;
  while(keepGoing() && steps > 0) {
    for(ind= 0; ind < LEDCount; ind++) {
      int lI = (ind + leftInd) % LEDCount; 
      int rI = (ind + rightInd) % LEDCount; 
      if (left[lI] == right[rI]) {
        left[lI] = right[rI] = Command;
      } else if (left[lI] != Command && right[rI] != Command) {
        unsigned char tmp = left[lI];
        left[lI] = right[rI];
        right[rI] = tmp;
      }  
      if (left[lI] != Command) strip.sendByte(left[lI]);      
      else strip.sendByte(right[rI]);
    }
    strip.latch();
    if (steps % 2 == 0) {
      leftInd = (leftInd + 1) % LEDCount;
    } else { 
      rightInd = (rightInd + LEDCount - 1) % LEDCount; 
    }      
    delay(stepMs);
    steps--;
  }  
}
