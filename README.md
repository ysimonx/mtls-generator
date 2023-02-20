# mTLS Mutual TLS/SSL Authentication Certificates 
(and a PoC with Fastify)

How is it possible to provide self-signed certificates for your fastify API for mutual authentication
With these certicates, you should be able to connect a server and a client and both of them
can verify that they are allowed to connect each other.


> bash ./generate_certificates.sh

<img width="227" alt="Capture d’écran 2023-02-20 à 08 18 43" src="https://user-images.githubusercontent.com/1449867/220038197-0c8a10fb-b3b3-427b-a2d0-9fe01fa0b897.png">

generates CA, Server and Client Keys and PEM Certificates


# Give it a try with an API Rest server

> npm i fastify

> node server.js

provide a fastify node js 


# Test a connection with CURL 

> bash ./test_curl.sh

call fastify api rest server, on "localhost", with ca and client certificates 

should returns

> {"hello":"world"}
