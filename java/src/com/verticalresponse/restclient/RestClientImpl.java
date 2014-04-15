package com.verticalresponse.restclient;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.JSONObject;

import com.verticalresponse.restclient.errorhandler.ErrorHandler;
import com.verticalresponse.restclient.reader.IResponseReader;
import com.verticalresponse.restclient.reader.JSONResponseReader;
import com.verticalresponse.restclient.reader.XMLResponseReader;

/**
 * This class is responsible for creating http request using the Apache Components Library.
 * Creates request based on the method type (GET, POST, PUT, DELETE).
 * Handles the response by delegating to the respective readers.
 */
public class RestClientImpl implements IRestClient {
	private String accessToken;
	private HttpResponse response = null;

	/*
	 * Constructor
	 */
	public RestClientImpl(String accessToken) {
		this.accessToken = accessToken;
	}

	/**
	 * Method that creates a closeable http client.  Creates a http request.  Adds header information
	 * to the request and executes the request and handles the returned response.
	 * @param url - A fully qualified api url
	 * @param method - A method to create the request - GET, POST, PUT, DELETE
	 * @param params - Can be a json string for POST or a NameValuePair for GET requests.
	 * @return A string representation of JSON.
	 */
	@Override
	public String execute(String url, int method, Object params) throws Exception {
		/*
		 * 1. Create a HttpClient
		 * 2. Create a request object based on the passed in method (GET, POST, PUT, DELETE etc.)
		 * 3. Add the necessary headers to the request object
		 * 4. Execute the request
		 * 5. Parse the response
		 * 6. Close the HttpClient connection
		 */

		// Add the access token as part of the URL
		url = url + "?access_token=" + this.accessToken;
		
		// Configure the Connection Timeout
		RequestConfig requestConfig = RequestConfig.custom()
				.setSocketTimeout( 5000 )
				.setConnectTimeout( 5000 )
				.setConnectionRequestTimeout( 5000 )
				.setStaleConnectionCheckEnabled( true )
				.build();
					
		CloseableHttpClient httpClient = HttpClients.custom().setDefaultRequestConfig( requestConfig ).build();
		
		// Now get the request object
		HttpRequestBase httpRequest = getHttpRequest( url, method, params );
		
		// Now add the necessary headers
		httpRequest = this.addHeaders( httpRequest, this.buildRequestHeader() );

		// Execute the request
		this.response = httpClient.execute( httpRequest );
		
		return this.handleResponse();
	}
	
	/**
	 * Handles a http response object.
	 * Based on the response content (JSON or XML) the respective reader is invoked,
	 * that will retrieve the JSON or XML result.
	 * Currently reads only JSON output.
	 * @return
	 * @throws Exception
	 */
	private String handleResponse() throws Exception {
		ContentType contentType = ContentType.getOrDefault( this.response.getEntity() );
		String mimeType = contentType.getMimeType();
		
		IResponseReader responseReader = null;
		
		if( mimeType.equalsIgnoreCase("application/json") ) {
			responseReader = new JSONResponseReader();
		} else if( mimeType.equalsIgnoreCase("application/xml") ) {
			responseReader = new XMLResponseReader();
		} else {
			responseReader = new JSONResponseReader();
		}
		
		if( responseReader != null ) {
			return responseReader.read( this.response );
		} else {
			throw new Exception( "No reader found for response content." );
		}
	}

	/**
	 * Gets the http request object.
	 * Based on the passed in method, creates the necessary request object (HttpGet / HttpPost).
	 * @param requestUrl - A fully qualified api url.
	 * @param method - GET, POST, PUT, DELETE
	 * @param params - JSON string for post request, List of NameValue pairs for get request.
	 * @return - Returns a HttpRequestBase which is the base class for HttpGet and HttpPost
	 * @throws Exception
	 */
	private HttpRequestBase getHttpRequest(String requestUrl, int method, Object params) throws Exception {
		URI uri = null;
		try {
			uri = this.createUri( requestUrl );
		} catch (URISyntaxException e) {
			throw new IllegalStateException("Problem when building URI: " + requestUrl, e);
		} catch (NullPointerException e) {
			throw new IllegalStateException("Building URI with null string", e);
		}
		
		HttpRequestBase httpRequest = null;
		switch( method ) {
		  	case IRestClient.GET:
		  		httpRequest = (HttpRequestBase) this.createHttpGet(uri, (List<NameValuePair>) params);
		  		break;
		  	case IRestClient.POST:
		  		httpRequest = (HttpRequestBase) this.createHttpPost(uri, (String) params);
		  		break;
		  	case IRestClient.PUT:
		  		// Implementation left out intentionally.
		  		// Create a put request
		  		break;
		  	case IRestClient.DELETE:
		  		// Implementation left out intentionally.
		  		// Create a delete request
		  		break;
		  	default:
		  		httpRequest = new HttpGet();
		  		break;
		}
		
		return httpRequest;
	}

	/**
	 * Creates a HttpGet object. Sets the request parameters if available.
	 * @param uri - A valid URI object
	 * @param params - A list of NameValuePairs
	 * @return HttpGet
	 * @throws Exception
	 */
	private HttpGet createHttpGet(URI uri, List<NameValuePair> params) throws Exception {
		HttpGet httpGetRequest = new HttpGet();

		if(params != null) {
			URIBuilder uriBuilder = new URIBuilder(uri);
			uriBuilder.addParameters(params);
			uri = URI.create( uriBuilder.toString() );
		}

		httpGetRequest.setURI(uri);

		return httpGetRequest;
	}

	/**
	 * Creates a HttpPost object. Sets the request parameters if available.
	 * @param uri - A valid URI object
	 * @param params - A json string that contains the post parameters
	 * @return HttpPost
	 * @throws Exception
	 */
	private HttpPost createHttpPost(URI uri, String params) throws Exception {
		HttpPost httpPostRequest = new HttpPost();
		
		if( params != null) {
			StringEntity entity = new StringEntity(params);
			httpPostRequest.setEntity(entity);
		}
		
		httpPostRequest.setURI(uri);

		return httpPostRequest;
	}

	/**
	 * Add the header information to the request
	 * @param request - A request object (HttpGet or HttpPost)
	 * @param headers - A map of http headers
	 * @return - Updated HttpRequestBase with headers
	 */
	private HttpRequestBase addHeaders(HttpRequestBase request, HashMap<String, String> headers) {
    for (Entry<String, String> entry : headers.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
        request.addHeader(key, value);
    }

    return request;
  }

	/**
	 * Creates a HashMap of http headers to be used for the api call.
	 * @return - HashMap
	 */
	private HashMap<String, String> buildRequestHeader() {
		HashMap<String, String> headers = new HashMap<String, String>();
		headers.put( "Accept", "application/json" );
		headers.put( "Content-Type", "application/json" );
		headers.put( "Charset", "UTF-8" );
	
	    return headers;
	}

	/**
	 * Creates a URI.
	 * @param uri - A fully qualified uri.
	 * @return
	 * @throws URISyntaxException
	 */
	private URI createUri(String uri) throws URISyntaxException {
		return new URI( uri );
	}

}
