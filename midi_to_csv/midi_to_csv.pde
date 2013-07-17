import themidibus.*;
import java.util.Date;

int SNARE = 38;
int RIM = 37;
int HIHAT = 46;
int HIHATFOOT = 44;
int HIHATFOOTPRESS = 4;
int KICK = 36;
int CRASH = 49;
int CRASH_EDGE = 55;
int RIDE = 51;
int TOM1 = 48;
int TOM2 = 45;
int TOM3 = 43;

MidiBus mb;

long start;

Table data;

void setup() {
  size(1280, 720);
  background(0);

  //MidiBus.list();
  mb = new MidiBus(this, 0, -1);
  
  data = new Table();
  data.addColumn("timestamp");
  data.addColumn("event");
  data.addColumn("channel");
  data.addColumn("pitch");
  data.addColumn("velocity");
  
  start = (new Date()).getTime();
}

void draw() {
}

void noteOn(int channel, int pitch, int velocity) {
  println("Note On:"+channel+","+pitch+","+velocity);
  
  long now = (new Date()).getTime();
  
  fill(255, 255, 255);
  rect(map(now - start, 0, 30 * 1000, 0, width), (pitch - 35) * 10, 2, 10);
  
  TableRow r = data.addRow();
  r.setLong("timestamp", now);
  r.setString("event", "noteOn");
  r.setInt("channel", channel);
  r.setInt("pitch", pitch);
  r.setInt("velocity", velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  println("Note Off:"+channel+","+pitch+","+velocity);
  
  long now = (new Date()).getTime();
  
  TableRow r = data.addRow();
  r.setLong("timestamp", now);
  r.setString("event", "noteOff");
  r.setInt("channel", channel);
  r.setInt("pitch", pitch);
  r.setInt("velocity", velocity);
}

void controllerChange(int channel, int number, int value) {
  println("Controller Change:"+channel+","+number+","+value);
}

void keyPressed() {
  if (key == ' ') {
    println("Saving data/data.csv");
    saveTable(data, "data/data.csv");
    
    // Reset.
    start = (new Date()).getTime();
    background(0);
  }
}


