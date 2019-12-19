int trigPinReceiver = 9;      
int echoPinReceiver = 8;      
int trigPinTransmit1 = 2;   
int trigPinTransmit2 = 3;  

const int n = 1; //number of variables to average
float lenH = 1310; //sensor height in mm
float lenW = 660; // distance between sensors in mm

float coordX[n];
float coordY[n];

float timeStartSignal, timeEndSignal; 

float averageCoord_X = 0, averageCoord_Y = 0;
float alfa, cosAlfa; //angle between X axis and receiver
float lenA, lenB, lenC, lenD; //distance between receiver and transmitter 1/2; distance between receiver and beginning/ending of X axis

void setup() {
  Serial.begin (9600);
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
  
  while (digitalRead(echoPinReceiver) == LOW);   timeStartSignal = micros();
  while (digitalRead(echoPinReceiver) == HIGH);  timeEndSignal = micros();
  
  lenA = (timeEndSignal-timeStartSignal) / 2.9; //A in mm

  delay(100);
   
  //measure distance between 2-nd transmitter and receiver
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPinReceiver, HIGH);  digitalWrite(trigPinTransmit2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);

  while (digitalRead(echoPinReceiver) == LOW);   timeStartSignal = micros();
  while (digitalRead(echoPinReceiver) == HIGH);  timeEndSignal = micros();
 
  lenB = (timeEndSignal-timeStartSignal) / 2.9; //B in mm
 
  delay(100);

  //calculate distance between receiver and beginning
  lenC = sqrt(lenA*lenA - lenH*lenH);

  //calculate distance between receiver and ending
  lenD = sqrt(lenB*lenB - lenH*lenH);

  //calculate angle between X axis and receiver
  cosAlfa = (lenW*lenW + lenC*lenC - lenD*lenD)/(2.0*lenC*lenW);
  if (cosAlfa > 1) {
    cosAlfa = 1;
  } else if (cosAlfa < -1) {
    cosAlfa = -1;
  }

  //shift coordinates in array
//  for (int i = n-1; i >= 1; i--){
//    coordX[i] = coordX[i-1];
//    coordY[i] = coordY[i-1];
//  }

  //calculate X and Y coords of receiver
  coordX[0] = lenC*cosAlfa;
  coordY[0] = lenC*sqrt(1.0-cosAlfa*cosAlfa);

  //calcualte average X and Y coords
//  averageCoord_X = 0;
//  averageCoord_Y = 0;
//  for (int i = 0; i < n; i++){
//    averageCoord_X += coordX[i];
//    averageCoord_Y += coordY[i];
//  }
//  averageCoord_X /= n*10;
//  averageCoord_Y /= n*10;

  //Serial.println("X = " + String(averageCoord_X, 3) + " cm");
  //Serial.println("Y = " + String(averageCoord_Y, 3) + " cm");

  //Serial.println("lenA = " + String(lenA));
  //Serial.println("lenB = " + String(lenB));

  //Serial.println("lenC = " + String(lenC));
  //Serial.println("lenD = " + String(lenD));

  //Serial.println("cos(alfa) = " + String(cosAlfa));
  //Serial.println("alfa = " + String(alfa));

  //Serial.println("Coord X = " + String(coordX[0]/10)); 
  //Serial.println("Coord Y = " + String(coordY[0]/10));

//  Serial.println(averageCoord_X, 3);
//  Serial.println(averageCoord_Y, 3);

  Serial.println(coordX[0]/10, 3);
  Serial.println(coordY[0]/10, 3);

  //Serial.println();
}
