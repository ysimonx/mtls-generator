# mTLS Mutual TLS Authentication Certificates 
(and a PoC with Fastify, and/or Flutter)

by [Yannick Simon](https://yannicksimon.fr)

main script is : https://raw.githubusercontent.com/ysimonx/mtls-ssl-generator/main/generate_certificates.sh

This repository generates self-signed certificates that :

- on server side : verify if a client is allowed to request the API server

- on client side : verify if a server is the good one


How is it possible to provide self-signed certificates for mutual authentication.
With these certicates, you should be able to connect a server and a client and both of them
can verify that they are allowed to connect each other.



> bash ./generate_certificates.sh

<img width="227" alt="Capture d’écran 2023-02-20 à 08 18 43" src="https://user-images.githubusercontent.com/1449867/220038197-0c8a10fb-b3b3-427b-a2d0-9fe01fa0b897.png">

generates CA, Server and Client Keys and PEM Certificates

You can specify multiple DNS hostname or IP adresses for the Server


## Give it a try with an API Rest server

```
npm i fastify

node server.js
```

Provides a fastify nodejs server as an API Rest 


## Test a connection with CURL 

```
bash ./test_curl.sh
```

or

```
curl --cacert ./certificates/ca/caCrt.pem --cert ./certificates/client/clientCrt.pem --key ./certificates/client/clientKey.pem https://localhost:3000/
```

call fastify api rest server, on "localhost", with ca and client certificates 

should returns

> {"hello":"world"}

## Example : mTLS support for a Python/Flask server

see https://github.com/mr-satan1/mTLS-Flask-Template/blob/main/minimal-flask-dev.py


## Example : mTLS request from a Flutter/Dart client

```
void getHttp() async {
  Dio dio = new Dio();

  ByteData clientCertificate = await rootBundle.load("assets/clientCrt.pem");
  ByteData privateKey = await rootBundle.load("assets/clientKey.pem");
  String rootCACertificate = await rootBundle.loadString("assets/caCrt.pem");

  dio.httpClientAdapter = IOHttpClientAdapter()
    ..onHttpClientCreate = (_) {
      final SecurityContext context = SecurityContext(withTrustedRoots: false);

      context.setTrustedCertificatesBytes(utf8.encode(rootCACertificate));
      context.useCertificateChainBytes(clientCertificate.buffer.asUint8List());
      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
      HttpClient httpClient = HttpClient(context: context);

      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) {

        if (cert.pem == rootCACertificate) {
          return true;
        }
        return false;
      };

      return httpClient;
    };

  final response = await dio.get('https://localhost:3000/');
  print(response);
}
```
