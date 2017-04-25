package com.guran.gametracker;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Created by goranpaues on 2017-04-24.
 */
public class MockPlatformChart {
    private static final CopyOnWriteArrayList<ChartData> eList = new CopyOnWriteArrayList<>();

    static {

        String jsonString = "[{\"label\":\"PS3\",\"value\":\"442\"},{\"label\":\"iPad\",\"value\":\"57\"},{\"label\":\"PC\",\"value\":\"449\"}]";

        try {

            ObjectMapper mapper = new ObjectMapper();

            ChartData[] myPlatformChart = mapper.readValue(jsonString, ChartData[].class);

            eList.addAll(Arrays.asList(myPlatformChart));

        } catch (IOException exception) {
            System.out.println("Error: " + exception.getMessage());
        }

    }

    private MockPlatformChart(){}

    public static CopyOnWriteArrayList getInstance(){
        return eList;
    }

}
