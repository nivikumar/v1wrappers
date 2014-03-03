package com.verticalresponse.restclient.errorhandler;

import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Utility class to handle the exceptions.
 */
public class ErrorHandler {
	/**
     * Returns a StringBuffer containing the stacktrace of a throwable.
     * @param e the throwable
     * @return stacktrace
     */
    public static StringBuffer getStackTrace(Throwable e) {
        StringWriter stacktrace = new StringWriter();
        PrintWriter printstacktrace = new PrintWriter(stacktrace);
        e.printStackTrace(printstacktrace);
        return stacktrace.getBuffer();
    }
}
