#include <avr/wdt.h>

// Define relay pins
const int relayRed = A0;    // Relay for Red LED strip
const int relayBlue = A2;   // Relay for Blue LED strip
const int relayGreen = A1;  // Relay for Green LED strip

bool partyModeActive = false;  // Flag to indicate if party mode is active
bool poModeActive = false;     // Flag to indicate if PO mode is active
bool flashModeActive = false;  // Flag to indicate if flash mode is active

void setup() {
  // Set relay pins as outputs
  pinMode(relayRed, OUTPUT);
  pinMode(relayBlue, OUTPUT);
  pinMode(relayGreen, OUTPUT);

  // Initialize all relays to be off
  digitalWrite(relayRed, LOW);
  digitalWrite(relayBlue, LOW);
  digitalWrite(relayGreen, LOW);

  // Start serial communication
  Serial.begin(9600);

  // System startup sequence: all relays on (white)
  digitalWrite(relayRed, HIGH);
  digitalWrite(relayBlue, HIGH);
  digitalWrite(relayGreen, HIGH);
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read(); // Read the command

    // Reset the mode flags if a new command is received
    if (command != 'A' && command != 'a' && command != 'S' && command != 's' && command != 'D' && command != 'd' && command != 'P' && command != 'p' && command != 'O' && command != 'o' && command != '7' && command != 'W' && command != 'w' && command != 'R' && command != 'r' && command != 'G' && command != 'g' && command != 'B' && command != 'b') {
      partyModeActive = false; 
      poModeActive = false;
      flashModeActive = false;
    }

    switch (command) {
      case '0':
        // Turn off all relays
        digitalWrite(relayRed, LOW);
        digitalWrite(relayBlue, LOW);
        digitalWrite(relayGreen, LOW);
        break;
      case '1':
        // Turn on red relay
        digitalWrite(relayRed, HIGH);
        digitalWrite(relayBlue, LOW);
        digitalWrite(relayGreen, LOW);
        break;
      case '2':
        // Turn on green relay
        digitalWrite(relayRed, LOW);
        digitalWrite(relayBlue, LOW);
        digitalWrite(relayGreen, HIGH);
        break;
      case '3':
        // Turn on blue relay
        digitalWrite(relayRed, LOW);
        digitalWrite(relayBlue, HIGH);
        digitalWrite(relayGreen, LOW);
        break;
      case '4':
        // Turn on red and green relays (yellow)
        digitalWrite(relayRed, HIGH);
        digitalWrite(relayGreen, HIGH);
        digitalWrite(relayBlue, LOW);
        break;
      case '5':
        // Turn on red and blue relays (magenta)
        digitalWrite(relayRed, HIGH);
        digitalWrite(relayGreen, LOW);
        digitalWrite(relayBlue, HIGH);
        break;
      case '6':
        // Turn on green and blue relays (cyan)
        digitalWrite(relayRed, LOW);
        digitalWrite(relayGreen, HIGH);
        digitalWrite(relayBlue, HIGH);
        break;
      case '7':
      case 'W':
      case 'w':
        // Turn on all relays (white)
        digitalWrite(relayRed, HIGH);
        digitalWrite(relayGreen, HIGH);
        digitalWrite(relayBlue, HIGH);
        break;
      case 'A':
      case 'a':
        // Party mode 1: delay 300 ms
        partyModeActive = true;
        partyMode(300);
        break;
      case 'S':
      case 's':
        // Party mode 2: delay 200 ms
        partyModeActive = true;
        partyMode(200);
        break;
      case 'D':
      case 'd':
        // Party mode 3: delay 125 ms
        partyModeActive = true;
        partyMode(125);
        break;
      case 'P':
      case 'p':
        // Super party mode: delay 60 ms
        partyModeActive = true;
        partyMode(60);
        break;
      case 'O':
      case 'o':
        // PO Mode: flash red and blue with delay of 200 ms
        poModeActive = true;
        poMode();
        break;
      case 'R':
      case 'r':
        // Flash red light
        flashModeActive = true;
        flashColor(relayRed);
        break;
      case 'G':
      case 'g':
        // Flash green light
        flashModeActive = true;
        flashColor(relayGreen);
        break;
      case 'B':
      case 'b':
        // Flash blue light
        flashModeActive = true;
        flashColor(relayBlue);
        break;
      case 'X':
      case 'x':
        // Reset the Arduino
        resetArduino();
        break;
    }
  }
}

