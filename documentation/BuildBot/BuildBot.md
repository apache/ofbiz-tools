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

IMO the BuildBot pros and cons are

### Pros
* Compared to a tool like Jenkins (those are the 2 I know) you don't have to use an UI, you write scripts. This is also a cons for some. 
* The syntax is simple and well documented, some prefer intuitive UI.
* The infra team at the ASF provides a kind of compiler which prevents to commits error in the shared script (the builders are all common to the ASF)   
* The infra team, especially Gavin McDonald, is always ready to help in a very efficient way

### Cons
* You have no UI so you have to write your own scripts, some prefer UIs to scripts.
* Despite the "compiler" you sometimes get unexpected result when you don't completely master BuildBot concepts. You must then ask infra for help, either on [HipChat infra room](https://apache.hipchat.com/chat/room/669587) or though the [service desk](https://issues.apache.org/jira/servicedesk/customer/portal/1/create/3) 

## OFBiz and BuildBot

[Here is the OFBiz BuildBot script](https://svn.apache.org/repos/infra/infrastructure/buildbot/aegis/buildmaster/master1/projects/ofbiz.conf)

You can see the OFBiz builders and their states in the [common Buildbot waterfall view](https://ci.apache.org/waterfall) (look for "ofb"). 
Here are the [test results](ci.apache.org/projects/ofbiz/logs/)

The [ofbizTrunkFramework builder](https://ci.apache.org/builders/ofbizTrunkFramework) is triggered on commits in the trunk framework branch. This also triggers the [ofbizTrunkFrameworkPlugins](https://ci.apache.org/builders/ofbizTrunkFrameworkPlugins) to check that a commit in the framework puts no regressions in plugins. 
The same apply to the [ofbizBranch17Framework](https://ci.apache.org/builders/ofbizBranch17Framework) and the [ofbizBranch17FrameworkPlugins](https://ci.apache.org/builders/ofbizBranch17FrameworkPlugins)
The current stable branch R16.12 has only [one builder](https://ci.apache.org/builders/ofbizBranch16). This will be gone in future. All new releases needs 2 builders.

In an OFBiz builder page you can see [an history of the builds up to 100+](https://ci.apache.org/builders/ofbizTrunkFramework). OFBiz randomly (except for RAT) uses 3 servers to build as you can see at the bottom of this page. You may want to explore more to get acquainted with the tool...

There is also the [RAT builder](https://ci.apache.org/builders/ofbizTrunkFrameworkRat) which check the licenses in OFBiz. You can find the result [here](https://ci.apache.org/projects/ofbiz/rat-output.html)

# Handling issues
Sometimes (rarely) you can get transient tests errors in BuildBot. This mean tests don't all pass in BuildBot, though they pass in your local instance. In such case, it's most certainly an issue with servers. Those are hard workers and make errors from time to time, which shows that not only human make errors :smirk:.

Before being anything it's best to check which BuildBot step is impacted and if it exists have a look at the logfile (stdio) 

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

Note though that with our last config (see [INFRA-15394](https://issues.apache.org/jira/browse/INFRA-15394)) the ofbizTrunkFrameworkPlugins and ofbizBranch17FrameworkPlugins builders are dependent and respectively automatically launched by the ofbizTrunkFramework and ofbizBranch17Framework builders but only on commits. So if you use an IRC command like `force build ofbizTrunkFramework` only this builder will be launched not the dependent ofbizTrunkFrameworkPlugins.