# Kafka Mirror Maker

 - repo name: kafka-mirror-maker
 - folder: /kafka-mirror-maker

### How to run kafka mirror maker
 1. EXAMPLE: <br/>
    `sh bin/start-service.sh ut start all`

 2. COMMAND: <br/>
    `sh /kafka-mirror-maker/bin/start-service.sh ${env} ${action} ${service}` 

 3. with background execution: <br/>
    `nohup sh /kafka-mirror-maker/bin/start-service.sh ${action} > /dev/null 2>&1 &`

 4. env type: <br/>
     - ut:   12.34.56.78
     - uat:  12.34.56.78
     - prod: 12.34.56.78

 5. action type:
     - start: start streaming-kafka-mirror-maker
     - stop:  stop streaming-kafka-mirror-maker
     - status: check whether streaming-kafka-mirror-maker is running
     - restart: restart streaming-kafka-mirror-maker
   
 6. service type:
    - all: all service
    - ssl: only do for ssl service
    - nossl: only do for nossl service

### Folder Structure
 - bin:
   - start-service: the entry point of the whole project
   - utils: put common functions in it
 - conf:
   - jaas.conf: record jaas config to export in the beginning (use ticket cache)
   - consumer.properties: record consumer properties
   - consumer_ssl.properties: record consumer properties with ssl service
   - producer.properties: record producer properties
   - topic_list.properties: record all topics that needs to be copied (please use , to seperate all topics)
 - libexec: 
   - log: put all log function
 - var:
   - log/job.sh: record logs
   
### Config Setting
 - Without SSL:
   > kafka-run-class kafka.tools.MirrorMaker --consumer.config ~/kafka_mirror_maker_config/client_consumer.properties --producer.config ~/kafka_mirror_maker_config/client_producer.properties --whitelist TOPIC_EXAMPLE --new.consumer
    - consumer.properties
       ```
       fetch.min.bytes=1
       group.id=cloudera_mirrormaker
       session.timeout.ms=30000
       bootstrap.servers=12.34.56.78:9092
       request.timeout.ms=40000
       ```
    - producer.properties
       ```
       batch.size=16384
       bootstrap.servers=12.34.56.78:9092
       buffer.memory=33554432
       compression.type=none
       linger.ms=0
       request.timeout.ms=30000
       sasl.mechanism=GSSAPI
       security.protocol=SASL_PLAINTEXT
       sasl.kerberos.service.name=kafka
       ```
    - jaas.conf
       ```
       KafkaClient {
            com.sun.security.auth.module.Krb5LoginModule required
            debug=true
            useTicketCache=true
            serviceName="kafka";
       }
      ```
      
- With SSL:
  > kafka-run-class kafka.tools.MirrorMaker --consumer.config ~/kafka_mirror_maker_config/client_consumer_ssl.properties --producer.config ~/kafka_mirror_maker_config/client_producer.properties --whitelist TOPIC_SSL_EXAMPLE --new.consumer
    - consumer_ssl.properties
      ```
      group.id=cloudera_mirrormaker
      session.timeout.ms=30000
      bootstrap.servers=12.34.56.78:9092
      request.timeout.ms=40000
      security.protocol=SSL
      ssl.keystore.type=JKS
      sasl.kerberos.service.name=kafka
      ssl.keystore.location=/tmp/abc.keystore.jks
      ssl.keystore.password=
      ssl.truststore.location=/tmp/abc.truststore.jks
      ssl.truststore.password=
      ssl.enabled.protocols=TLSv1.2
      ```
    - producer.properties
      ```
      batch.size=16384
      bootstrap.servers=12.34.56.78:9092
      buffer.memory=33554432
      compression.type=none
      linger.ms=0
      request.timeout.ms=30000
      sasl.mechanism=GSSAPI
      security.protocol=SASL_PLAINTEXT
      sasl.kerberos.service.name=kafka
      ```
    - jaas.conf
       ```
       KafkaClient {
            com.sun.security.auth.module.Krb5LoginModule required
            debug=true
            useTicketCache=true
            serviceName="kafka";
       }
      ```
