The dependency-check-report.html is only given as an example.
It uses the Gradle dependency check gradle plugin:
    https://plugins.gradle.org/plugin/dependency.check

In any cases be sure to check
    https://cwiki.apache.org/confluence/display/OFBIZ/About+OWASP+Dependency+Check

The Gradle command is
    gradlew -PenableOwasp dependencyCheckAnalyze

The task takes time to complete, and once done, a report will be generated in
$OFBIZ_HOME/build/reports/dependency-check-report.html
