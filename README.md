coleman-docker-softether
==================

Usage
-----

To run the image and bind to port:

        docker run -d -p 443:443/tcp \
                      -p 992:992/tcp \
                      -p 1194:1194/tcp \
                      -p 1194:1194/udp \
                      -p 5555:5555/tcp \
                      -p 500:500/udp \
                      -p 4500:4500/udp \
                      colemandlut/softether

