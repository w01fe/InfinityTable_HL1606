void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A', BYTE);   // send a capital A
    delay(300);
  }
}

byte waitForByte() {
  while(!Serial.available());
  return Serial.read();
}

unsigned int waitForInt() {
   return waitForByte() * ((unsigned int) 256) + waitForByte(); 
}

unsigned long waitForLong() {
   return (unsigned long) waitForInt() * 65536L + waitForInt(); 
}


void runTableServer() {
  unsigned long l;
  while(true) {
    byte inByte = waitForByte();
    if (inByte == '\n') {
        inByte = waitForByte();
        switch (inByte) {
          case 'p':
            strip.sendByte(waitForByte());
            break;
          case 'l':
            strip.latch();
            break;
          case 'f':
            strip.fades(1,350);
            break;
          case 'g':
            strip.fades(waitForByte(),waitForLong()); 
            break;
          case 'd': 
            delayLongMicroseconds(waitForLong());
            break;
          default:
//            Serial.println("(p)ush commands, (l)atch, (f)ade, (d)elay?");
            break;
        }
        Serial.print(inByte);        
        Serial.print((byte) Serial.available());
        Serial.print('\n');        
    }  
//  Serial.print(firstSensor, BYTE);
  }
}
