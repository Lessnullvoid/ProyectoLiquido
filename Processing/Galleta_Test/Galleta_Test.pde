String DATA_LOCATION = "../../EEGdata";

ArrayList<Session> mSessions;
int cSession = 0;
int cChannel = 0;

void setup() {
  size(700, 700);

  mSessions = new ArrayList<Session>();

  // get all csv and create Sessions
  File dir = new File(sketchPath(DATA_LOCATION));

  for (String file : dir.list()) {
    if (file.endsWith(".csv")) {
      mSessions.add(new Session(DATA_LOCATION+"/"+file));
    }
  }

  mSessions.get(cSession).draw();
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
    mSessions.get(cSession%mSessions.size()).draw(cChannel);
  }
}

void draw() {
}