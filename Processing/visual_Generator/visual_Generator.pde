String DATA_LOCATION = "../../EEGdata/EEGDATA_ReducFilterIC";
int IMAGE_SIZE = 700;

ArrayList<Session> mSessions;
int cSession = 0;
int cChannel = 0;
int cMode = 0;
float strobeSpeed = 20.5;
float valstrobe1 = 1.5;
float valstrobe2 = 3.5;
float valstrobe3 = 4.5;
float valstrobe4 = 6.5;
float valstrobe5 = 7.5;
float valstrobe6 = 9.5;
float valstrobe7 = 11.5;
float valstrobe8 = 0.0;
int speed = 100;
int speedval1 = 100; 
int speedval2 = 200;
int speedval3 = 300;
int speedval4 = 400;
int speedval5 = 500;
int speedval6 = 600;
int speedval7 = 700;


void setup() {
  size(1200, 720);
  frameRate(120);

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
  }
}

void keyPressed() {
  //stobe
  if (key == 'a') {
    strobeSpeed = valstrobe1;
  }
  if (key == 's') {
    strobeSpeed = valstrobe2;
  }
  if (key =='d') {
    strobeSpeed = valstrobe3;
  }
  if (key == 'f') {
    strobeSpeed = valstrobe4;
  }
  if (key == 'g') {
    strobeSpeed = valstrobe5;
  }
  if (key == 'h') {
    strobeSpeed = valstrobe6;
  }
  if (key == 'j') {
    strobeSpeed = valstrobe7;
  }
  if (key == 'k') {
    strobeSpeed = valstrobe7;
  }
  
  // speed
  if (key == 'q') {
    speed = speedval1;
  }
    if (key == 'w') {
    speed = speedval2;
  }
    if (key == 'e') {
    speed = speedval3;
  }
    if (key == 'r') {
    speed = speedval4;
  }
    if (key == 't') {
    speed = speedval5;
  }
    if (key == 'y') {
    speed = speedval6;
  }
    if (key == 'u') {
    speed = speedval7;
  }
}



void draw() {
  if (cMode == 0) {
    background(0);
    if (frameCount%strobeSpeed==0)background(255);
    pushMatrix();
    translate(width/2, height/2);
    rotate(millis() * TWO_PI/speed);
    translate(-width/2, -height/2);
    translate((width-IMAGE_SIZE)/2, 0);
    mSessions.get(cSession%mSessions.size()).draw(cChannel);
    popMatrix();
 
  }
}
