// All unique fades, in lexicographic order.
// Ignore fades of constant hue, since these hues are hit otherwise.
unsigned char allFades[22] = {
Command | RedOff   | GreenOff  | BlueOff, // Black, as reference  
//Command | RedOff   | GreenOff  | BlueUp, -- just blues
Command | RedOff   | GreenOn  | BlueUp, // - lime to turquose
//Command | RedOff   | GreenUp  | BlueOff, -- just greens
Command | RedOff   | GreenUp  | BlueOn, //  deep blue to bluish white
//Command | RedOff   | GreenUp  | BlueUp, -- bluish white hue
Command | RedOff   | GreenUp  | BlueDown,
Command | RedOn   | GreenOff  | BlueUp,
Command | RedOn   | GreenOn  | BlueUp,
Command | RedOn   | GreenUp  | BlueOff,
Command | RedOn   | GreenUp  | BlueOn,
Command | RedOn   | GreenUp  | BlueUp,
Command | RedOn   | GreenUp  | BlueDown,
//Command | RedUp   | GreenOff  | BlueOff, -- just whites
Command | RedUp   | GreenOff  | BlueOn,
//Command | RedUp   | GreenOff  | BlueUp,
Command | RedUp   | GreenOff  | BlueDown,
Command | RedUp   | GreenOn  | BlueOff,
Command | RedUp   | GreenOn  | BlueOn,
Command | RedUp   | GreenOn  | BlueUp,
Command | RedUp   | GreenOn  | BlueDown,
//Command | RedUp   | GreenUp  | BlueOff,
Command | RedUp   | GreenUp  | BlueOn,
//Command | RedUp   | GreenUp  | BlueUp,
Command | RedUp   | GreenUp  | BlueDown,
Command | RedUp   | GreenDown  | BlueOff,
Command | RedUp   | GreenDown  | BlueOn,
Command | RedUp   | GreenDown  | BlueUp,
Command | RedUp   | GreenDown  | BlueDown,
};

// Shrink must be >= 1.
void testSpectra() {
  int lastAux = -1;
  while(auxPresses != lastAux) {
    lastAux = auxPresses;
    int count;
    strip.setAll(Command);
    
    strip.sendByte(allFades[auxPresses % 28]);
    for(count = 0; count < 128; count++) {
      strip.fade();
      strip.sendByte(Noop);
      strip.latch();
    }
    while(keepGoing() && (lastAux == auxPresses)) {
      delay(10);
    }
  }
} 

