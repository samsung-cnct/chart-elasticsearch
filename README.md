# solas-chart
`solas-chart` is scaffolding for new chart repositories hosted by Samsung CNCT. It implements our best practices, such as issue and PR templates, commit hooks, licensing guidelines, and so on.

SOLAS is also an international maritime treaty to ensure ships comply with minimum safety standards in construction, equipment and operation.

# Quickstart

- The name of chart repos should be of the form `chart-${NAME}`. For example, `chart-zabra` is the name of the repo which builds a chart named `zabra`.

- [Create](https://help.github.com/articles/creating-a-new-repository/) a new empty repo under the [`samsung-cnct`](https://github.com/samsung-cnct) org using the GitHub GUI, for example https://github.com/samsung-cnct/chart-zabra .

- [Duplicate](https://help.github.com/articles/duplicating-a-repository/) this repo (https://github.com/samsung-cnct/solas-chart) and push it to the `chart-zabra` repo you created in the previous step. Note the arguments to clone and push.

```
git clone --bare https://github.com/samsung-cnct/solas-chart.git
cd solas-chart.git
git push --mirror https://github.com/samsung-cnct/chart-zabra.git
cd ..
rm -rf solas-chart.git
```

- Configure the permissions for the `chart-zabra` repo. This is necessary for the integrations used in the next section and ensures your development work can take advantage of peer review from the start. From the 'Settings' section, go to the 'Collaborators & teams' tab, then add `commontools` as a team with admin privileges, and `kraken-reviewers` as a team with write privileges.

- [Fork](https://help.github.com/articles/fork-a-repo/) the `chart-zabra` repo (https://github.com/samsung-cnct/chart-zabra) from `samsung-cnct` and begin submitting PRs.

# Integrations Used by the Samsung CNCT Tools Team

- Configure CI/CD by following the instructions for [GitHub](https://github.com/samsung-cnct/solas/blob/master/docs/github.md), [Jenkins](https://github.com/samsung-cnct/solas/blob/master/docs/jenkins.md), and [Quay](https://github.com/samsung-cnct/solas/blob/master/docs/quay.md).

- Configure [Slack](https://github.com/samsung-cnct/solas/blob/master/docs/slack.md) notifications.
