/**
 * Rest client interface.
 */

package com.verticalresponse.restclient;

public interface IRestClient {
	public static final int GET = 1;
	public static final int POST = 2;
	public static final int PUT = 3;
	public static final int DELETE = 0;

	public static final String BASIC = "basic";
	public static final String STANDARD = "standard";
	public static final String ALL = "all";

	public String execute(String resource, int method, Object params) throws Exception;
}
