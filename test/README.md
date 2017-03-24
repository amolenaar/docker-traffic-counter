# Testing the traffic counter


To test the traffic counter, run the docker-compose setup. Make sure the prometheus config is okay: the IP address of the traffic counter should be configured correctly in `prometheus.yml`.

One everything is running, you can access Prometheus at:

    http://localhost:9090

Check if the traffic counter is actually scraped at

    http://localhost:9090/targets

Next, create a small graph, such as `increase(service_request_count[1m])`.
