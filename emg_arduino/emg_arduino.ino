const int emg = 1;
int emgArray[100];

void setup() {
  //Starting the serial monitor
  Serial.begin(9600);
}

void loop() {
  for (int a = 0; a < 100; a++) {
    int b = analogRead(emg);
    if (b < 1) {
      a = a - 1;
    } else {
      emgArray[a] = b;
      Serial.print(emgArray[a]);
      Serial.print(",");
    }
    delay(20);
  }
  while (true) {
    Serial.println(".");
    while (1);
  }
}

