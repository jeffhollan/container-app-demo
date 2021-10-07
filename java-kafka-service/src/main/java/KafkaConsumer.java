package main.java;

//Copyright (c) Microsoft Corporation. All rights reserved.
//Licensed under the MIT License.
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class KafkaConsumer {
    //Change constant to send messages to the desired topic
    private final static String TOPIC = "kafka-event-hub";
    
    private final static int NUM_THREADS = 1;

    public static void main(String... args) throws Exception {

        final ExecutorService executorService = Executors.newFixedThreadPool(NUM_THREADS);

        for (int i = 0; i < NUM_THREADS; i++){
            executorService.execute(new KafkaConsumerThread(TOPIC));
        }
    }
}