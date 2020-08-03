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
                        sh "terragrunt apply-all --terragrunt-non-interactive -auto-approve"
                    }
                }
            }
        }
    }
}