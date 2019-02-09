# Pettitude

[![Build Status](https://travis-ci.com/papay0/Pettitude.svg?token=3arWsr3xydR2Acvx4dZe&branch=master)](https://travis-ci.com/papay0/Pettitude)
The build is failing because of a dependency issue with Fastlane. Not sure I'll fix it TBH because I made this app to practice my mobile architcture skills, and as of now I already started a new app.

## App Store
Pettitude is on the [App Store](https://itunes.apple.com/nl/app/pettitude/id1447747060)!

![alt text](https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/6c/79/52/6c795298-9dae-5037-ffc6-f6e02d44e5fb/pr_source.png/230x0w.jpg "Pettitude Image Cat") ![alt text](https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/e4/b9/70/e4b970d0-b6d7-0934-9233-b41f1a2996a3/pr_source.png/230x0w.jpg "Pettitude Image Dog")

## Cool things about this app

### RIBs

It uses [Uber RIBs architecture](https://github.com/uber/RIBs).
You can check the [unit tests](https://github.com/papay0/Pettitude/blob/master/PettitudeTests/Onboarding/OnboardingRouterTests.swift) and the [mocks](https://github.com/papay0/Pettitude/blob/master/PettitudeTests/Mocks/Mocks.swift).

### Linting

I use [SwiftLint](https://github.com/realm/SwiftLint) to stay consistent with my code style across the app.

### Fastlane

- Deployment Automation
  - Beta
  - Release on the App Store
  - Send localized App Store Screenshots
- Frame it (to add the iPhone frame around the screenshot)
- Certificate management with Match

### Tooling

I made a [localization script](https://github.com/papay0/Pettitude/blob/master/tooling/localizations/check_localizations.py) in Python to check at compile time that each localization keys are in all the available localization files.
It helps me to know that I don't forget to translate a string when I add the english version.

### Firebase

#### Cloud functions

I use [Cloud Functions](https://github.com/papay0/Pettitude/blob/master/firebase/functions/src/index.ts) to manage all access to the database.

#### Hosting

I use Firebase Hosting to host the [Privacy Policy](https://pettitude-app.firebaseapp.com/) App Store page.

#### Remote Config

I use Remote Config to A/B test, but here mainly to be able to remote change the minimum level of matching of the animals.

#### ML Image Labeling

I use `VisionImage()` to detect the animals. 

### Analytics

I use the Firebase analytics with Fabric to keep track of bugs.
I also made a public API to quickly visualize [important stats](https://us-central1-pettitude-app.cloudfunctions.net/stats). (number of users etc)

### Debug

I have two schemes, one for release and one for debug. Debug is not linked to the same Firebase instance so that I do not update the production database.
