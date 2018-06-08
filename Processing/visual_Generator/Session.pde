public class Session {
  ArrayList<DataChannel> mChannels;

  public Session(String file) {
    mChannels = new ArrayList<DataChannel>();

    Table mTable = loadTable(file, "header");
    String name = file.substring(file.lastIndexOf("/")+1);

    for (int i=0; i<mTable.getColumnCount(); i++) {
      mChannels.add(new DataChannel(mTable, i, name));
    }
  }

  public void draw(int channel) {
    while (channel < 0) channel += mChannels.size();
    channel = channel%mChannels.size();

    mChannels.get(channel).draw();
  }

  public void draw() {
    this.draw(0);
  }
}