// Function for party modes
void partyMode(int delayTime) {
  while (partyModeActive) {
    if (Serial.available() > 0) {
      char command = Serial.read();
      if (command == '0' || command == '1' || command == '2' || command == '3' || command == '4' || command == '5' || command == '6' || command == '7' || command == 'W' || command == 'w' || command == 'R' || command == 'r' || command == 'G' || command == 'g' || command == 'B' || command == 'b' || command == 'X' || command == 'x') {
        partyModeActive = false; // Exit party mode
        return;
      }
    }
    // Red
    digitalWrite(relayRed, HIGH);
    digitalWrite(relayGreen, LOW);
    digitalWrite(relayBlue, LOW);
    delay(delayTime);
    // Green
    digitalWrite(relayRed, LOW);
    digitalWrite(relayGreen, HIGH);
    digitalWrite(relayBlue, LOW);
    delay(delayTime);
    // Blue
    digitalWrite(relayRed, LOW);
    digitalWrite(relayGreen, LOW);
    digitalWrite(relayBlue, HIGH);
    delay(delayTime);
    // Yellow
    digitalWrite(relayRed, HIGH);
    digitalWrite(relayGreen, HIGH);
    digitalWrite(relayBlue, LOW);
    delay(delayTime);
    // Magenta
    digitalWrite(relayRed, HIGH);
    digitalWrite(relayGreen, LOW);
    digitalWrite(relayBlue, HIGH);
    delay(delayTime);
    // Cyan
    digitalWrite(relayRed, LOW);
    digitalWrite(relayGreen, HIGH);
    digitalWrite(relayBlue, HIGH);
    delay(delayTime);
    // White (all on)
    digitalWrite(relayRed, HIGH);
    digitalWrite(relayGreen, HIGH);
    digitalWrite(relayBlue, HIGH);
    delay(delayTime);
  }
}

// Function for PO Mode
void poMode() {
  while (poModeActive) {
    if (Serial.available() > 0) {
      char command = Serial.read();
      if (command == '0' || command == '1' || command == '2' || command == '3' || command == '4' || command == '5' || command == '6' || command == '7' || command == 'W' || command == 'w' || command == 'R' || command == 'r' || command == 'G' || command == 'g' || command == 'B' || command == 'b' || command == 'X' || command == 'x') {
        poModeActive = false; // Exit PO Mode
        return;
      }
    }
    // PO Mode: flash red and blue with delay of 200 ms
    digitalWrite(relayRed, HIGH);
    digitalWrite(relayBlue, LOW);
    digitalWrite(relayGreen, LOW);
    delay(200);
    digitalWrite(relayRed, LOW);
    digitalWrite(relayBlue, HIGH);
    digitalWrite(relayGreen, LOW);
    delay(200);
  }
}

// Function to flash a specific color
void flashColor(int relay) {
  while (flashModeActive) {
    if (Serial.available() > 0) {
      char command = Serial.read();
      if (command == '0' || command == '1' || command == '2' || command == '3' || command == '4' || command == '5' || command == '6' || command == '7' || command == 'W' || command == 'w' || command == 'R' || command == 'r' || command == 'G' || command == 'g' || command == 'B' || command == 'b' || command == 'X' || command == 'x') {
        flashModeActive = false; // Exit flash mode
        return;
      }
    }
    // Turn off all relays during the off cycle
    digitalWrite(relayRed, LOW);
    digitalWrite(relayGreen, LOW);
    digitalWrite(relayBlue, LOW);
    delay(500);
    // Turn on the specific relay during the on cycle
    digitalWrite(relay, HIGH);
    delay(500);
  }
}

// Function to reset the Arduino
void resetArduino() {
  wdt_enable(WDTO_15MS);
  while (1) {}
}
