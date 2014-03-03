package com.verticalresponse.restclient.reader;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;

/**
 * Reads the contents from the HttpResponse object. 
 */
public class JSONResponseReader implements IResponseReader {
	
	public String read(HttpResponse response) throws Exception {
		HttpEntity entity = response.getEntity();
		InputStream inputStream = entity.getContent();
		
		return readInputStream( inputStream );
	}
	
	private String readInputStream(InputStream in) throws IOException {
		StringBuilder sb = new StringBuilder();
		BufferedReader r = new BufferedReader(new InputStreamReader(in), 1000);
		for (String line = r.readLine(); line != null; line = r.readLine()) {
			sb.append(line);
		}
	   
		in.close();
		
		return sb.toString();
	}

}
