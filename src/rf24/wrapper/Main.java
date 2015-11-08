package rf24.wrapper;

import nrf24.engineering.RF24;
import nrf24.engineering.rf24_pa_dbm_e;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
import java.math.BigInteger;

public class Main {
    static {
        System.load("/home/pi/Rf24MeshWrapper/RF24Wrapper/rf24wrapper.so");
    }

    public static void main(String[] args) {
        byte[] node1 = "1Node".getBytes();
        byte[] node2 = "2Node".getBytes();
        boolean radioNumber = false;
        boolean role = true;
        RF24 rf24 = new RF24((short) 2, (short) 24);
        rf24.begin();


                System.out.println("Initialise");
	 rf24.setPALevel((short) rf24_pa_dbm_e.RF24_PA_LOW.swigValue());
        if (radioNumber) {
System.out.println(Arrays.toString(node2));
            rf24.openWritingPipe(node2);
            rf24.openReadingPipe((short) 1,node1 );
        } else {
System.out.println(Arrays.toString(node1));
            rf24.openWritingPipe(node1);
            rf24.openReadingPipe((short) 1, node2);
        }
	rf24.printDetails();
        rf24.startListening();

                System.out.println("Start Listenning: " + rf24.available());
ByteBuffer bb = ByteBuffer.allocate(Integer.SIZE/Byte.SIZE);
bb.order(ByteOrder.LITTLE_ENDIAN);
        while (true) {
			int var = 0 ;
		if(rf24.available()){
			bb.clear();
			    rf24.read(bb.array(),(short) bb.capacity() );
			var = bb.getInt();
			System.out.println( "Got!:" +var);
			rf24.stopListening();
			bb.clear();
			bb.putInt(var);
			boolean ok = rf24.write(bb.array(), (short) bb.capacity());
			if(ok) {
				System.out.println( "Send!: " +var);
			}
			rf24.startListening();
		}

        }

    }
}
