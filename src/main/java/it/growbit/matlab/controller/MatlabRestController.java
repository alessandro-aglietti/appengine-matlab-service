package it.growbit.matlab.controller;

import it.growbit.matlab.model.Last24HoursAvg;
import it.growbit.matlab.model.Next24HourAvg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by name on 24/06/17.
 */
@RestController
public class MatlabRestController {

    @Autowired
    MatlabController matlab;

    @RequestMapping(value = "/_ah/health", method = RequestMethod.GET)
    public String healthcheck() {
        return "ok";
    }

    @RequestMapping(value = "/matlab", method = RequestMethod.GET)
    public String matlab() {
        return "isMCRInitialized: " + this.matlab.isMCRInitialized();
    }

    @RequestMapping(value = "/matlab", method = RequestMethod.POST)
    public Next24HourAvg matlab(@RequestBody Last24HoursAvg last24houravgs) {

        Next24HourAvg next24houravg = new Next24HourAvg(this.doForecast(last24houravgs));

        return next24houravg;
    }

    private Double doForecast(Last24HoursAvg last24HoursAvg) {
        return 0d;
    }
}