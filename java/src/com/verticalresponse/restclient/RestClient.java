package com.verticalresponse.restclient;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.verticalresponse.restclient.models.Contact;
import com.verticalresponse.restclient.models.ContactList;

/**
 * A rest client that can have all the top level calls to the VerticalResponse APIs.
 * It also acts as a wrapper around the Apache HttpComponents library responsible for
 * creating and executing the http calls.
 */
public class RestClient {
	// Base API url
	public String baseApiUrl;

	// Access Token needs to be filled in for making the api calls.
	private String accessToken;

	public RestClient() throws Exception {
		// Load the config to set the required properties to make api calls
		Properties prop = new Properties();

		//load a properties file
		prop.load( this.getClass().getClassLoader().getResourceAsStream("config.properties") );

		baseApiUrl = prop.getProperty("base_api_url");
		accessToken = prop.getProperty("access_token");
	}

	/**
	 * Create a new contact list
	 * @param list - A ContactList object
	 * @return A string representation of the JSON result - The list that was created.
	 * @throws Exception
	 */
	public String createContactList(ContactList list) throws Exception {
		RestClientImpl clientService = new RestClientImpl(accessToken);

		String listUrl = baseApiUrl + "/lists";

		// Create a json object with the list properties
		JSONObject listJsonProp = new JSONObject();
		listJsonProp.put("name", list.getName());

		String params = listJsonProp.toString();

		// Create a list
		String jsonResult = clientService.execute(listUrl, IRestClient.POST, params);

		return jsonResult;
	}

	/**
	 * Create a new contact in the list
	 * @param contact - A Contact object
	 * @param listUrl - A fully qualified list url, for eg. http://www.test.com/api/lists/1
	 * @return A string representation of the JSON result - The contact that was created.
	 */
	public String createContact(Contact contact, String listUrl) throws Exception {
		RestClientImpl clientService = new RestClientImpl(accessToken);

		// Create a json object with contact properties
		JSONObject contactJsonProp = new JSONObject();
		contactJsonProp.put("email", contact.getEmail());
		contactJsonProp.put("first_name", contact.getFirstName());

		String listContactUrl = listUrl + "/contacts";
		String params = contactJsonProp.toString();
		String jsonResult = clientService.execute(listContactUrl, IRestClient.POST, params);

		return jsonResult;
	}

	/**
	 * Get all the contacts in a list
	 * @param listUrl - A fully qualified list url, for eg. http://www.test.com/api/lists/1
	 * @return A string representation of the JSON result - The list of contacts in the list.
	 */
	public String getAllContacts(String listUrl) throws Exception {
		RestClientImpl client = new RestClientImpl(accessToken);

		String listContactUrl = listUrl + "/contacts";
		String jsonResult = client.execute(listContactUrl, IRestClient.GET, null);

		return jsonResult;
	}

	/**
	 * Get contact details - defaulted to "all" details.
	 * @param contactUrl - A fully qualified contact url, for eg. http://www.test.com/api/contacts/12
	 * @return A string representation of the JSON result - Attributes of the contact.
	 */
	public String getContact(String contactUrl) throws Exception {
		return this.getContact(contactUrl, IRestClient.ALL);
	}

	 /**
	 * Get contact details according to the passed in type parameter.
	 * @param contactUrl - A fully qualified contact url, for eg. http://www.test.com/api/contacts/12
	 * @param type - BASIC, STANDARD, ALL
	 * @return A string representation of the JSON result - Attributes of the contact based on the passed in type parameter.
	 */
	public String getContact(String contactUrl, String type) throws Exception {
		RestClientImpl clientService = new RestClientImpl(accessToken);

		List<NameValuePair> queryParams = new ArrayList<NameValuePair>();
		queryParams.add(new BasicNameValuePair("type", type));
		String jsonResult = clientService.execute(contactUrl, IRestClient.GET, queryParams);

		return jsonResult;
	}

	/**
	 * Utility method to check for an error json response.
	 * @param jsonString - String representation of the JSON returned from a call.
	 * @return true - has errors, false - does not have any errors.
	 */
	// Check for an error response
	public boolean hasError(String jsonString) {
		try {
			if(jsonString.contains("Gateway Timeout")) {
				return true;
			}
			
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode root = (ObjectNode) mapper.readTree(jsonString);
			if( root.has("error") ) {
				return true;
			}
		} catch(Exception e) {
			System.err.println("Exception occurred when parsing the json: " + e.getMessage());
			return true;
		}

		return false;
	}
}
