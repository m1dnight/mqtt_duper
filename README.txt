MqttDuper
=========

This is a simple application that subscribes to one mqtt endpoint and pipes it into another endpoint.

It is posssible to filter based on topic using regular expressions. 

Running
-------

Build the application 

    docker build -t mqtt_duper .


Run the application 

    docker run -it --rm                                                                     \
        -v $(pwd)/rel/overlays/mqtt_endpoints.exs:/app/mqtt_duper/mqtt_endpoints.exs        \
        -v /Users/christophe/SynologyDrive/certs/development.loomy.be:/certs/destination    \
        -v /Users/christophe/SynologyDrive/certs/production.loomy.be:/certs/source          \
        mqtt_duper