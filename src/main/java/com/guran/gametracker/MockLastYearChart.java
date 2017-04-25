package com.guran.gametracker;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Created by goranpaues on 2017-04-24.
 */
public class MockLastYearChart {
    private static final CopyOnWriteArrayList eList = new CopyOnWriteArrayList<>();

    static {

        String jsonString = "[{\"label\":\"201604\",\"value\":\"30\"},{\"label\":\"201605\",\"value\":\"5\"},{\"label\":\"201606\",\"value\":\"12\"},{\"label\":\"201607\",\"value\":\"4\"},{\"label\":201608,\"value\":\"9\"},{\"label\":\"201609\",\"value\":\"6\"},{\"label\":\"201610\",\"value\":\"14\"},{\"label\":\"201611\",\"value\":\"12\"},{\"label\":\"201612\",\"value\":\"6\"},{\"label\":\"201701\",\"value\":\"8\"},{\"label\":\"201702\",\"value\":\"7\"},{\"label\":\"201703\",\"value\":\"26\"},{\"label\":\"201704\",\"value\":\"1\"}]";

        try {

            ObjectMapper mapper = new ObjectMapper();

            ChartData[] myLastYearChart = mapper.readValue(jsonString, ChartData[].class);

            eList.addAll(Arrays.asList(myLastYearChart));

        } catch (JsonParseException exception) {
            System.out.println("Error: " + exception.getMessage());
        } catch (JsonMappingException exception) {
            System.out.println("Error: " + exception.getMessage());
        } catch (IOException exception) {
            System.out.println("Error: " + exception.getMessage());
        }

    }

    private MockLastYearChart(){}

    public static CopyOnWriteArrayList getInstance(){
        return eList;
    }

}
