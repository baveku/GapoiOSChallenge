# About App

- Design Architecture: MVVM + RxSwift
- Framework Manager: Cocoapods
- Analytics Plugin: Crashlytics.
- Other: Fastlane, Google Map Api.

## Features:

- Choose starting point/destination by searching place name, address.
- Draw routing path on the map base on starting point/destination and transporting mode
 
## Not integrated yet:

- Select Place with nearby location: 
	- Solution: 
		- Use delegates from Google Map to get Lat, Lng from Map
		- Using google place API to get Place nearby and Show it on TableView like SearchScreen.
- Continue...

## DEMO
![alt-text](https://github.com/baveku/GapoiOSChallenge/blob/master/demo.gif)