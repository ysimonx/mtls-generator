
# let's create a small file.txt
echo "message content text" > file.txt 

cp ../certificates/server/serverCrt.pem ./serverCrt.pem
cp ../certificates/server/serverKey.pem ./serverKey.pem

# encrypt file.txt with server certificate
openssl rsautl -encrypt -certin -inkey serverCrt.pem -in file.txt -out file.bin
base64 -i file.bin -o file.bin.uue

# decrypt file.txt with server private key
base64 -i file.bin.uue --decode -o file_dest.bin
openssl rsautl -decrypt -inkey serverKey.pem -in file_dest.bin -out file_dest.txt

