public class DataChannel {
  ArrayList<Float> mDataPoints;
  String name;

  int MIN_RADIUS = 10;  // in pixels
  int MAX_RADIUS = 340; // in pixels
  int TEXT_SIZE = 24;

  public DataChannel(Table aTable, int cColumn) {
    int numRows = aTable.getRowCount();
    int minVal = aTable.getInt(0, cColumn);
    int maxVal = minVal;

    mDataPoints = new ArrayList<Float>();
    name = aTable.getColumnTitle(cColumn);

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

  public void draw() {
    background(0);
    stroke(255);
    noFill();
    textSize(TEXT_SIZE);

    float angleStep = TWO_PI/mDataPoints.size();
    float cAngle = 0*angleStep;
    float cRadius = MIN_RADIUS+mDataPoints.get(0)*MAX_RADIUS;
    PVector lastPoint = new PVector(cRadius*cos(cAngle), cRadius*sin(cAngle));

    pushMatrix();
    {
      translate(width/2, height/2);
      ellipse(0, 0, MIN_RADIUS, MIN_RADIUS);
      for (int i=0; i<mDataPoints.size(); i++) {
        cAngle = i*angleStep;
        cRadius = MIN_RADIUS+mDataPoints.get(i)*MAX_RADIUS;
        line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
        lastPoint.set(cRadius*cos(cAngle), cRadius*sin(cAngle));
      }
      cAngle = 0*angleStep;
      cRadius = MIN_RADIUS+mDataPoints.get(0)*MAX_RADIUS;
      line(lastPoint.x, lastPoint.y, cRadius*cos(cAngle), cRadius*sin(cAngle));
    }
    popMatrix();

    text(name, width-textWidth(name)-TEXT_SIZE, TEXT_SIZE);
  }
}