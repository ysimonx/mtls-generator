# MTLS Mutual Authentication Certificates - (and a PoC with Fastify)

How is it possible to provide self-signed certificates for your fastify API for mutual authentication
With these certicates, you should be able to connect a server and a client and both of them
can verify that they are allowed to connect each other.


> bash ./generate_certificates.sh

generates CA, Server and Client certificates



> npm i fastify
> node server.js

provide a fastify node js 



> bash ./test_curl.sh

call fastify api rest server, on "localhost", with ca and client certificates 

should returns

> {"hello":"world"}
