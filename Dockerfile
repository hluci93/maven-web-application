FROM tomcat:8.0.20-jre8
LABEL type="maven"
EXPOSE 8080
COPY target/maven*.war /usr/local/tomcat/webapps/
