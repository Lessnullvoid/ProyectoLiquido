public class Session {
  ArrayList<DataChannel> mChannels;

  public Session(String file) {
    mChannels = new ArrayList<DataChannel>();

    Table mTable = loadTable(file, "header");

    for (int i=0; i<mTable.getColumnCount (); i++) {
      mChannels.add(new DataChannel(mTable, i));
    }
  }
}

