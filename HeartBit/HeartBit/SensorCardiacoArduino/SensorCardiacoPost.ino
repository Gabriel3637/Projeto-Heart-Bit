#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>


#define SENSOR_PIN A0

WiFiClient client;
HTTPClient httpClient;

const char *WIFI_SSID = "HackaTruckIoT";
const char *WIFI_PASSWORD = "iothacka";
const char *URL = "http://192.168.128.8:1880/postdelbatimentosteste";


unsigned long lastBeat = 0;
int beatCount = 0;
float bpm = 0;
bool pulseDetected = false;
float bpms[10];
unsigned long ultima =0;

int cont = 0;

void setup() {
  Serial.begin(9600);
  pinMode(SENSOR_PIN, INPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("Connected");
    delay(2000);
    for(int j=0;j<10;j++){
      bpms[j] = 0.1;
    }
}

void loop() {
  int signal = analogRead(SENSOR_PIN);  //Lê 0 - 1023

  // batimento
  if (signal > 550 && !pulseDetected) {
    pulseDetected = true;
    unsigned long currentTime = millis();
    unsigned long timeBetweenBeats = currentTime - lastBeat;

    if (timeBetweenBeats > 300) {
      bpm = 60000.0 / timeBetweenBeats;
      lastBeat = currentTime;

      Serial.print("BPM: ");
      Serial.println(bpm);
      bpms[cont++] = bpm;  
      ultima = millis();
    }
  }

  if (signal < 500) {
    pulseDetected = false; // Redefine para o próximo batimento
  }

  if(cont>9){
    float soma=0;
    for(int i=0;i<10;i++){
      soma = soma + bpms[i];
      bpms[i] = 0.0;
    }
    soma = soma/cont;
    Serial.print("Media = ");
    Serial.println(soma);
    
    String data = "batimento="+String(soma);

    httpClient.begin(client, URL);
    httpClient.addHeader("Content-Type", "application/x-www-form-urlencoded");
    httpClient.POST(data);
    String content = httpClient.getString();
    httpClient.end();

    //Serial.print(output_value); 
    Serial.print("\n resposta");   
    Serial.println(content);

    cont = 0;
  }

  delay(100); 
}