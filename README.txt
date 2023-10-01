MqttDuper
=========

This is a simple application that subscribes to one mqtt endpoint and pipes it into another endpoint.

It is posssible to filter based on topic using regular expressions. 

Running
-------

Build the application 

    docker build -t mqtt_duper .


Run the application 

    docker run -it --rm                                     \
        -e MQTT_SOURCE_HOST=mqtt.production.loomy.be        \
        -e MQTT_DESTINATION_HOST=mqtt.development.loomy.be  \
        -v $(pwd)/certs:/app/certs                          \
        mqtt_duper