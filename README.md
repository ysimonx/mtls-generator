# mTLS Mutual TLS/SSL Authentication Certificates 
(and a PoC with Fastify)

With this repository, with self-signed certificates you can :

- on server side : verify if a client is allowed to request the API server

- on client side : verify if a server is the good one


How is it possible to provide self-signed certificates for your fastify API for mutual authentication
With these certicates, you should be able to connect a server and a client and both of them
can verify that they are allowed to connect each other.



> bash ./generate_certificates.sh

<img width="227" alt="Capture d’écran 2023-02-20 à 08 18 43" src="https://user-images.githubusercontent.com/1449867/220038197-0c8a10fb-b3b3-427b-a2d0-9fe01fa0b897.png">

generates CA, Server and Client Keys and PEM Certificates


## Give it a try with an API Rest server

> npm i fastify

> node server.js

provide a fastify node js 


## Test a connection with CURL 

> bash ./test_curl.sh

or

> curl --cacert ./certificates/ca/caCrt.pem --cert ./certificates/client/clientCrt.pem --key ./certificates/client/clientKey.pem https://localhost:3000/

call fastify api rest server, on "localhost", with ca and client certificates 

should returns

> {"hello":"world"}


## Test a connection with Flutter

'''

void getHttp() async {
  Dio dio = new Dio();

  ByteData clientCertificate = await rootBundle.load("assets/clientCrt.pem");
  ByteData privateKey = await rootBundle.load("assets/clientKey.pem");
  String rootCACertificate = await rootBundle.loadString("assets/caCrt.pem");

  dio.httpClientAdapter = IOHttpClientAdapter()
    ..onHttpClientCreate = (_) {
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      final SecurityContext context = SecurityContext(withTrustedRoots: false);

      context.setTrustedCertificatesBytes(utf8.encode(rootCACertificate));

      context.useCertificateChainBytes(clientCertificate.buffer.asUint8List());

      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
      HttpClient httpClient = HttpClient(context: context);

      /*
            cf  https://pub.dev/packages/dio

            There are two ways to verify the root of the https certificate chain provided by the server. Suppose the certificate format is PEM, the code like:
            ...
            return cert.pem == PEM; // Verify the certificate.
    ... */

      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print(host);
        print(port);
        print(cert.pem);
        print(rootCACertificate);
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
'''
