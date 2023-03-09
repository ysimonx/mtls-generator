
echo "content" > file.txt

cp ../certificates/client/clientCrt.pem ./clientCrt.pem
cp ../certificates/client/clientKey.pem ./clientKey.pem

openssl dgst -sha256 -sign clientKey.pem -out file.sha256  file.txt
# note that "openssl dgst -sha256"  = "shasum -a 256 file.txt"

openssl base64 -in file.sha256 -out file.sig
echo "signature is file.sig"
cat file.sig

sleep 2
# decrypt

# verify signature 
openssl base64 -d -in file.sig -out file.sha256_retour
echo
echo "is signature ok ?"

openssl x509 -pubkey -noout -in clientCrt.pem > clientPubKey.pem # https://stackoverflow.com/a/2387569
openssl dgst -sha256 -verify clientPubKey.pem -signature file.sha256_retour file.txt
