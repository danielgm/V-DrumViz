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

long start;

Table data;
long dataStart;

void setup() {
  size(1280, 720);
  background(0);

  data = loadTable("data03.csv", "header");
  
  println(data.getRowCount() + " total rows in table");

  dataStart = data.getRow(0).getLong("timestamp");
  
  start = (new Date()).getTime();
}

void draw() {
  background(0);
  
  long now = (new Date()).getTime();
  float factor = 0.0001;
  
  int cx, cy;
  long noteAge, t;
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow r = data.getRow(i);
    
    // Don't draw anything too old.
    if (r.getLong("timestamp") - dataStart + 3 * 1000 < now - start) continue;
    
    // Don't draw anything that hasn't happened yet.
    if (r.getLong("timestamp") - dataStart > now - start) break;
    
    noteAge = now - start - (r.getLong("timestamp") - dataStart);
    t = noteAge * noteAge;
    
    switch (r.getInt("pitch")) {
      case SNARE:
        cx = 500;
        cy = 360;
        break;
      
      case HIHAT:
        cx = 400;
        cy = 280;
        break;
      
      case RIDE:
        cx = 800;
        cy = 280;
        break;
      
      default:
        continue;
    }
    
    fill(r.getString("event").equals("noteOn") ? map(noteAge, 0, 3000, 255, 0) : 0);
    ellipse(cx, cy, factor * t, factor * t);
  }
}
