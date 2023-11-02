<!--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
## What is BuilbBot and why using it?
OFBiz uses [BuilbBot](https://en.wikipedia.org/wiki/Buildbot) as its Continuous Integration (CI) tool. There are other CI tools [used at the ASF](https://ci.apache.org/).
There is also [a file in Git for project paths](https://github.com/apache/infrastructure-p6/blob/production/modules/subversion_server/files/hooks/buildbot_project_paths). You can't clone, but you can make PRs inside it AIUI, via the github UI, just make a new branch and PR it. More information about creating a new branch below.

## OFBiz and BuildBot

[Here is the OFBiz BuildBot script (ofbiz.py)](https://svn.apache.org/repos/infra/infrastructure/buildbot2/projects/ofbiz.py). If you are interested on modifying it, please understand its content and read the BuildBot documentation. Note that the Infra team is always there to help you. If you modify ofbiz.py be sure to be subscribed to private@infra.apache.org before. It's where the syntax checker can help you in case of issues. I think that not everybody can be subscribed, at least ASF members, and maybe more, better check with Infra team when needed.

### Schedulers and Builders
BuildBot uses schedulers and builders. Schedulers decide which builders to trigger on Git commits.

You can see the OFBiz builders and their states in the [common Buildbot builders view](https://ci2.apache.org/#/builders) (look for "ofb" or just scroll down).

The ofbizTrunkFramework builder is triggered on commits in the trunk framework branch. Then only the framework integration tests are run. This also triggers the ofbizTrunkFrameworkPlugins if the build succeed. Then the whole integration tests are run. To check that a commit in the framework puts no regressions in plugins and especially because the dependencies of ofbiz-framework without ofbiz-plugins is different from the dependencies of ofbiz-framework + ofbiz-plugins (plugins components are Gradle sub-projects). So testing needs to happen in both scenarios because you might face library version bugs.

Of course a commit into the trunk plugins also triggers the ofbizTrunkFrameworkPlugins.

The same apply to the current stable version (eg ofbizBranch18Framework and ofbizBranch18FrameworkPlugins) and next releases branches, they follows the same structure than the trunk.

In an OFBiz builder page you can see [an history of the builds up to 100](https://ci2.apache.org/#/builders/49). You can see more by using [the settings page](https://ci2.apache.org/#/settings). You may want to explore more to get acquainted with the tool...

There is also the RAT builder. It checks the licenses in OFBiz. You can find the trunk results [here](https://nightlies.apache.org/ofbiz/trunk/rat-output.html). There are also RAT builders for the next and stable release branches.


### tests results
Here are the [trunk test results](https://nightlies.apache.org/ofbiz/trunk/tests-results/). The framework results contain only the framework integration tests while the plugins results contain all the test for framework and plugins. You can find the same for the next and stable release branches. 

### Technical information
When you create a new branch you need to let know BuildBot about it. This because BuildBot uses Git hooks to triggers builds on commits. [The file to change is here](https://github.com/apache/infrastructure-p6/blob/production/modules/subversion_server/files/hooks/buildbot_project_paths). You can't clone, but you can make PRs via the github UI, just make a new branch and PR it.

## Handling issues
> Note: you need to be a committer

Sometimes (rarely) you can get transient tests errors in BuildBot. This mean tests don't all pass in BuildBot, though they pass in your local instance. In such case, it's most certainly an issue with servers. Those are hard workers and make errors from time to time, which shows that not only human make errors :)

Before doing anything it's best to check which BuildBot step is impacted, and if it exists have a look at the logfile (stdio) 

Some other errors may happen, like
* Git not updating
* upload not working
* you name it...

In such case, after logging in Buildbot using as credential your Apache email and your LDAP password, you can trigger a build from BuildBot UI to see if the problem resolves by itself. For that open the last commit and use the "Rebuid" button at top-right.

Most of the time tests and issues are resolved this way. If it does not then the best is to ask Infra help, either on [Infra Slack channel](https://the-asf.slack.com/archives/CBX4TSBQ8) or by creating an [Infra Jira issue](https://issues.apache.org/jira/projects/INFRA/summary).

### Random conflicts on port 8080 during tests
Though today (2021-12-31) this seems to not happen anymore, one case which comes back from time to time is a conflit on port 8080 due to the automatic startup of tomcat. It's  due to security patches being applied on one of 3 the servers BuildBot uses for OFBiz, hence the random aspect. In such case we need to ask infra to manually disable Tomcat on this server. This happened 4th times already, last case was [INFRA-15829](https://issues.apache.org/jira/browse/INFRA-15829) where things are best explained.


### Creating a new branch
1. Adapt existing next scheduler, builder, factory, modify the reference in common part and modify the "next" RAT builder in [the "ofbiz.py" OFBiz BuildBot script](https://svn.apache.org/repos/infra/infrastructure/buildbot2/projects). Most of the time only the names need to be changed...
2. Ask Infra for a new directories structure for the tests (eg https://issues.apache.org/jira/browse/INFRA-17513)  
3. Adds the new branches [in the Git file for project paths](https://github.com/apache/infrastructure-p6/blob/production/modules/subversion_server/files/hooks/buildbot_project_paths). You can't clone, but you can make PRs via the github UI, just make a new branch and PR it. When you create a new branch you need to let know BuildBot about it. This because BuildBot uses Git hooks to triggers builds on commits. 
4. Remove old branches if no longer supported.

