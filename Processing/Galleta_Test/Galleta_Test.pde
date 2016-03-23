String DATA_LOCATION = "../../EEGdata";

ArrayList<Session> mSessions;
int cSession = 0;
int cChannel = 0;

int mode = 1;

void setup() {
  size(1050, 700);

  mSessions = new ArrayList<Session>();

  // get all csv and create Sessions
  File dir = new File(sketchPath(DATA_LOCATION));

  for (String file : dir.list()) {
    if (file.endsWith(".csv")) {
      mSessions.add(new Session(DATA_LOCATION+"/"+file));
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      cSession = cSession + 1;
      cChannel = 0;
    } else if (keyCode == DOWN) {
      cSession = cSession - 1;
      if (cSession<0) cSession += mSessions.size();
      cChannel = 0;
    } else if (keyCode == RIGHT) {
      cChannel = cChannel+1;
    } else if (keyCode == LEFT) {
      cChannel = cChannel-1;
    }
  }
}

void draw() {
  if (mode == 0) {
    background(0);
    translate((width-700)/2, 0);
    mSessions.get(cSession%mSessions.size()).draw(cChannel);
  } else if (mode == 1) {
    scale(0.5);
    pushMatrix();
    translate(0, 0);
    mSessions.get(cSession%mSessions.size()).draw(1);
    translate(700, 0);
    mSessions.get(cSession%mSessions.size()).draw(2);
    translate(700, 0);
    mSessions.get(cSession%mSessions.size()).draw(3);
    popMatrix();
    translate(0, 700);
    mSessions.get(cSession%mSessions.size()).draw(4);
    translate(700, 0);
    mSessions.get(cSession%mSessions.size()).draw(5);
    translate(700, 0);
    mSessions.get(cSession%mSessions.size()).draw(6);
  } else if (mode == 2) {
    // draw all images of current channel
  }
}