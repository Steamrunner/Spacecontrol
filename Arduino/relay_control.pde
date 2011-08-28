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
 
int state = -1; 
int relay = -1;
int relayValue = -1;

char inChar;
char *pointer;
// relay board www.ett.co.tn
void loop() {
  if (Serial.available() > 0) {
    inChar = Serial.read();
    if (inChar == '%') {
      state = READRELAY;
    } else if (inChar == '#') {
      state = READRELAYVALUE;
    } else if (state == READRELAY) {
      state  = -1;
      if ((inChar >= 48) && (inChar < (48 + NUMBEROFRELAY)) || (inChar == 65)) {
        if (inChar == 65) {
          relay = NUMBEROFRELAY;
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
  Serial.println("Ready for commands");
}


