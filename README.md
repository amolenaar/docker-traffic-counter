# Docker Traffic Counter

Docker Traffic Counter is a neat little app that counts requests made between
services on a micro service platform.

## The idea

Once you have a platform with many nice, small micro-services you begin to
wonder how they relate to one another. Do they talk to each other? Are
the talked to at all? What does my application topology look like
*for real*? This service is supposed to answer those questions. By
monitoring requests going from service to service we can figure out how
data flows.

This service is build on top of some assumptions:

1. All services communicate with each other via a proxy. This proxy (usually
   HAProxy or Nginx) is routing traffic based on the `Host` header defined in
   the request.
   
2. Data is exported via Prometheus. The handling of Prometheus is plugged into
   the system, so it should be easy to replace with other exporters.

The Traffic Counter will do some degree of packet inspection in order to
figure out what the target host is. All non-HTTP packets (or packets without
a host header for that matter) are not taken into account. This tool will
therefore  not tell you how much traffic is going over the wire. It will
however provide you with some insights in which services talk to each other
and how often they do that.

To get anything useful, run this container on the host network:

    docker run -ti -v /var/run/docker.sock:/var/run/docker.sock --net=host -p 9100:9100 amolenaar/traffic-counter

## Building

This is an [Elixir](http://elixir-lang.org) project. To build it, you'll need
to have Elixir 1.4.2 or newer installed.

To build the application for release in a container:

    mix docker.build
    
To make the actual runtime container:

    mix docker.release

Note to self: do not forget to publish: 

    mix docker.publish


Suggestions, improvements are welcome!

Have fun,

Arjan
