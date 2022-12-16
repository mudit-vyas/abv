FROM tomcat:8.0.20-jre8
 
COPY target/java-web-app*.war /opt/tomcat/apache-tomcat-8.5.84/webapps/java-web-app.war
