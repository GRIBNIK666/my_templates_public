wget https://services.gradle.org/distributions/gradle-6.8.1-bin.zip -P /tmp
# NEED 6.8.1 for ppot, TRY 
	#NOO 7.1.1
#Once the download is completed, unzip the file in the /opt/gradle directory:
unzip -d /opt/gradle /tmp/gradle-6.8.1-bin.zip

#Verify that the Gradle files are extracted:
ls /opt/gradle/gradle-*

#configure the PATH environment variable to include the Gradle bin directory
sudo vi /etc/profile.d/gradle.sh
	#file contents
export GRADLE_HOME=/opt/gradle/gradle-6.8.1
export PATH=${GRADLE_HOME}/bin:${PATH}
	#
# make file executable
sudo chmod +x /etc/profile.d/gradle.sh
#load environment
source /etc/profile.d/gradle.sh

# verify installation
gradle -v

#REMOVAL
sudo rm -rf /opt/gradle
sudo rm -rf /etc/profile.d/gradle.sh
export -n GRADLE_HOME
export -n PATH