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

// Here we have inelastic collisions and variable speeds.

int cl(float f) {
  if (f > 0) return (int) (f+0.9999); 
  return (int) (f-0.9999); 
}

// Billiard ball physics
void runVariablePhysics(int steps, int stepMs) {
  float cr = 1.0;  // Coefficient of restitution

  unsigned char positions[LEDCount];
  char velocities[LEDCount];
  int ind;
  for(ind = 0; ind < LEDCount; ind++) {
    positions[ind] = Command;
    velocities[ind] = 0;
    if (random(2) == 0) {
      positions[ind] = randPrimaryCommand();
      velocities[ind] = random(11) - 5;
    }
  }
  while(keepGoing() && steps > 0) {
    int dir = (steps % 2 == 0) ? -1 : 1;
    boolean firstMoved = false;
    for(int i= 0; i < LEDCount; i++) {
      if (i == LEDCount - 1 && firstMoved) continue;
      int ind = (dir == -1) ? i : LEDCount - i - 1;
      int v = velocities[ind];
      int s = v * dir;
      if (s > 0 && (((steps / 2) % s) == 0) ) {
        if (i == 0) firstMoved = true;
         int c = positions[ind];
         int ni = (ind + dir + LEDCount) % LEDCount;
         if (c == positions[ni]) {
           positions[ind] = positions[ni] = Command;
           velocities[ind] = velocities[ni] = 0; 
         } else if (positions[ni] != Command) {
           float ov1 = v == 0 ? 0 : 1.0 / v;
           float ov2 = velocities[ni] == 0 ? 0 : 1.0 / velocities[ni];
           float nv1 = (cr * (ov2 - ov1) + ov1 + ov2) / 2;
           float nv2 = (cr * (ov1 - ov2) + ov1 + ov2) / 2;
           velocities[ind] = cl(nv1 == 0.0 ? 0 : 1/nv1);
           velocities[ni] =  cl(nv2 == 0.0 ? 0 : 1/nv2);
         } else {
           positions[ni] = c;
           positions[ind] = Command;
           velocities[ni] = v;
           velocities[ind] = 0;
         }
         
      } 
    }
    strip.setRing(positions, 0, LEDCount);
    delay(stepMs);
    steps--;
  }  
}


// http://mathworld.wolfram.com/ElementaryCellularAutomaton.html
void runBinaryCA(int rule, int steps, int stepMs) {
  boolean cell[LEDCount];
  boolean cell2[LEDCount];
  if (steps % 2 == 1) steps++;

  for(int ind = 0; ind < LEDCount; ind++) cell[ind] = false;
  cell[87] = true;  
 
  while(keepGoing() && steps > 0) {
    boolean *ccs, *ncs;
    if (steps % 2 == 0) {
        ccs = cell;
        ncs = cell2; 
    } else {
        ccs = cell2;
        ncs = cell;       
    }
    
    for(int i= 0; i < LEDCount; i++) {
      strip.sendByte(ccs[i] ? Command | RedOn | GreenOn | BlueOn : Command);        
      int pi = (i + LEDCount - 1) % LEDCount;
      int ni = (i + 1) % LEDCount;
      
      int oc = (ccs[pi] ? 4 : 0) + 
               (ccs[i]  ? 2 : 0) + 
               (ccs[ni] ? 1 : 0);
      ncs[i] = (rule & (1 << oc)) > 0; 
    }
    strip.latch();

    
    delay(stepMs);
    steps--;
  }  
}


// http://mathworld.wolfram.com/TotalisticCellularAutomaton.html
void runTrinaryCA(int rule, int steps, int stepMs) {
  unsigned char codes[8];
  for(int ind = 0; ind < 8; ind++) {
    codes[ind] = rule % 3;
    rule /= 3;  
  }
  
  unsigned char cell[LEDCount];
  unsigned char cell2[LEDCount];
  if (steps % 2 == 1) steps++;

  for(int ind = 0; ind < LEDCount; ind++) cell[ind] = 0;
  cell[87] = 2;  
 
  while(keepGoing() && steps > 0) {
    unsigned char *ccs, *ncs;
    if (steps % 2 == 0) {
        ccs = cell;
        ncs = cell2; 
    } else {
        ccs = cell2;
        ncs = cell;       
    }
    
    for(int i= 0; i < LEDCount; i++) {
      if (ccs[i] == 0) strip.sendByte(Command);
      if (ccs[i] == 1) strip.sendByte(Command | BlueOn);
      if (ccs[i] == 2) strip.sendByte(Command | RedOn);
      int pi = (i + LEDCount - 1) % LEDCount;
      int ni = (i + 1) % LEDCount;
      
      int oc = ccs[pi] + ccs[i] + ccs[ni];
      ncs[i] = codes[oc]; 
    }
    strip.latch();

    
    delay(stepMs);
    steps--;
  }  
}
