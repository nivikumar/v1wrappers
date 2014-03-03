package com.verticalresponse.restclient.reader;

import org.apache.http.HttpResponse;

/*
 * Dummy class implementation.
 * Substitute your own xml parsing based on the http response content type.
 */
public class XMLResponseReader implements IResponseReader {

	public String read(HttpResponse response) {
		return null;
	}

}
