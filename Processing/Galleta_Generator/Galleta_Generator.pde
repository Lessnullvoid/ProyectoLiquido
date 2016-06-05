String DATA_LOCATION = "../../EEGdata/EEGDATA_ReducFilterIC";
int IMAGE_SIZE = 700;

ArrayList<Session> mSessions;
int cSession = 0;
int cChannel = 0;
int cMode = 0;

void setup() {
  size(1050, 700);

  mSessions = new ArrayList<Session>();

  // get all csv and create Sessions
  File dir = new File(sketchPath(DATA_LOCATION));

  for (String file : dir.list()) {
    if (file.endsWith("ICA.csv")) {
      mSessions.add(new Session(DATA_LOCATION+"/"+file));
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      cSession = cSession + 1;
    } else if (keyCode == DOWN) {
      cSession = cSession - 1;
      if (cSession<0) cSession += mSessions.size();
    } else if (keyCode == RIGHT) {
      cChannel = cChannel+1;
    } else if (keyCode == LEFT) {
      cChannel = cChannel-1;
    }
  } else if (key == ' ') {
    cMode = (cMode+1)%3;
  }
}

void draw() {
  if (cMode == 0) {
    background(0);
    translate((width-IMAGE_SIZE)/2, 0);
    mSessions.get(cSession%mSessions.size()).draw(cChannel);
  } else if (cMode == 1) {
    scale(0.5);
    for (int i=0; i<6; i++) {
      pushMatrix();
      translate((i%3)*IMAGE_SIZE, (i/3)*IMAGE_SIZE);
      mSessions.get(cSession%mSessions.size()).draw(i+1);
      popMatrix();
    }
  } else if (cMode == 2) {
    scale(0.5);
    for (int i=0; i<6; i++) {
      pushMatrix();
      translate((i%3)*IMAGE_SIZE, (i/3)*IMAGE_SIZE);
      mSessions.get((cSession+i)%mSessions.size()).draw(cChannel);
      popMatrix();
    }
  }
}

