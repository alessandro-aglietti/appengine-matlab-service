package it.growbit.matlab.controller;

import com.mathworks.toolbox.javabuilder.*;
import it.growbit.matlab.model.Last24HoursAvg;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.lang.reflect.Method;
import java.util.Map;

/**
 * Created by name on 25/06/17.
 * http://docs.spring.io/spring/docs/5.0.0.BUILD-SNAPSHOT/spring-framework-reference/htmlsingle/#beans-factory-scopes
 */
@Component
@Scope(value = "singleton")
public class MatlabController {

    @PostConstruct
    public void init() {
        if (!MWApplication.isMCRInitialized()) {
            /**
             * https://it.mathworks.com/products/compiler/mcr.html
             */
            MWApplication.initialize(MWMCROption.NODISPLAY, MWMCROption.logFile("/opt/matlab_from_java.log"));
        }
    }

    public boolean isMCRInitialized() {
        return MWApplication.isMCRInitialized();
    }

    public String getEnvs(){
        String envs_str = "";
        Map<String, String> envs = System.getenv();
        for (String key: envs.keySet() ) {
            envs_str += "\n " + key + ": " + envs.get(key);
        }

        return  envs_str;
    }

    public Double generic_invocation(String packageName, String methodName, Last24HoursAvg l24havg) throws Exception {
        this.init();

        Double[] l24havg_arr = new Double[l24havg.getAvgs().size()];
        l24havg_arr = l24havg.getAvgs().toArray(l24havg_arr);

        int[] dims = {l24havg.getAvgs().size(), 1};
        MWNumericArray mw_arr = MWNumericArray.newInstance(dims, l24havg_arr, MWClassID.DOUBLE);

        String className = packageName + ".Class1";
        Class c = Class.forName(className);
        Object matlab_instance = c.newInstance();
        Method method = matlab_instance.getClass().getMethod(methodName, Integer.class, Object[].class);

        Object matlab_out_object = method.invoke(1, mw_arr);
        if (matlab_out_object instanceof Object[]) {
            Object[] matlab_out_object_arr = (Object[]) matlab_out_object;
            if (matlab_out_object_arr.length != 1) {
                throw new Exception("Ci sono piu' output del previsto: " + matlab_out_object_arr.length);
            }
            return ((MWNumericArray) matlab_out_object_arr[0]).getDoubleData()[0];
        } else {
            throw new Exception("matlab_out_object non e' un Object[]");
        }
    }
}
