:: Generate CA key
echo "Generate CA key"
openssl req -new -x509 -keyout root-ca.key -out root-ca.crt -days 365 -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US' -passin pass:confluent -passout pass:confluent

:: Kafka Client
openssl req -newkey rsa:2048 -nodes -keyout kafka.client.key -out kafka_client.csr -subj "/CN=kafkaclient.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US"
openssl req -passin "pass:confluent" -passout "pass:confluent" -key kafka.client.key -new -out kafka.client.req -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US'
openssl req -passin "pass:confluent" -passout "pass:confluent" -key kafka.client.key -new -out kafka.client.csr -subj '/CN=ca1.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US'
openssl x509 -req -CA root-ca.crt -CAkey root-ca.key -in kafka.client.req -out kafka-ca1-signed.pem -days 9999 -CAcreateserial -passin "pass:confluent"
openssl x509 -req -CA root-ca.crt -CAkey root-ca.key -in kafka.client.csr -out kafka.client.crt -days 365 -CAcreateserial -passin "pass:confluent"

echo "Server"
:: Server
keytool -genkey -noprompt -alias server -dname "CN=server.test.confluent.io, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" -keystore kafka.server.keystore.jks -keyalg RSA -storepass confluent -keypass confluent

echo "Create CSR, sign the key and import back into keystore"
:: Create CSR, sign the key and import back into keystore
keytool -keystore kafka.server.keystore.jks -alias server -certreq -file server.csr -storepass confluent -keypass confluent
openssl x509 -req -CA root-ca.crt -CAkey root-ca.key -in server.csr -out server-ca1-signed.crt -days 9999 -CAcreateserial -passin "pass:confluent"

keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file root-ca.crt -storepass confluent -keypass confluent

keytool -keystore kafka.server.keystore.jks -alias server -import -file server-ca1-signed.crt -storepass confluent -keypass confluent

echo "Create truststore and import the CA cert"
:: Create truststore and import the CA cert.
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file root-ca.crt -storepass confluent -keypass confluent

:: Client
keytool -genkey -noprompt -alias client -dname "CN=client.test.confluent.io, OU=TEST, O=CONFLUENT, L=PaloAlto, S=Ca, C=US" -keystore kafka.client.keystore.jks -keyalg RSA -storepass confluent -keypass confluent

:: Create CSR, sign the key and import back into keystore
keytool -keystore kafka.client.keystore.jks -alias client -certreq -file client.csr -storepass confluent -keypass confluent

openssl x509 -req -CA root-ca.crt -CAkey root-ca.key -in client.csr -out client-ca1-signed.crt -days 9999 -CAcreateserial -passin pass:confluent

keytool -keystore kafka.client.keystore.jks -alias CARoot -import -file root-ca.crt -storepass confluent -keypass confluent

keytool -keystore kafka.client.keystore.jks -alias client -import -file client-ca1-signed.crt -storepass confluent -keypass confluent

:: Create truststore and import the CA cert.
keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file root-ca.crt -storepass confluent -keypass confluent

::.Net Client require certificate

openssl req -newkey rsa:2048 -nodes -keyout kafka_client.key -out kafka_client.csr -subj "/CN=kafkaclient.test.confluent.io/OU=TEST/O=CONFLUENT/L=PaloAlto/S=Ca/C=US"
openssl x509 -req -CA root-ca.crt -CAkey root-ca.key -in kafka_client.csr -out kafka_client.crt -days 365 -CAcreateserial -passin "pass:confluent"