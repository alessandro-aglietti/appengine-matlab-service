package it.growbit.matlab.controller;

import com.mathworks.toolbox.javabuilder.MWApplication;
import com.mathworks.toolbox.javabuilder.MWMCROption;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * Created by name on 25/06/17.
 */
@Component
public class MatlabController {
    @PostConstruct
    public void init() {
        if (!MWApplication.isMCRInitialized()) {
            MWApplication.initialize(MWMCROption.NODISPLAY, MWMCROption.logFile("/opt/matlab_from_java.log"));
        }
    }

    public boolean isMCRInitialized() {
        return MWApplication.isMCRInitialized();
    }
}
