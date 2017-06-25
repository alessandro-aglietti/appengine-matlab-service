package it.growbit.matlab.controller;

import com.mathworks.toolbox.javabuilder.*;
import criptoOracleValori.Class1;
import it.growbit.matlab.model.Last24HoursAvg;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * Created by name on 25/06/17.
 * http://docs.spring.io/spring/docs/5.0.0.BUILD-SNAPSHOT/spring-framework-reference/htmlsingle/#beans-factory-scopes
 */
@Component
@Scope(value = "singleton")
public class MatlabController {

    private Class1 criptoOracle = null;

    @PostConstruct
    public void init() {
        if (!MWApplication.isMCRInitialized()) {
            /**
             * https://it.mathworks.com/products/compiler/mcr.html
             */
            MWApplication.initialize(MWMCROption.NODISPLAY, MWMCROption.logFile("/opt/matlab_from_java.log"));
        }
    }

    public void init_oracle() {
        this.init_oracle(false);
    }

    public void init_oracle(boolean force) {
        this.init();
        if (this.criptoOracle == null || force) {
            try {
                this.criptoOracle = new Class1();
            } catch (MWException e) {
                System.err.println("MWException on new Class1 " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    public boolean isMCRInitialized() {
        return MWApplication.isMCRInitialized();
    }

    public Double criptoOracleValori(Last24HoursAvg l24havg) throws MWException {
        this.init_oracle();

        Double[] l24havg_arr = new Double[24];
        l24havg_arr = l24havg.getAvgs().toArray(l24havg_arr);

        int[] dims = { 24, 1 };
        MWNumericArray mw_arr = MWNumericArray.newInstance(dims, l24havg_arr, MWClassID.DOUBLE);

        Object[] forecast_outs = this.criptoOracle.criptoOracleValori(1, mw_arr);

        /**
         * Each of these data types is in the form of a matrix or array.
         * https://it.mathworks.com/help/mps/java/data-conversion-with-java-and-matlab-types.html
         */
        return ((MWNumericArray) forecast_outs[1]).getDouble(0);
    }

    public Double superCriptoOracleTrend(Last24HoursAvg l24havg) throws MWException {
        this.init_oracle();

        Double[] l24havg_arr = new Double[24];
        l24havg_arr = l24havg.getAvgs().toArray(l24havg_arr);

        int[] dims = { 24, 1 };
        MWNumericArray mw_arr = MWNumericArray.newInstance(dims, l24havg_arr, MWClassID.DOUBLE);

        /**
         * Each of these data types is in the form of a matrix or array.
         * https://it.mathworks.com/help/mps/java/data-conversion-with-java-and-matlab-types.html
         */
        Object[] forecast_outs = this.criptoOracle.superCriptoOracleTrend(1, mw_arr);

        return ((MWNumericArray) forecast_outs[1]).getDouble(0);
    }
}
