// Cancel previous builds
def buildNumber = env.BUILD_NUMBER as int
if (buildNumber > 1) milestone(buildNumber - 1)
milestone(buildNumber)

pipeline {
    agent {
        kubernetes {
            yamlFile "jenkins-containers.yaml"
        }
    }
    stages {
        stage('Update Application') {
            steps {
                container('terragrunt') {
                    dir('terragrunt') {
                        withCredentials([usernamePassword(credentialsId: "aws", usernameVariable: 'ACCESS', passwordVariable: 'SECRET')]) {
                            ssh "AWS_ACCESS_KEY_ID=$ACCESS AWS_SECRET_ACCESS_KEY=$SECRET terragrunt apply-all --terragrunt-non-interactive -auto-approve"
                        }
                    }
                }
            }
        }
    }
}