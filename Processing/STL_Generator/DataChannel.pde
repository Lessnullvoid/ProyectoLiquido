public class DataChannel {
  ArrayList<Float> rawPoints;
  ArrayList<Float> avgPoints;
  ArrayList<Float> lpfPoints;

  int AVG_SIZE = 50;
  float LPF_ALPHA = 0.15;
  int MIN_RADIUS = 50;
  int MAX_RADIUS = 300;

  public DataChannel(Table aTable, int cColumn) {
    int numRows = aTable.getRowCount();
    float minVal = aTable.getFloat(0, cColumn);
    float maxVal = aTable.getFloat(0, cColumn);

    rawPoints = new ArrayList<Float>();
    avgPoints = new ArrayList<Float>();
    lpfPoints = new ArrayList<Float>();

    for (int i=0; i<numRows; i++) {
      float v = aTable.getFloat(i, cColumn);
      rawPoints.add(v);
      if (v<minVal) minVal = v;
      if (v>maxVal) maxVal = v;
    }

    for (int i=0; i<rawPoints.size (); i++) {
      rawPoints.set(i, map(rawPoints.get(i), minVal, maxVal, 0.0, 1.0));
    }

    for (int i=0; i<rawPoints.size ()/AVG_SIZE; i++) {
      float sum = 0;
      for (int j=0; j<AVG_SIZE; j++) {
        sum += rawPoints.get(i*AVG_SIZE+j);
      }
      avgPoints.add(sum/AVG_SIZE);
    }

    lpfPoints.add(avgPoints.get(0));
    for (int i=1; i<avgPoints.size (); i++) {
      float yi_1 = lpfPoints.get(i-1);
      float yi = yi_1 + LPF_ALPHA*(avgPoints.get(i) - yi_1);
      lpfPoints.add(yi);
    }
  }
}

