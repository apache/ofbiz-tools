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

## OFBiz and BuildBot

[Here is the OFBiz BuildBot script](https://svn.apache.org/repos/infra/infrastructure/buildbot/aegis/buildmaster/master1/projects/ofbiz.conf). If you are interested on modifying it, please understand its content and read the BuildBot documentation. Note that the Infra team is always there to help you.


### Schedulers and Builders
BuildBot uses schedulers and builders. Schedulers decide which builders to trigger on svn commits.

You can see the OFBiz builders and their states in the [common Buildbot waterfall view](https://ci.apache.org/waterfall) (look for "ofb").

The [ofbizTrunkFramework](https://ci.apache.org/builders/ofbizTrunkFramework)  builder is triggered on commits in the trunk framework branch. Then only the framework integration tests are run. This also triggers the [ofbizTrunkFrameworkPlugins](https://ci.apache.org/builders/ofbizTrunkFrameworkPlugins) and then the whole integration tests are run. To check that a commit in the framework puts no regressions in plugins and especially because the dependencies of ofbiz-framework without ofbiz-plugins is different from the dependencies of ofbiz-framework + ofbiz-plugins (plugins components are Gradle sub-projects). So testing needs to happen in both scenarios because you might face library version bugs.
Of course a commit into the trunk plugins also triggers the ofbizTrunkFrameworkPlugins.

The same apply to the [ofbizBranch17Framework](https://ci.apache.org/builders/ofbizBranch17Framework) and the [ofbizBranch17FrameworkPlugins](https://ci.apache.org/builders/ofbizBranch17FrameworkPlugins) and next releases branches, they follows the same structure than the trunk now.

The current stable branch R16.12 has only [one builder](https://ci.apache.org/builders/ofbizBranch16). This will be gone in future. All new releases needs 2 builders.

In an OFBiz builder page you can see [an history of the builds up to 100+](https://ci.apache.org/builders/ofbizTrunkFramework). OFBiz randomly uses 3 servers (except for RAT which always only uses lares_ubuntu) to build as you can see at the bottom of this page. You may want to explore more to get acquainted with the tool...

There is also the [RAT builder](https://ci.apache.org/builders/ofbizTrunkFrameworkRat). It checks the licenses in OFBiz. You can find the result [here](https://ci.apache.org/projects/ofbiz/rat-output.html)


### tests results
Here are the [test results](ci.apache.org/projects/ofbiz/logs/)
The folders structure [will soon be updated](https://issues.apache.org/jira/browse/INFRA-15842) to reflect the current svn repo structure.

### Technical information
When you create a new branch you need to let know BuildBot about it. This because BuildBot uses svn hooks to triggers builds on commits. [The file to change is here](https://github.com/apache/infrastructure-puppet/blob/deployment/modules/subversion_server/files/hooks/buildbot_project_paths)
You can't make commit in infrastructure-puppet if you are not an infra committer. So you need to clone the repo and make a Pull Request.


## Handling issues
Sometimes (rarely) you can get transient tests errors in BuildBot. This mean tests don't all pass in BuildBot, though they pass in your local instance. In such case, it's most certainly an issue with servers. Those are hard workers and make errors from time to time, which shows that not only human make errors.

Before doing anything it's best to check which BuildBot step is impacted, and if it exists have a look at the logfile (stdio) 

Some other errors may happen, like
* svn not updating
* upload not working
* you name it...

In such case you can trigger a build from IRC to see if the problem resolves by itself. Most of the time tests and svn issues are resolved this way. If it does not then the best is to ask Infra help, either on [HipChat infra room](https://apache.hipchat.com/chat/room/669587) or through the [service desk](https://issues.apache.org/jira/servicedesk/customer/portal/1/create/3)

When something like that happens, I get to IRC (using https://webchat.freenode.net). There using a recognisable username (I use jleroux) I get to the ofbiz channel. I wait for ofbiz-bot to appear, click on it, click on query and then I can make a request in the chat line to restart a scheduler.
A request is of the form 

    force build ofbizTrunkFramework
    
you can put the text you want to appear in builder, after this expression, something like
    
    forces manual build after weird error
   
So the whole request is of the form

    force build ofbizTrunkFramework forces manual build after weird error

Note though that with our last config (see [INFRA-15394](https://issues.apache.org/jira/browse/INFRA-15394)) the ofbizTrunkFrameworkPlugins and ofbizBranch17FrameworkPlugins builders are dependent and respectively automatically launched by the ofbizTrunkFramework and ofbizBranch17Framework builders but only on commits. So if you use an IRC command like `force build ofbizTrunkFramework` only this builder will be launched not the dependent ofbizTrunkFrameworkPlugins. We can't call a scheduler from IRC. It needs a svn commit.

### Randon conflicts on port 8080 during tests
One case which comes back from time to time is a conflit on port 8080 due to the automatic startup of tomcat. It's  due to security patches being applied on Silvanus (one of 3 the servers BuildBot uses for OFBiz, hence the random aspect, only Sylvanus is concerned). In such case we need to ask infra to manually disable Tomcat on Silvanus. This happened 4th already, last case was  [INFRA-15829](https://issues.apache.org/jira/browse/INFRA-15829)) where things are best explained.