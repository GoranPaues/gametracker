package com.guran.gametracker;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * Created by goranpaues on 2017-04-24.
 */
public class LastYearChartDAO {

        private final CopyOnWriteArrayList eList = MockLastYearChart.getInstance();

        public List<ChartData> getChart(){
            return eList;
        }


}
