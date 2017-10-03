/*
   This Jenkinsfile builds and tests helm charts, and pushes tagged versions to an app registry.
 */
def registry = "quay.io";
def registry_user = "samsung_cnct";
def chart_name = "zabra";
def robot_secret = "quay-robot-zabra-rw"

def helm_registry_image = "quay.io/samsung_cnct/helm-registry-agent";
def helm_registry_version = "v0.1.5";

podTemplate(label: 'chart-builder', containers: [
        containerTemplate(name: 'jnlp', image: 'quay.io/samsung_cnct/custom-jnlp:0.1', args: '${computer.jnlpmac} ${computer.name}'),
        containerTemplate(name: 'helm-registry-agent', image: 'quay.io/samsung_cnct/helm-registry-agent:v0.1.5', ttyEnabled: true, command: 'cat', alwaysPullImage: true, resourceRequestMemory: '256Mi', resourceLimitMemory: '256Mi'),
], volumes: [
    secretEnvVar(key: 'USERNAME', secretName: robot_secret, secretKey: 'username'),
    secretEnvVar(key: 'PASSWORD', secretName: robot_secret, secretKey: 'password')
]) {
    node('chart-builder') {
        customContainer('helm-registry-agent'){
            stage('Checkout') {
                checkout scm
            }

            stage('Build') {
                kubesh("CHART_VER=\$(git describe --tags --abbrev=0 | sed 's/^v//') CHART_REL=\$(git rev-list --count v\${CHART_VER}..HEAD) envsubst < build/Chart.yaml.in > ${chart_name}/Chart.yaml")
            }

            stage('Test') {
                kubesh("helm lint ${chart_name}")
            }

            if (env.BRANCH_NAME.startsWith('tags/v')) {
                stage('Deploy') {
                    kubesh("helm registry login ${registry} -u ${USERNAME} -p ${PASSWORD} && cd ${chart_name} && helm registry push ${registry}/${registry_user}/${chart_name} -c stable")
                }
            }
        }       
    }
}

def kubesh(command) {
    if (env.CONTAINER_NAME) {
        if ((command instanceof String) || (command instanceof GString)) {
            command = kubectl(command)
        }

        if (command instanceof LinkedHashMap) {
            command["script"] = kubectl(command["script"])
        }
    }

    sh(command)
}

def kubectl(command) {
    "kubectl exec -i ${env.HOSTNAME} -c ${env.CONTAINER_NAME} -- /bin/bash -c 'cd ${env.WORKSPACE} && ${command}'"
}

def customContainer(String name, Closure body) {
    withEnv(["CONTAINER_NAME=${name}"]) {
        body()
    }
}

// vi: ft=groovy
