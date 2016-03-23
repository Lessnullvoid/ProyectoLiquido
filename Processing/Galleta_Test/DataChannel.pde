public class DataChannel {
  ArrayList<Float> mDataPoints;
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

    mDataPoints = new ArrayList<Float>();
    channelName = aTable.getColumnTitle(cColumn);
    sessionName = sname;

    for (int i=0; i<numRows; i++) {
      int v = aTable.getInt(i, cColumn);
      mDataPoints.add(float(v));
      if (v<minVal) minVal = v;
      if (v>maxVal) maxVal = v;
    }

    for (int i=0; i<mDataPoints.size(); i++) {
      mDataPoints.set(i, map(mDataPoints.get(i), minVal, maxVal, 0.0, 1.0));
    }
  }

  private void createDrawing() {
    mDrawing = createGraphics(IMAGE_SIZE, IMAGE_SIZE);
    mDrawing.beginDraw();

    mDrawing.background(0);
    mDrawing.stroke(255);
    mDrawing.noFill();
    mDrawing.textSize(TEXT_SIZE);

    float angleStep = TWO_PI/mDataPoints.size();
    float cAngle = 0*angleStep;
    float cRadius = MIN_RADIUS+mDataPoints.get(0)*MAX_RADIUS;
    PVector lastPoint = new PVector(cRadius*cos(cAngle), cRadius*sin(cAngle));

    mDrawing.pushMatrix();
    {
      mDrawing.translate(IMAGE_SIZE/2, IMAGE_SIZE/2);
      mDrawing.ellipse(0, 0, MIN_RADIUS*2, MIN_RADIUS*2);
      for (int i=0; i<mDataPoints.size(); i++) {
        cAngle = i*angleStep;
        cRadius = MIN_RADIUS+mDataPoints.get(i)*MAX_RADIUS;
        mDrawing.line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
        lastPoint.set(cRadius*cos(cAngle), cRadius*sin(cAngle));
      }
      cAngle = 0*angleStep;
      cRadius = MIN_RADIUS+mDataPoints.get(0)*MAX_RADIUS;
      mDrawing.line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
    }
    mDrawing.popMatrix();

    mDrawing.text(sessionName, TEXT_SIZE, TEXT_SIZE);
    mDrawing.text(channelName, IMAGE_SIZE-textWidth(channelName)-TEXT_SIZE, TEXT_SIZE);

    mDrawing.endDraw();
  }

  public void draw() {
    if (mDrawing == null) this.createDrawing();
    image(mDrawing, 0, 0);
  }
}