public class DataChannel {
  ArrayList<Float> rawPoints;
  ArrayList<Float> avgPoints;
  ArrayList<Float> maxPoints;
  int AVG_SIZE = 50;

  String channelName;
  String sessionName;

  PGraphics mDrawing = null;

  int MIN_RADIUS = 50;
  int MAX_RADIUS = IMAGE_SIZE/2-MIN_RADIUS;
  int TEXT_SIZE = 24;

  public DataChannel(Table aTable, int cColumn, String sname) {
    int numRows = aTable.getRowCount();
    int minVal = aTable.getInt(0, cColumn);
    int maxVal = aTable.getInt(0, cColumn);

    rawPoints = new ArrayList<Float>();
    avgPoints = new ArrayList<Float>();
    maxPoints = new ArrayList<Float>();

    channelName = aTable.getColumnTitle(cColumn);
    sessionName = sname;

    for (int i=0; i<numRows; i++) {
      int v = aTable.getInt(i, cColumn);
      rawPoints.add(float(v));
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
  }

  private void createDrawing() {
    mDrawing = createGraphics(IMAGE_SIZE, IMAGE_SIZE);
    mDrawing.beginDraw();

    mDrawing.background(0);
    mDrawing.stroke(255);
    mDrawing.noFill();
    mDrawing.textSize(TEXT_SIZE);
    mDrawing.text(sessionName, TEXT_SIZE, TEXT_SIZE);
    mDrawing.text(channelName, IMAGE_SIZE-textWidth(channelName)-TEXT_SIZE, TEXT_SIZE);
    mDrawing.endDraw();

    mDrawing.beginDraw();
    mDrawing.stroke(255);
    mDrawing.endDraw();
    drawPoints(rawPoints);

    mDrawing.beginDraw();
    mDrawing.stroke(255,0,0);
    mDrawing.endDraw();
    drawPoints(avgPoints);

    mDrawing.beginDraw();
    mDrawing.stroke(0,255,0);
    mDrawing.endDraw();
    drawPoints(maxPoints);
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
      mDrawing.ellipse(0, 0, MIN_RADIUS*2, MIN_RADIUS*2);
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