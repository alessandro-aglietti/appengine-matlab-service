package it.growbit.matlab.controller;

import com.mathworks.toolbox.javabuilder.MWApplication;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWMCROption;
import criptoOracleValori.Class1;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * Created by name on 25/06/17.
 */
@Component
public class MatlabController {

    /**
     * TODO singleton
     */
    private Class1 criptoOracle = null;

    @PostConstruct
    public void init() {
        if (!MWApplication.isMCRInitialized()) {
            MWApplication.initialize(MWMCROption.NODISPLAY, MWMCROption.logFile("/opt/matlab_from_java.log"));
        }
    }

    public void init_oracle() {
        this.init_oracle(false);
    }

    public void init_oracle(boolean force) {
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
}
