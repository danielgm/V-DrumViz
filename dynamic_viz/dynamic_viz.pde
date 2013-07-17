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
  
  long noteAge, t;
  
  // Remove old notes.
  while (data.getRowCount() > 0 && data.getRow(0).getLong("timestamp") - start + 3000 < now - start) {
    data.removeRow(0);
  } 
    
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow r = data.getRow(i);
    
    // Only draw noteOn events.
    if (!r.getString("event").equals("noteOn")) continue;
    
    // Don't draw anything that hasn't happened yet.
    if (r.getLong("timestamp") - start > now - start) break;
    
    noteAge = now - start - (r.getLong("timestamp") - start);
    println(noteAge);
    t = noteAge * noteAge;
    
    noStroke();
    fill(r.getString("event").equals("noteOn") ? map(noteAge, 0, 3000, 255, 0) : 0);
    
    switch (r.getInt("pitch")) {
      case KICK:
        line(width/2 + factor * t, -height/2, width/2 + factor * t, height/2);
        line(width/2 + -factor * t, -height/2, width/2 + -factor * t, height/2);
        break;
        
      case SNARE:
        line(width/2 + noteAge * 0.001, 0, width/2 + noteAge * 0.001, height);
        line(width/2 - noteAge * 0.001, 0, width/2 - noteAge * 0.001, height);
        break;
      
      case HIHAT:
        ellipse(400, 300, initial + factor * t, initial + factor * t);
        break;
      
      case RIDE:
        ellipse(800, 280, initial + factor * t, initial + factor * t);
        break;
      
      default:
        continue;
    }
  }
}

void keyPressed() {
  switch (key) {
    case 'h':
      noteOn(9, HIHAT, floor(random(10, 150)));
      break;
    case 's':
      noteOn(9, SNARE, floor(random(10, 150)));
      break;
    case 'k':
      noteOn(0, KICK, floor(random(10, 150)));
      break;
    default:
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

