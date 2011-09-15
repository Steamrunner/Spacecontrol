// string to int convertion based on:
// http://www.instructables.com/answers/How-to-input-NUMBERS-through-Arduino-serialmonito/

// FORMAT %RELAYNUMBER#PINVALUE

// Program states
#define READRELAY 0
#define READRELAYVALUE 1

// RELAYS
#define NUMBEROFRELAY 4
#define RELAY0 2
#define RELAY1 3
#define RELAY2 4
#define RELAY3 5
#define BUTTON 6
 
int state = -1; 
int relay = -1;
int relayValue = -1;

char inChar;
char *pointer;

long lastDebounceTime = 0;
long debounceDelay = 50;
int buttonState;  
int lastButtonState; 
int debouncing = false;

// relay board www.ett.co.tn

void loop() {
  // Listen for status change on button
  int reading = digitalRead(BUTTON);
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
    debouncing = true;
  } 
  if (((millis() - lastDebounceTime) > debounceDelay) && (debouncing == true)){
      for (int i=0;i<NUMBEROFRELAY;i++) {
          digitalWrite(i + 2, 1);
      }
    debouncing = false;
    buttonState = reading;
  }
  lastButtonState = reading;
  
  // Process serial input
  if (Serial.available() > 0) {
    inChar = Serial.read();
    if (inChar == '%') {
      state = READRELAY;
    } else if (inChar == '#') {
      state = READRELAYVALUE;
    } else if (state == READRELAY) {
      state  = -1;
      if ((inChar >= 48) && (inChar < (48 + NUMBEROFRELAY)) || (inChar == 65) || (inChar == 83)) {
        if (inChar == 65) {
          relay = NUMBEROFRELAY;
        } else if (inChar == 83) {
          Serial.print("S=");
          for (int i=0;i<NUMBEROFRELAY;i++) {
            Serial.print(!digitalRead(i + 2));
          }
          Serial.println();
        } else {
          *pointer = inChar;
          relay = atoi(pointer);
        }
      } else {
        relay = -1;
        relayValue = -1;
      }
    } else if (state == READRELAYVALUE) {
      state = -1;
      if ((inChar == 48) || (inChar == 49)) {
        *pointer = inChar;
        relayValue = atoi(pointer);
      } else {
        relay = -1;
        relayValue = -1;
      }
    }
    if ((relay != -1) && (relayValue != -1)) {
      if (relay == NUMBEROFRELAY) {
        for (int i=0;i<NUMBEROFRELAY;i++) {
          digitalWrite(i + 2, !relayValue);
        }
        Serial.print("All relays");
      } else {
        digitalWrite(relay + 2, !relayValue);
        Serial.print("Relay ");
        Serial.print(relay);
      }
      Serial.print(" set to ");
      Serial.println(relayValue);
      relay = -1;
      relayValue = -1;
    }
  }
}


void setup() {
  Serial.begin(2400); //9600
  Serial.println("Communication initialized");
  
  pinMode(RELAY0, OUTPUT);
  pinMode(RELAY1, OUTPUT);
  pinMode(RELAY2, OUTPUT);
  pinMode(RELAY3, OUTPUT);
  digitalWrite(RELAY0, HIGH);
  digitalWrite(RELAY1, HIGH);
  digitalWrite(RELAY2, HIGH);
  digitalWrite(RELAY3, HIGH);
  
  pinMode(BUTTON, INPUT);
  int lastButtonState = digitalRead(BUTTON); 
  
  Serial.println("Ready for commands");
}


