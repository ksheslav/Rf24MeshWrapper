package rf24.wrapper;

import nrf24.engineering.RF24;
import nrf24.engineering.rf24_pa_dbm_e;

import java.util.Arrays;

public class Main {
    static {
        System.load("/home/mohereq/IdeaProjects/RF24MeshWrapper/src/rf24/wrapper/rf24wrapper.so");
    }

    public static void main(String[] args) {
        byte[] node1 = "1Node".getBytes();
        byte[] node2 = "2Node".getBytes();
        boolean radioNumber = true;
        boolean role = true;
        RF24 rf24 = new RF24((short) 22, (short) 21);
        rf24.begin();

        rf24.setPALevel((short) rf24_pa_dbm_e.RF24_PA_LOW.swigValue());

        if (radioNumber) {
            rf24.openWritingPipe(node2);
            rf24.openReadingPipe((short) 1, node2);
        } else {
            rf24.openWritingPipe(node1);
            rf24.openReadingPipe((short) 2, node1);
        }

        rf24.startListening();

        while (true) {
            byte[] wat = new byte[64];
            if (rf24.available()) {
                while (rf24.available()) {
                    rf24.read(wat, (short) 64);
                }
                rf24.stopListening();
                rf24.write(wat, (short) 64);
                rf24.startListening();
                System.out.println("response");
                System.out.println(Arrays.toString(wat));
            }
        }

    }
}
