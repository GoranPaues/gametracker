package com.guran.gametracker;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by goranpaues on 2017-04-24.
 */
@CrossOrigin
@RestController
@RequestMapping("/lastyear")
public class LastYearChartController {

    ChartDataDbDAO dbdao = new ChartDataDbDAO();

    // Get platform list
    @RequestMapping(method = RequestMethod.GET)
    public ChartData[] getAll() {
        return dbdao.getLastYearChart().toArray(new ChartData[0]);

    }
}