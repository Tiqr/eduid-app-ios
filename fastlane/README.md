fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios set_build_number
```
fastlane ios set_build_number
```
Set build number using the last commit date and the github runner number
### ios deploy_acceptance
```
fastlane ios deploy_acceptance
```
Push a new build connected to Acceptance to Firebase App Distribution
### ios deploy_acceptance_ci
```
fastlane ios deploy_acceptance_ci
```
Push a new build connected to Acceptance to Firebase App Distribution from GitHub Actions
### ios deploy_production
```
fastlane ios deploy_production
```
Push a new build connected to Production to TestFlight
### ios deploy_production_ci
```
fastlane ios deploy_production_ci
```
Push a new build connected to Production to TestFlight from GitHub Actions

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
