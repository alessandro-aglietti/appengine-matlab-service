#!/bin/bash

# rendiamo disponibili tutti i jar in questa cartella

mvn install:install-file -Dfile=javabuilder.jar -DgroupId=com.mathworks -DartifactId=javabuilder -Dversion=0.0.1 -Dpackaging=jar
