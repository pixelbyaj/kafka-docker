::Generate CA key
openssl req -new -x509 -keyout ca-root.key -out ca-root.crt -days 365 -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US' -passin pass:confluent -passout pass:confluent

::Kafkacat
openssl genrsa -des3 -passout "pass:confluent" -out kafkacat.client.key 1024
openssl req -passin "pass:confluent" -passout "pass:confluent" -key kafkacat.client.key -new -out kafkacat.client.csr -subj '/CN=kafkacat.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US'
openssl x509 -req -CA ca-root.crt -CAkey ca-root.key -in kafkacat.client.csr -out kafkacat-ca1-signed.crt -days 9999 -CAcreateserial -passin "pass:confluent"


::Create keystores
keytool -genkey -noprompt -alias server -dname "CN=server.test.confluent.io, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" -keystore server.keystore.jks -keyalg RSA -storepass confluent -keypass confluent

:: Create CSR, sign the key and import back into keystore
keytool -keystore server.keystore.jks -alias server -certreq -file server.csr -storepass confluent -keypass confluent

openssl x509 -req -CA ca-root.crt -CAkey ca-root.key -in server.csr -out server-ca-signed.crt -days 9999 -CAcreateserial -passin pass:confluent

keytool -keystore server.keystore.jks -alias CARoot -import -file ca-root.crt -storepass confluent -keypass confluent

keytool -keystore server.keystore.jks -alias $i -import -file server-ca-signed.crt -storepass confluent -keypass confluent

:: Create truststore and import the CA cert.
keytool -keystore server.truststore.jks -alias CARoot -import -file ca-root.crt -storepass confluent -keypass confluent