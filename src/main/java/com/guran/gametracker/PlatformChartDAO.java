package com.guran.gametracker;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Created by goranpaues on 2017-04-24.
 */
public class PlatformChartDAO  implements ChartDataDAO{
    private final CopyOnWriteArrayList<ChartData> eList = MockPlatformChart.getInstance();

    @Override
    public List<ChartData> getChart(){
        return eList;
    }


}
