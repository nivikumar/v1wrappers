#!/bin/sh

# Compile the source files
javac -classpath ./lib/commons-codec-1.6.jar:./lib/commons-logging-1.1.3.jar:./lib/fluent-hc-4.3.1.jar:./lib/httpclient-4.3.1.jar:./lib/httpclient-cache-4.3.1.jar:./lib/httpcore-4.3.jar:./lib/httpmime-4.3.1.jar:./lib/jackson-annotations-2.2.3.jar:./lib/jackson-core-2.2.3.jar:./lib/jackson-databind-2.2.3.jar:./lib/json.org.jar -d ./build/output src/com/verticalresponse/restclient/*.java src/com/verticalresponse/restclient/errorhandler/*.java src/com/verticalresponse/restclient/models/*.java src/com/verticalresponse/restclient/reader/*.java src/com/verticalresponse/restclient/tests/*.java

# Copy the properties file
cp config.properties build/output/.

# Run the TestRestAPI
java -classpath ./lib/commons-codec-1.6.jar:./lib/commons-logging-1.1.3.jar:./lib/fluent-hc-4.3.1.jar:./lib/httpclient-4.3.1.jar:/lib/httpclient-cache-4.3.1.jar:./lib/httpcore-4.3.jar:./lib/httpmime-4.3.1.jar:./lib/jackson-annotations-2.2.3.jar:./lib/jackson-core-2.2.3.jar:./lib/jackson-databind-2.2.3.jar:./lib/json.org.jar:./build/output com.verticalresponse.restclient.tests.TestRestAPI
