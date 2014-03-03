The goal of this wrapper is to help you get started with the VR API.
The wrapper provides insights into connecting and making VR API calls.
You can extend this and create your own custom application. The wrapper
does not cover all the API's VR provides.

For a full list of API's VR provides, please refer to the documentation.

This software is provided "as-is", please note that VerticalResponse will
not maintain or update this.

Getting Started:
================

This wrapper has been written using Java 1.6 and needs the following
libraries to run the test Java application.

Apache HttpComponents - http://hc.apache.org
--------------------------------------------
This library has been used to make HTTP calls to an external api server,
in this case, the VR API. It supports all of the HTTP methods (GET,
POST, PUT, DELETE etc) however for this wrapper we have used only the
GET and the POST methods, and it is up to the developer to implement
their own methods based on their needs.

commons-codec-1.6
commons-logging-1.1.3
fluent-hc-4.3.1
httpclient-4.3.1
httpclient-cache-4.3.1
httpcore-4.3
httpmime-4.3.1

Jackson - JSON Processor - http://jackson.codehaus.org
------------------------------------------------------
This library has been used to parse the JSON response from the HTTP
calls. The full power of the processor has not been used in this
wrapper, like automagically creating POJOs, databinding etc. This
processor can be easily replaced with your own choice of processors
available. There is another json library used in this wrapper which is
from http://json.org.  Its an open source, and you can find it in the
form a jar in the lib directory. If you need to make modifications to
the source, you will have to separately download it, make your changes
and update the jar in the lib.

jackson-annotations-2.2.3
jackson-core-2.2.3
jackson-databind-2.2.3
json.org.jar

Config:
-------
Edit the config.properties file and change the client id and access token
before running the application.

The example Java application is provided under the tests directory,
which can make the following api calls:

1. Create a list
2. Create a contact in a list
3. Get a single contact
4. Get all contacts in a list

How to run the test application:
--------------------------------
A shell script (run.sh) is provided with the wrapper that will compile
all the java files and will move it to the build/output directory from
which they will be run.  Before running the shell script, make sure you
modify the config.properties file to have valid client id and access
token values.
