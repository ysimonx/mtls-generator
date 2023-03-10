echo "test" > message.txt

# encrypt file with servpub

openssl rsautl -encrypt -inkey ./certificates/server/serverCrt.pem -pubin -in  message.txt -out message_servpub.enc
