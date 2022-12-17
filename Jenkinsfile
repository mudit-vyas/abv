pipeline {
	agent {	
		label 'ubuntu1'
		}
	stages {
		stage("SCM") {
			steps {
				git 'https://github.com/mudit-vyas/abv.git'
				}
			}

		stage("build") {
			steps {
				sh 'sudo mvn dependency:purge-local-repository'
				sh 'sudo mvn clean package'
				}
			}
		stage("Image") {
			steps {
				sh 'sudo docker build -t java-repo:$BUILD_TAG .'
				sh 'sudo docker tag java-repo:$BUILD_TAG muditvyas26/pipeline-java:$BUILD_TAG'
				}
			}
				
	
		stage("Docker Hub") {
			steps {
			withCredentials([string(credentialsId: 'docker_passwd', variable: 'docker_hub_password_var')]) {
				sh 'sudo docker login -u muditvyas26 -p ${docker_hub_password_var}'
				sh 'sudo docker push muditvyas26/pipeline-java:$BUILD_TAG'
				}
			}	

		}
		stage("QAT Testing") {
			steps {
				sh 'sudo docker run -d nginx'
				sh 'sudo docker rm -f $(sudo docker ps -a -q)'
				sh 'sudo docker run -dit -p 8080:8080  muditvyas26/pipeline-java:$BUILD_TAG'
				}
			}

		stage("testing website") {
			steps {
				retry(8) {
				sh 'curl --silent http://13.232.141.59:8080/java-web-app/ | grep -i "india" '
					}
				}
			}

		stage("Approval status") {
			steps {
				script {
					 Boolean userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                echo 'userInput: ' + userInput
					}
				}	
		}
		stage("Prod Env") {
			steps {
			 sshagent(['ubuntu-user']) {
			    sh 'ssh -o StrictHostKeyChecking=no ubuntu@13.232.141.59 sudo docker rm -f $(sudo docker ps -a -q)' 
	                    sh "ssh -o StrictHostKeyChecking=no ubuntu@13.232.141.59 sudo docker run  -d  -p  49153:8080  muditvyas26/pipeline-java:$BUILD_TAG"
				}
			}
		}
	}
}

