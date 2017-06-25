package it.growbit.matlab.model;

import java.util.List;

/**
 * Created by name on 24/06/17.
 */
public class Last24HoursAvg {
    private List<Double> avgs;

    public Last24HoursAvg() {

    }

    public Last24HoursAvg(List<Double> avgs) {
        this.avgs = avgs;
    }

    public List<Double> getAvgs() {
        return avgs;
    }

    public void setAvgs(List<Double> avgs) {
        this.avgs = avgs;
    }
}
