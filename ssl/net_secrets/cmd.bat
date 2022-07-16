openssl req -nodes -new -x509 -keyout ca-root.key -out ca-root.crt -days 365 -subj '/CN=blackhawk/OU=IT/O=IT/L=PUNE/S=MAH/C=IN' -passin pass:123456 -passout pass:123456
openssl req -newkey rsa:2048 -nodes -keyout blackhawk_client.key -out blackhawk_client.csr -subj '/CN=blackhawk/OU=TEST/O=IT/L=PUNE/S=MAH/C=IN' -passin pass:123456 -passout pass:123456
openssl x509 -req -CA ca-root.crt -CAkey ca-root.key -in blackhawk_client.csr -out blackhawk_client.crt -days 365 -CAcreateserial

keytool -keystore server.truststore.jks -alias CARoot -import -file ca-root.crt -storepass 123456 -keypass 123456
keytool -keystore server.keystore.jks -alias blackhawk -validity 365 -genkey -keyalg RSA -dname "blackhawk, OU=IT, O=IT, L=PUNElto, S=MAH, C=IN"
