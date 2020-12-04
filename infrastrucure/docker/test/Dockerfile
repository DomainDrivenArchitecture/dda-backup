FROM dda-backup

RUN apt -yqq install openjdk-13-jre-headless > /dev/null

RUN curl -L -o /tmp/serverspec.jar https://github.com/DomainDrivenArchitecture/dda-serverspec-crate/releases/download/2.0.0/dda-serverspec-standalone.jar

COPY serverspec.edn /tmp/serverspec.edn

RUN java -jar /tmp/serverspec.jar /tmp/serverspec.edn -v
