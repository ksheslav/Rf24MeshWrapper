package rf24.wrapper;

/**
 * Created by mohereq on 02.11.15.
 */
public class RF24Mesh {
    private final RF24 mRf24;
    private final RF24Network mRf24Network;

    public RF24Mesh(RF24 rf24, RF24Network rf24Network) {
        this.mRf24 = rf24;
        this.mRf24Network = rf24Network;
    }



    private native boolean begin(char channel, int dataRate, long timeout);

    private native char update();

    private native boolean write(int toNode, byte[] data, char msgType, int size);

    private native boolean write(byte[] data, char msgType, int size, int nodeId);

    private native void setChannel(char channel);

    private native boolean checkConnection();

    private native String getAddress(int nodeId);

    private native int getNodeId(String address);

    private native boolean releaseAddress();

    private native String renewAddress(long timeout);

    private native boolean requestAddress(byte level);

    private native boolean waitForAvailable(long timeout);

    private native void setNodeId(int nodeId);

    private native void setStaticAddress(char nodeId, String address);

    private native void loadDHCP();

    private native void saveDHCP();

    private native void DHCP();
}
