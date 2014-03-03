package com.verticalresponse.restclient.reader;

import org.apache.http.HttpResponse;

public interface IResponseReader {

	public String read(HttpResponse response) throws Exception;

}
