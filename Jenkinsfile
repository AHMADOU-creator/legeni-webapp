pipeline {
  agent any
  environment { IMAGE = 'ahmadoungb/legeni-webapp' }
  stages {
    stage('Version') {
      steps { script {
        env.VERSION = readFile('VERSION').trim()
        env.TAG = "${env.VERSION}-${env.BUILD_NUMBER}"
      } }
    }
    stage('Qualite') {
      parallel {
        stage('Tests flake8 couverture') {
          steps {
            sh 'docker build --target test -t legeni-test .'
            sh 'docker rm -f tmp-test || true; docker create --name tmp-test legeni-test; docker cp tmp-test:/app/report.xml . || true; docker rm tmp-test'
          }
          post { always { junit allowEmptyResults: true, testResults: 'report.xml' } }
        }
        stage('Hadolint') {
          steps { sh 'docker run --rm -i hadolint/hadolint hadolint --failure-threshold error - < Dockerfile' }
        }
        stage('Syntaxe Ansible') {
          steps { sh 'cd ansible && ansible-playbook --syntax-check provision.yml' }
        }
      }
    }
    stage('Build') {
      steps { sh 'docker build --build-arg APP_VERSION=$VERSION -t $IMAGE:$TAG .' }
    }
    stage('Scan Trivy') {
      steps { sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v trivy-cache:/root/.cache aquasec/trivy image --no-progress --scanners vuln --severity CRITICAL --ignore-unfixed --exit-code 1 $IMAGE:$TAG' }
    }
    stage('Push') {
      when { branch 'main' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'registry-credentials', usernameVariable: 'U', passwordVariable: 'P')]) {
          sh 'echo $P | docker login -u $U --password-stdin && docker push $IMAGE:$TAG'
        }
      }
    }
    stage('Deploy staging') {
      when { branch 'main' }
      steps { script { deploy('staging') } }
    }
    stage('Validation humaine') {
      when { branch 'main' }
      steps { input message: 'Deployer en production ?', ok: 'Oui, go' }
    }
    stage('Deploy prod') {
      when { branch 'main' }
      steps { script { deploy('prod') } }
    }
  }
  post {
    failure {
      withCredentials([string(credentialsId: 'discord-webhook', variable: 'HOOK')]) {
        sh '''curl -s -H "Content-Type: application/json" -d "{\\"content\\":\\"Pipeline KO : $JOB_NAME #$BUILD_NUMBER\\"}" "$HOOK" || true'''
      }
    }
  }
}

def deploy(envName) {
  withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG'),
                   string(credentialsId: 'ansible-vault-pass', variable: 'VP')]) {
    sh """
      echo "\$VP" > .vp
      cd ansible && ansible-playbook deploy.yml -e target_env=${envName} -e image_tag=\$TAG --vault-password-file ../.vp
      rm -f ../.vp
    """
  }
}
