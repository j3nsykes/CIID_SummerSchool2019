import netP5.*;
import processing.serial.*;
import oscP5.*;

OscP5 oscP5;
NetAddress dest;

Serial myPort;
int input = 0;
float [] scaled=new float [3];
float[] inputs = new float [3];

void setup() {
  size(400, 400);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.bufferUntil('\n');

  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
}

void draw() {
  background(0); 
  //map the incoming data
  for (int i = 0; i<inputs.length; i++) {
    scaled[i]=inputs[i];
  }
  //visualise the data
  noStroke();
  fill(255);
  textSize(32);
  text("PITCH or X: "+inputs[0], 20, 100);
  text("ROLL or Y: "+inputs[1], 20, 150);
  text("YAW or Z: "+inputs[2], 20, 200);
  
  if (frameCount % 2 == 0) {
    sendOsc();
  }
}

void serialEvent(Serial thisPort) {
  String inputString = thisPort.readStringUntil('\n');
  inputString = trim(inputString);

  // split the input string at the commas
  // and convert the sections into floats:
  inputs = float(split(inputString, ','));

  println(inputs);
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i<inputs.length; i++) {
    msg.add(inputs[i]);
  }
  oscP5.send(msg, dest);
}
