import themidibus.*;
import java.util.Date;

final int SNARE = 38;
final int RIM = 37;
final int HIHAT = 46;
final int HIHATFOOT = 44;
final int HIHATFOOTPRESS = 4;
final int KICK = 36;
final int CRASH = 49;
final int CRASH_EDGE = 55;
final int RIDE = 51;
final int TOM1 = 48;
final int TOM2 = 45;
final int TOM3 = 43;

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
  background(0);
  
  long now = (new Date()).getTime();
  float initial = 50, factor = 0.0001;
  
  int cx, cy;
  long noteAge, t;
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow r = data.getRow(i);
    
    // Don't draw anything too old.
    if (r.getLong("timestamp") - start + 3000 < now - start) continue;
    
    // Don't draw anything that hasn't happened yet.
    if (r.getLong("timestamp") - start > now - start) break;
    
    noteAge = now - start - (r.getLong("timestamp") - start);
    t = noteAge * noteAge;
    
    switch (r.getInt("pitch")) {
      case SNARE:
        cx = 420;
        cy = 320;
        break;
      
      case HIHAT:
        cx = 400;
        cy = 300;
        break;
      
      case RIDE:
        cx = 800;
        cy = 280;
        break;
      
      default:
        continue;
    }
    
    fill(r.getString("event").equals("noteOn") ? map(noteAge, 0, 3000, 255, 0) : 0);
    ellipse(cx, cy, initial + factor * t, initial + factor * t);
  }
}

void noteOn(int channel, int pitch, int velocity) {  
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
  long now = (new Date()).getTime();
  
  TableRow r = data.addRow();
  r.setLong("timestamp", now);
  r.setString("event", "noteOff");
  r.setInt("channel", channel);
  r.setInt("pitch", pitch);
  r.setInt("velocity", velocity);
}

