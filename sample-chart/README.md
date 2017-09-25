# template-chart
`template-chart` is scaffolding for new helm charts hosted by Samsung CNCT. It implements our best practices, such as issue and PR templates, commit hooks, licensing guidelines, and so on.

# Quickstart

- The name of chart repos should be of the form `chart-${NAME}`. For example, `chart-foo-app` is the name of the repo which builds a chart named `foo-app`.
- [Create](https://help.github.com/articles/creating-a-new-repository/) a new empty repo under the [`samsung-cnct`](https://github.com/samsung-cnct) org using the GitHub GUI, for example https://github.com/samsung-cnct/chart-foo-app .
- [Duplicate](https://help.github.com/articles/duplicating-a-repository/) this repo (https://github.com/samsung-cnct/template-chart) and push it to the `chart-foo-app` repo you created in the previous step. Note the arguments to clone and push.

```
git clone --bare https://github.com/samsung-cnct/template-chart.git
cd template-chart.git
git push --mirror https://github.com/samsung-cnct/chart-foo-app.git
cd ..
rm -rf template-chart.git
```

- [Fork](https://help.github.com/articles/fork-a-repo/) the `chart-foo-app` repo (https://github.com/samsung-cnct/chart-foo-app) from `samsung-cnct` and begin submiitting PRs.

# What to do next?

- You should configure CI/CD by following the instructions for [GitHub](https://github.com/samsung-cnct/template-chart/blob/master/docs/github.md), [Jenkins](https://github.com/samsung-cnct/template-chart/blob/master/docs/jenkins.md) (note that some things may not work for pushing to quay...), and [Quay](https://github.com/samsung-cnct/template-chart/blob/master/docs/quay.md).

- You may want to update the teams [Slack notifications](https://samsung-cnct.slack.com/apps/search?q=github) to notify developers of PR and issue activiy. To do this you will need [Admin Privileges](https://help.github.com/articles/repository-permission-levels-for-an-organization/). To ensure that you are not the only one who can maintain these integrations, it is recommended that you grant a GitHub Team (e.g. `commontools`) permissions and not a single individual contributor.

- If your project will be administered by a GitHUb team (e.g. `commontools`), you will need to contact an owner of the `samsung-cnct` organization so they can grant the `commontools` team admin privileges. Reachout in the `#cnct-dev` or `#team-tooltime` Slack channels.

- You will likely need to configure our [Jenkins CI](https://common-jenkins.kubeme.io/) to test, release and deploy changes.
