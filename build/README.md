Jenkins CI/CD Build and Deploy
==============================

Having cloned this repo to create a new chart using the [README](../README.md) 
instructions at, edit this Jenkinsfile and Chart.yaml.in.

Jenkinsfile
-----------

Edit the three defs at the top:
```
def registry = "quay.io";
def registry_user = "samsung_cnct";
def chart_name = "sample-chart";
```

Replace each as needed. The chart_name should be the name of the chart you've added under the root of this git repo.

Chart.yaml.in
-------------

Edit this file to match your chart as needed. Do not alter the line starting with `version:`.

Configure Jenkins
=================

Manual Instructions
-------------------

* Log in to Jenkins.
* New Item
* _Enter the name of this repo in the field at the top, eg chart-sample-chart_
* Multibranch Pipeline
* Branch Sources
  * Add Source
  * Github
  * _Set an owner, eg samsung-cnct_
  * _Select an entry under "scan credentials", eg "Samsung CNCT Jenkins Bot/******"_
  * _Select your repository, eg "chart-sample-chart"_
  * Advanced
     * Check _Build origin PRs (unmerged head)_
     * Check _Build fork PRs (unmerged head)_
     * Uncheck _everything else_
  * Add Source
  * Git
  * _Add https url for the repo in "Project Repository", eg "https://github.com/samsung-cnct/chart-sample-chart.git"_
  * _Add the same credentials as github above_
  * Advanced
    * _Enter into RefSpecs_ `+refs/tags/*:refs/remotes/origin/tags/*`
    * _Enter into Include Branches_ `**`
* Build Configuration
  * _Enter into Script Path_ `build/Jenkinsfile`
  * Scan Repository Triggers
    * Periodically if not otherwise run
* Save

Add Webhooks to Github
----------------------

Add the following webhooks:
* https://common-jenkins.kubeme.io/github-webhook/
  Send me everything
* https://common-jenkins.kubeme.io/ghprbhook/
  Let me select indivdual events: Issue comment, Pull Request

Optionally add a webhook for slack, eg:
* https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX
  Content Type: application/json
  Individual Events: Commit comment, Delete, Deployment status, Issues, 
                     Pull request review, Push, Create, Fork, Issue Comment,
                     Pull request, Pull request review comment, Release
