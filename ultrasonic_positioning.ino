int trigPinReceiver = 9;      
int echoPinReceiver = 8;      
int trigPinTransmit1 = 2;   
int trigPinTransmit2 = 3;  

int i;
float lenA = 94;    //sensor height in cm
float lenG = 152;    // distance between sensors in cm

float coord_X,  coord_Y;
float coord_X1, coord_Y1;
float coord_X2, coord_Y2;
float coord_X3, coord_Y3;
float coord_X4, coord_Y4;
float coord_X5, coord_Y5;

float oldCoord_X = 0, oldCoord_Y = 0;
float averageCoord_X, averageCoord_Y;
float measurementError;
float alfa;
float timeStartSignal, timeEndSignal;
float lenC, lenE, lenB, lenD;

void setup() {
  Serial.begin (115200);
  pinMode(trigPinReceiver, OUTPUT);
  pinMode(echoPinReceiver, INPUT);
  pinMode(trigPinTransmit1, OUTPUT);
  pinMode(trigPinTransmit2, OUTPUT);
}

void loop() {
  averageCoord_X = 0;
  averageCoord_Y = 0;
  
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit1, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPinReceiver, HIGH);  digitalWrite(trigPinTransmit1, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit1, LOW);
  
  lenC = pulseIn(echoPinReceiver, HIGH) / 58 * 2; //C in cm
  delay(100);
  //Serial.println("lenC = " + String(lenC));
 
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPinReceiver, HIGH);  digitalWrite(trigPinTransmit2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinReceiver, LOW);  digitalWrite(trigPinTransmit2, LOW);
  
  lenE = pulseIn(echoPinReceiver, HIGH) / 58 * 2; //E in cm
  delay(100);
  //Serial.println("lenE = " + String(lenE));
  
  lenB = sqrt(lenC*lenC - lenA*lenA);
  measurementError = 26.437 - 0.08*lenB/10;
  lenB = (lenB + measurementError*10)/10.00;

  lenD = sqrt(lenE*lenE - lenA*lenA);
  measurementError = 26.437 - 0.08*lenD/10;
  lenD = (lenD + measurementError*10)/10.00;
  
  alfa = acos(((lenG*lenG + lenD*lenD - lenB*lenB)*1.00)/((2*lenE*lenG)*1.00));
  //alfa = acos((lenG*lenG - lenD*lenD + lenB*lenB)/(2*lenB*lenG));
  Serial.println("alfa = " + String(alfa));
  //coord_X = lenB*cos(alfa);
  //coord_Y = lenB*cos(1.57-alfa);
  coord_X = lenE*cos(1.57-alfa);
  coord_Y = lenE*cos(alfa);
  //Serial.println("Coord X = " + String(coord_X)); 
  //Serial.println("Coord Y = " + String(coord_Y)); 
  Serial.println("cos(alfa) = " + String((alfa))); 
  Serial.println("cos(1.57 - alfa) = " + String((1.57 - alfa))); 

    
//  if((coord_X > 0) && (coord_X < 500) && (coord_Y > 0) && (coord_Y < 500))
//  {
//    oldCoord_X = coord_X;
//    oldCoord_Y = coord_Y;
//  }else{  
//    coord_X = oldCoord_X;
//    coord_Y = oldCoord_Y;
//  }
//  
  coord_X5 = coord_X4;
  coord_X4 = coord_X3;
  coord_X3 = coord_X2;
  coord_X2 = coord_X1;
  coord_X1 = coord_X;
  
  coord_Y5 = coord_Y4;
  coord_Y4 = coord_Y3;
  coord_Y3 = coord_Y2;
  coord_Y2 = coord_Y1;
  coord_Y1 = coord_Y;
  
  averageCoord_X = (coord_X + coord_X1 + coord_X2 + coord_X3 + coord_X4 + coord_X5)/6;
  averageCoord_Y = (coord_Y + coord_Y1 + coord_Y2 + coord_Y3 + coord_Y4 + coord_Y5)/6;

 // Serial.println("Coord X = " + String(averageCoord_X));
 // Serial.println("Coord Y = " + String(averageCoord_Y));
}

float asin(float c)
{
  float out;
  out = ((c+(pow(c,3))/6+(3*pow(c,5))/40+(5*pow(c,7))/112 +(35*pow(c,9))/1152 +(0.022*pow(c,11))+(0.0173*pow(c,13))+(0.0139*pow(c,15)) + (0.0115*pow(c,17))+(0.01*pow(c,19))));
  
  if(c >= .96 && c < .97)   {    out=1.287+(3.82*(c-.96));    }
  if(c>=.97 && c<.98)       {    out=(1.325+4.5*(c-.97));     }
  if(c>=.98 && c<.99)       {    out=(1.37+6*(c-.98));        }
  if(c>=.99 && c<=1)        {    out=(1.43+14*(c-.99));       }
  
  return out;
}



float acos(float c)
{
  float out;
  out=asin(sqrt(1-c*c));
  return out;
}

float atan(float c)
{
  float out;
  out=asin(c/(sqrt(1+c*c)));
  return out;
}
