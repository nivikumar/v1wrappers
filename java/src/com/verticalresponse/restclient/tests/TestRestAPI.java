package com.verticalresponse.restclient.tests;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.verticalresponse.restclient.IRestClient;
import com.verticalresponse.restclient.RestClient;
import com.verticalresponse.restclient.errorhandler.ErrorHandler;
import com.verticalresponse.restclient.models.Contact;
import com.verticalresponse.restclient.models.ContactList;

/**
 * Test to demonstrate how to call the VR API.
 */
public class TestRestAPI {

	public static void main(String args[]) {
		try {
			RestClient apiClient = new RestClient();
			long timeInSeconds = System.currentTimeMillis() / 1000L;
			
			/*
			 * Create a new list
			 */
			ContactList list = new ContactList();
			list.setName("List - " + timeInSeconds);
			String jsonResult = apiClient.createContactList(list);
			if( apiClient.hasError( jsonResult )) {
				System.err.println("Create New List - Error JSON:\n" + jsonResult);
				return;
			}
			System.out.println("\nNew Contact List:\n" + jsonResult);
			
			/*
			 * Create a contact in list
			 */
			Contact c = new Contact();
			c.setEmail("l" + timeInSeconds + "c1@list" + timeInSeconds + ".com");
			c.setFirstName("C1");
			
			// Read the url from the create list call result
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode root = (ObjectNode) mapper.readTree(jsonResult);
			
			String listUrl = root.path("url").asText();
			
			// Now create the contact in the list
			jsonResult = apiClient.createContact(c, listUrl);
			
			if( apiClient.hasError( jsonResult )) {
				System.err.println("Create Contact in List - Error JSON:\n" + jsonResult);
				return;
			}
			System.out.println("\nNew Contact as JSON:\n" + jsonResult);
			
			/*
			 * Get all the contacts from the given list
			 */
			jsonResult = apiClient.getAllContacts(listUrl);
			System.out.println("\nList of Contacts as JSON:\n" + jsonResult);
			
			/*
			 * Read single/multiple contacts traversing the list of contacts returned
			 * from the previous call.
			 */
			root = (ObjectNode) mapper.readTree(jsonResult);
			
			if( root.has("items") ) {
				JsonNode itemsNode = root.get("items");
				if( itemsNode.isArray() ) {
					for( final JsonNode item : itemsNode ) {
						String contactUrl = item.path("url").asText();
						// Get the first contact details in a list
						
						// Basic version
						jsonResult = apiClient.getContact(contactUrl, IRestClient.BASIC);
						System.out.println("\nContact Details (BASIC):\n" + jsonResult);
						
						// Standard Version
						jsonResult = apiClient.getContact(contactUrl, IRestClient.STANDARD);
						System.out.println("\nContact Details (STANDARD):\n" + jsonResult);
						
						// All Version - Default
						jsonResult = apiClient.getContact(contactUrl);
						System.out.println("\nContact Details (ALL):\n" + jsonResult);
						break;
					}
				}
			}

			/*
			 * Error handling: Create a list with invalid params
			 */
			ContactList badList = new ContactList();
			badList.setName("");
			jsonResult = apiClient.createContactList(badList);
			if( apiClient.hasError( jsonResult )) {
				System.err.println("\nCreate New List with Invalid Params - Error JSON:\n" + jsonResult);
			}
		} catch(Exception e) {
			System.out.println("Exception occurred: " + ErrorHandler.getStackTrace(e));
		}
	}
}
