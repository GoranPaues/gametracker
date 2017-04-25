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
@RequestMapping("/platform")
public class PlatformChartController {

    PlatformChartDAO pdao = new PlatformChartDAO();

    // Get platform list
    @RequestMapping(method = RequestMethod.GET)
    public ChartData[] getAll() {
        return pdao.getChart().toArray(new ChartData[0]);

    }
}