public class Session {
  ArrayList<DataChannel> mChannels;
  String name;

  int TEXT_SIZE = 24;

  public Session(String file) {
    mChannels = new ArrayList<DataChannel>();

    Table mTable = loadTable(file, "header");
    name = file.substring(file.lastIndexOf("/")+1);

    for (int i=0; i<mTable.getColumnCount(); i++) {
      mChannels.add(new DataChannel(mTable, i));
    }
  }

  public void draw(int channel) {
    while (channel < 0) channel += mChannels.size();
    channel = channel%mChannels.size();

    mChannels.get(channel).draw();
    text(name, TEXT_SIZE, TEXT_SIZE);
  }

  public void draw() {
    this.draw(0);
  }
}