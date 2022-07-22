# Kafka Docker with PLAINTEXT AND SSL
This repo provides sample files for [Apache Kafka](https://www.confluent.io/what-is-apache-kafka/) and Confluent Docker images configuration for PLAINTEXT/SSL.

## Kafka Server :: PLAINTEXT
1. Open plaintext folder and run below command 

```cmd
docker-compose -up -d
```

## Kafka Server :: SSL
1. Open ssl/secrets folder
2. Create required certificate by run the below bat file 

```cmd
create-certs.bat
```
3. This will generate the below required certificates
    * kafka.server.keystore.jks
    * kafka.server.truststore.jks
    * root-ca.crt
    * kafka_client.crt
    * kafka_client.key
4. Go back to ssl folder and run below command
```cmd
docker-compose -up -d
```
SSL server would be up and running
