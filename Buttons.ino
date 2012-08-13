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

