void runClock(int steps, int stepMs) {
//  setTime(3,23,15,1,1,2011); // hr, min, sec, day, month, year
  
  unsigned int i;
  
  unsigned int offset = 34 + (LEDCount / 2);
  unsigned char ref[LEDCount];
  
  unsigned int nsecond = second();
  unsigned int nminute = minute();
  unsigned int nhour = hourFormat12();
  
  unsigned int minuteWidth = 3;
  unsigned int hourWidth = 5;
  
  unsigned char twelveColor = Command | RedOn | GreenOn | BlueOn;
  unsigned char tickColor = Command | RedUp | GreenUp | BlueUp;
  unsigned char secondColor = Command | RedOn;
  unsigned char minuteColor = Command | BlueOn | RedOn;
  unsigned char hourColor = Command | GreenOn | RedOn;
  
  unsigned int secondPos = (LEDCount-1) - (LEDCount * (nsecond / 60.0));
  unsigned int secondPosOld = secondPos;
  
  unsigned int minutePos = (LEDCount-1) - (LEDCount * (nminute / 60.0));
  unsigned int minutePosOld = minutePos;
  
  unsigned int hourPos = (LEDCount-1) - (LEDCount * (nhour / 12.0));
  unsigned int hourPosOld = hourPos;
  
  for(i = 0; i < LEDCount; i++) {
    ref[i] = Command;
  }
    
  i = 0;
  while(keepGoing() && steps > 0) {
    nsecond = second()-1;
    nminute = minute()-1;
    nhour = hourFormat12();
    if (nhour == 12) nhour = 0;
    
    secondPos = (LEDCount-1) - (LEDCount * (nsecond / 60.0));
    minutePos = (LEDCount-1) - (LEDCount * (nminute / 60.0));
    hourPos = (LEDCount-1) - (LEDCount * (nhour / 12.0));
    
    // Clear old second tick
    if (secondPos != secondPosOld) {
      if (nsecond > 29) secondPos--;
      if (ref[secondPosOld] == secondColor) {
        ref[secondPosOld] = Command;
      }
      secondPosOld = secondPos;
    }
    
    if (minutePos != minutePosOld) {
      // if (nminute > 29) minutePos++;
      ref[minutePosOld-1] = ref[minutePosOld] = ref[minutePosOld+1] = Command;
      minutePosOld = minutePos;
    }
    
    if (hourPos != hourPosOld) {
      if (nhour > 5) hourPos--;
      ref[hourPosOld+4] = ref[hourPosOld+3] = ref[hourPosOld+2] = ref[hourPosOld+1] = ref[hourPosOld] = Command;
      hourPosOld = hourPos;
    }
    
    // Set hour and minute hands
    ref[hourPos+4] = ref[hourPos+3] = ref[hourPos+2] = ref[hourPos+1] = ref[hourPos] = hourColor;
    ref[minutePos-1] = ref[minutePos] = ref[minutePos+1] = minuteColor;
    
    // Set ticks
    for(i = 0; i < 12; i++) ref[round(i * (LEDCount / 11))-1] = tickColor;
    ref[0] = twelveColor;
    
    // Set second hand
    ref[secondPos] = secondColor;
    
    if (auxPressed) offset++;
    if (offset >= LEDCount-1) offset = 0;
    
    
    // Draw ring
    strip.setRing(ref, offset, LEDCount);
    
    // Steps and delay
    steps--;
    delay(stepMs);
  }
}
