import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;

String DATA_LOCATION = "../../EEGdata/EEGDATA_ReducFilterIC";
String FILENAME = "Contesina_RF_ICA.csv";

int MIN_RADIUS = 35;
int MAX_RADIUS = 70;
int MAX_HEIGHT = 150;

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
  ArrayList<UVertexList> stack=new ArrayList<UVertexList>();

  int dataLayers = mSession.mChannels.size();

  // levels
  for (int i=1; i<dataLayers; i++) {
    UVertexList tmp=new UVertexList();
    UVertexList tmp2=new UVertexList();

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
      float cRadius = MIN_RADIUS+thisChannel.get(j)*MAX_RADIUS;
      UVertex uv = new UVertex(cRadius, 0).rotY(cAngle);
      tmp.add(uv);
      tmp2.add(uv);
    }

    tmp.translate(0, map(i*2+0, 2, 2*dataLayers-1, 0, MAX_HEIGHT));
    stack.add(tmp.close());
    tmp2.translate(0, map(i*2+1, 2, 2*dataLayers-1, 0, MAX_HEIGHT));
    stack.add(tmp2.close());
  }

  // center stacked edges as a single entity  
  UVertexList.center(stack);

  // add UGeo created from quadstrips of the stacked edges 
  //model = new UGeo().quadstrip(stack);
  model = new UGeo().quadstrip(UVertexList.smooth(stack, 1));

  // give outer surface a thickness
  //model.extrudeSelf(10, true);
  // or close it on top and bottom
  // TODO: this

  //model.writeSTL(sketchPath(FILENAME.replace(".csv", ".stl")));
}

void draw() {
  background(0);

  translate(width/2, height/2);
  nav.doTransforms();
  lights();

  stroke(255);
  fill(255);
  model.draw();

  // draw face normals in red
  stroke(255, 0, 0);
  //model.drawNormals(50);
}

