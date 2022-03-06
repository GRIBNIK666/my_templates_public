yum install maven
#eclipse
	#https://mvnrepository.com/ download dependencies
		#copy maven section to pom.xml
#in project path
	cd /home/user/eclipse-workspace/<group_id>/ #ex. group_id: maven.test
mvn clean
mvn test
#<tree> fro project dir
<tree>
	pom.xml
	src
		--test
			--java
			--resources
		--main
			--java
			--resources
	target
		--classes
		--maven-status
		--test-classes