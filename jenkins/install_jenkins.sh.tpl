#! /bin/bash
sudo apt-get update

// install java
sudo apt-get install -y openjdk-8-jdk openjdk-8-jre
java -version

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update

// install jenkins
sudo apt-get install -y jenkins
// start jenkins service
// default running on 8080 port
sudo systemctl start jenkins
