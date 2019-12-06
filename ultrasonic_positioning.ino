#include <Math.h>

int trigPinReceiver = 9;      
int echoPinReceiver = 8;      
int trigPinTransmit1 = 2;   
int trigPinTransmit2 = 3;  

const int n = 6; //number of variables to average
float lenH = 910; //sensor height in mm
float lenW = 1520; // distance between sensors in mm

float coordX[n];
float coordY[n];

float averageCoord_X = 0, averageCoord_Y = 0;
float alfa, cosAlfa; //angle between X axis and receiver
float lenC, lenE, lenB, lenD; //distance between receiver and transmitter 1/2; distance between receiver and beginning/ending of X axis

void setup() {
  Serial.begin (115200);
  pinMode(trigPinReceiver, OUTPUT);
  pinMode(echoPinReceiver, INPUT);
  pinMode(trigPinTransmit1, OUTPUT);
  pinMode(trigPinTransmit2, OUTPUT);

  for (int i = 0; i < n; i++){
    coordX[i] = 0;
    coordY[i] = 0;
  }
}

void loop() {
   
  //measure distance between 1-st transmitter and receiver
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit1, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPinReceiver, HIGH);  digitalWrite(trigPinTransmit1, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit1, LOW);
  
  lenC = pulseIn(echoPinReceiver, HIGH) / 58 * 20; //C in mm
  
  delay(100);

  //measure distance between 2-nd transmitter and receiver
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPinReceiver, HIGH);  digitalWrite(trigPinTransmit2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);
 
  lenE = pulseIn(echoPinReceiver, HIGH) / 58 * 20; //E in mm
  
  delay(100);

  //calculate distance between receiver and beginning
  lenB = sqrt(pow(lenC, 2) - pow(lenH, 2));

  //calculate distance between receiver and ending
  lenD = sqrt(pow(lenE, 2) - pow(lenH, 2));

  //calculate angle between X axis and receiver
  cosAlfa = (pow(lenW, 2) + pow(lenB, 2) - pow(lenD, 2))/(2*lenB*lenW);
  if (cosAlfa > 1) {
    alfa = 0;
  } else if (cosAlfa < -1) {
    alfa = 3.14159265;
  } else {
    alfa = acos(cosAlfa);
  }

  //shift coordinates in array
  for (int i = n-1; i >= 1; i--){
    coordX[i] = coordX[i-1];
    coordY[i] = coordY[i-1];
  }

  //calculate X and Y coords of receiver
  coordX[0] = lenB*cos(alfa);
  coordY[0] = lenB*sin(alfa);

  //calcualte average X and Y coords
  averageCoord_X = 0;
  averageCoord_Y = 0;
  for (int i = 0; i < n; i++){
    averageCoord_X += coordX[i];
    averageCoord_Y += coordY[i];
  }
  averageCoord_X /= n*10;
  averageCoord_Y /= n*10;

  Serial.println("X = " + String(averageCoord_X, 3) + " cm");
  Serial.println("Y = " + String(averageCoord_Y, 3) + " cm");

  //Serial.println("lenC = " + String(lenC));
  //Serial.println("lenE = " + String(lenE));

  //Serial.println("lenB = " + String(lenB));
  //Serial.println("lenD = " + String(lenD));

  //Serial.println("cos(alfa) = " + String(cosAlfa));
  //Serial.println("alfa = " + String(alfa));

  //Serial.println("Coord X = " + String(coordX[0])); 
  //Serial.println("Coord Y = " + String(coordY[0]));

  Serial.println();
}
