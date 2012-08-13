unsigned char triRainbow[3] = {
Commandx2 | RedDown   | GreenUp | BlueOff,
Commandx2 | RedOff    | GreenDown | BlueUp,
Commandx2 | RedUp     | GreenOff | BlueDown
};

unsigned char hexRainbow[6] = {
Commandx2 | RedOn   | GreenUp   | BlueOff,
Commandx2 | RedDown | GreenOn   | BlueOff,
Commandx2 | RedOff  | GreenOn   | BlueUp,
Commandx2 | RedOff  | GreenDown | BlueOn,
Commandx2 | RedUp   | GreenOff  | BlueOn,
Commandx2 | RedOn   | GreenOff  | BlueDown
};

unsigned char blackRainbow[6] = {
Commandx2 | RedUp   | GreenOff  | BlueOff,
Commandx2 | RedOn   | GreenUp   | BlueOff,
Commandx2 | RedDown | GreenOn   | BlueOff,
Commandx2 | RedOff  | GreenOn   | BlueUp,
Commandx2 | RedOff  | GreenDown | BlueOn,
Commandx2 | RedOff   | GreenOff  | BlueDown
};

void runRainbow(unsigned char *buffer, int len, int ms) {
  unsigned int i=0;
  while(true) {
    strip.setRing(buffer, i, len);
    strip.fades(64, ms);
    i = (i + 1) % len;    
  }
}

void runTriRainbow() {
  runRainbow(triRainbow, 3, 250);
}

void runHexRainbow() {
  runRainbow(hexRainbow, 6, 250);
}

void runStretchRainbow(unsigned char *commands, int len, int scale, int us) {
  unsigned int c = -1;
  unsigned int sc = 0;
  unsigned int nFades = 0;
  while(keepGoing()) {
    if (sc == 0) {
      nFades = 0; 
      c = (c + 1) % len;
      strip.sendByte(commands[c]);
    } else {
      strip.sendByte(Noop);
    }
    strip.latch();
    if (auxPressed) { us = 750;} else {us = 2000;}
    int dFades = (sc * 64) / scale;
    if (dFades > nFades) {
      strip.fades(dFades-nFades, us);
      nFades = dFades;
    } else {
      delayMicroseconds(us);
    }
    sc = (sc + 1) % scale;    
  }
}

void runStretchTriRainbow(int scale, int us) {
  runStretchRainbow(triRainbow, 3, scale, us);
}

void runStretchHexRainbow(int scale, int us) {
  runStretchRainbow(hexRainbow, 6, scale, us);
}

void runStretchBHexRainbow(int scale, int us) {
  runStretchRainbow(blackRainbow, 6, scale, us);
}

// Blue races around in circle.
void runRacingBlue(int scale, int us) {
  unsigned char colors[3] = {
    Commandx2 | BlueDown, 
    Command,    Command
  };
  runStretchRainbow(colors, 3, scale, us);
}



void runStretchToRainbow(unsigned char *commands, int len, int maxScale, int us) {
  unsigned int c = -1;
  unsigned int sc = 0;
  unsigned int nFades = 0;
  unsigned int scale = 1;
  unsigned int rounds = maxScale;
  while(keepGoing() && (scale < maxScale || rounds > 0 )) {
    if (sc == 0) {
      nFades = 0; 
      c = (c + 1) % len;
      if (c == 0) rounds--;
      if (rounds == 0) {
        scale++;
        rounds = maxScale / scale;
        if (scale == maxScale) rounds = 10;
      }     
      strip.sendByte(commands[c]);
    } else {
      strip.sendByte(Noop);
    }
    strip.latch();
    if (auxPressed) { us = 750;} else {us = 2000;}
    int dFades = (sc * 64) / scale;
    if (dFades > nFades) {
      strip.fades(dFades-nFades, us);
      nFades = dFades;
    } else {
      delayMicroseconds(us);
    }
    sc = (sc + 1) % scale;    
  }
}



void runStretchToTriRainbow(int scale, int us) {
  runStretchToRainbow(triRainbow, 3, scale, us);
}

