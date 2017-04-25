package com.guran.gametracker;

/**
 * Created by goranpaues on 2017-04-23.
 */
public class ChartData {
    private String label;
    private String value;

    public ChartData() {
        super();
        this.label = "";
        this.value = "";
    }

    public ChartData(String label, String value) {
        this.label = label;
        this.value = value;
    }

    @Override
    public String toString() {
        return String.format(
                "ChartData[label='%s', value=%s]",
                label, value);
    }

    public String getLabel() {
        return this.label;
    }

    public String getValue() {
        return this.value;
    }
}
