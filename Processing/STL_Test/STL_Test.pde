import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;

String DATA_LOCATION = "../../EEGdata/EEGDATA_ReducFilterIC";
String FILENAME = "Contesina_RF_ICA.csv";

int MIN_RADIUS = 35;
int MAX_RADIUS = MIN_RADIUS*2;
int MAX_HEIGHT = 150;
int MAX_THICKNESS = 3;
int PLUG_DIMENSION = 10;

UGeo model;
UNav3D nav;

Session mSession;

void setup() {
  size(600, 600, OPENGL);

  // initialize ModelbuilderMk2 and add navigation
  UMB.setPApplet(this);
  nav=new UNav3D();

  mSession = new Session(DATA_LOCATION+"/"+FILENAME);

  build();
}

void build() {
  // create randomized mesh form from a stack of edges
  ArrayList<UVertexList> stack = new ArrayList<UVertexList>();

  int dataLayers = mSession.mChannels.size();

  // levels
  for (int i=1; i<dataLayers; i++) {
    UVertexList tmp = new UVertexList();
    UVertexList tmp2 = new UVertexList();

    ArrayList<Float> thisChannel = mSession.mChannels.get(i).lpfPoints;

    // re-normalize channel
    float minVal = thisChannel.get(0);
    float maxVal = thisChannel.get(0);

    for (int j=0; j<thisChannel.size (); j++) {
      float yj = thisChannel.get(j);
      if (yj < minVal) minVal = yj;
      if (yj > maxVal) maxVal = yj;
    }
    for (int j=0; j<thisChannel.size (); j++) {
      thisChannel.set(j, map(thisChannel.get(j), minVal, maxVal, 0.0, 1.0));
    }

    float angleStep = TWO_PI/thisChannel.size();

    // points per level
    for (int j=0; j<thisChannel.size (); j++) {
      float cAngle = j*angleStep;
      float cRadius = MIN_RADIUS+thisChannel.get(j)*(MAX_RADIUS-MIN_RADIUS);
      UVertex uv = new UVertex(cRadius, 0).rotY(cAngle);
      tmp.add(uv);
      tmp2.add(uv);
    }

    tmp.translate(0, map(i*2+0, 2, 2*dataLayers-1, 0, MAX_HEIGHT));
    stack.add(tmp.close());
    tmp2.translate(0, map(i*2+1, 2, 2*dataLayers-1, 0, MAX_HEIGHT));
    stack.add(tmp2.close());
  }

  // smooth the data layers
  stack = UVertexList.smooth(stack, 1);

  // add a bottom manually, made up of a quadstrip instead of triangle fan
  UVertexList tmp = new UVertexList();
  float numPoints = mSession.mChannels.get(0).lpfPoints.size();
  float angleStep = TWO_PI/numPoints;
  // points per level
  for (int j=0; j<numPoints; j++) {
    float cAngle = j*angleStep;
    float cRadius = 0.01*MIN_RADIUS;
    tmp.add(new UVertex(cRadius, 0).rotY(cAngle));
  }
  tmp.translate(0, MAX_HEIGHT);
  stack.add(tmp.close());

  // add UGeo created from quadstrips of the stacked edges 
  //model = new UGeo().quadstrip(UVertexList.smooth(stack, 1));
  model = new UGeo().quadstrip(stack);

  // give outer surface a thickness
  model.extrudeSelf(MAX_THICKNESS, true);

  // put plugs in the bottom
  float cubeCenterY = stack.get(stack.size()-1).get(0).y+PLUG_DIMENSION*0.5-2f;
  model.add(UGeo.box(PLUG_DIMENSION).translate(0,cubeCenterY,0));
  model.add(UGeo.box(PLUG_DIMENSION).translate(2*PLUG_DIMENSION,cubeCenterY,0));
  model.add(UGeo.box(PLUG_DIMENSION).translate(-2*PLUG_DIMENSION,cubeCenterY,0));

  //write STL
  model.writeSTL(sketchPath(FILENAME.replace(".csv", ".stl")));
}

void draw() {
  background(0);

  translate(width/2, height/2);
  nav.doTransforms();
  lights();

  stroke(255);
  fill(255);
  model.draw();
}

