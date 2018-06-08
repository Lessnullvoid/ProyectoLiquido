public class DataChannel {
  ArrayList<Float> rawPoints;
  ArrayList<Float> avgPoints;
  ArrayList<Float> maxPoints;
  ArrayList<Float> lpfPoints;
  int AVG_SIZE = 50;
  float LPF_ALPHA = 0.25;

  String channelName;
  String sessionName;

  PGraphics mDrawing = null;

  int MIN_RADIUS = 50;
  int MAX_RADIUS = IMAGE_SIZE/2-MIN_RADIUS;
  int TEXT_SIZE = 24;

  public DataChannel(Table aTable, int cColumn, String sname) {
    int numRows = aTable.getRowCount();
    float minVal = aTable.getFloat(0, cColumn);
    float maxVal = aTable.getFloat(0, cColumn);

    rawPoints = new ArrayList<Float>();
    avgPoints = new ArrayList<Float>();
    maxPoints = new ArrayList<Float>();
    lpfPoints = new ArrayList<Float>();

    channelName = aTable.getColumnTitle(cColumn);
    sessionName = sname;

    for (int i=0; i<numRows; i++) {
      float v = aTable.getFloat(i, cColumn);
      rawPoints.add(v);
      if (v<minVal) minVal = v;
      if (v>maxVal) maxVal = v;
    }

    for (int i=0; i<rawPoints.size(); i++) {
      rawPoints.set(i, map(rawPoints.get(i), minVal, maxVal, 0.0, 1.0));
    }

    for (int i=0; i<rawPoints.size()/AVG_SIZE; i++) {
      float sum = 0;
      float max = 0;
      for (int j=0; j<AVG_SIZE; j++) {
        sum += rawPoints.get(i*AVG_SIZE+j);
        if(rawPoints.get(i*AVG_SIZE+j) > max) max = rawPoints.get(i*AVG_SIZE+j);
      }
      avgPoints.add(sum/AVG_SIZE);
      maxPoints.add(max);
    }

    lpfPoints.add(avgPoints.get(0));
    for (int i=1; i<avgPoints.size(); i++) {
      float yi_1 = lpfPoints.get(i-1);
      lpfPoints.add(yi_1 + LPF_ALPHA*(avgPoints.get(i) - yi_1));
    }
  }

  private void createDrawing() {
    mDrawing = createGraphics(IMAGE_SIZE, IMAGE_SIZE);
    mDrawing.beginDraw();

    
    mDrawing.clear();
    mDrawing.stroke(0);
    mDrawing.noFill();
    mDrawing.translate(width/2, height/2);
    mDrawing.endDraw();

    mDrawing.stroke(255);
    drawPoints(rawPoints);

    drawPoints(avgPoints);
    mDrawing.strokeWeight(4);
    drawPoints(lpfPoints);
    mDrawing.strokeWeight(1);
  }

  private void drawPoints(ArrayList<Float> points) {
    float angleStep = TWO_PI/points.size();
    float cAngle = 0*angleStep;
    float cRadius = MIN_RADIUS+points.get(0)*MAX_RADIUS;
    PVector lastPoint = new PVector(cRadius*cos(cAngle), cRadius*sin(cAngle));

    mDrawing.beginDraw();

    mDrawing.pushMatrix();
    {
      mDrawing.translate(IMAGE_SIZE/2, IMAGE_SIZE/2);
      for (int i=0; i<points.size(); i++) {
        cAngle = i*angleStep;
        cRadius = MIN_RADIUS+points.get(i)*MAX_RADIUS;
        mDrawing.line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
        lastPoint.set(cRadius*cos(cAngle), cRadius*sin(cAngle));
      }
      cAngle = 0*angleStep;
      cRadius = MIN_RADIUS+points.get(0)*MAX_RADIUS;
      mDrawing.line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
    }
    mDrawing.popMatrix();
    mDrawing.endDraw();
  }

  public void draw() {
    if (mDrawing == null) this.createDrawing();
    image(mDrawing, 0, 0);
  }
}
