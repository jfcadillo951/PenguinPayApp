# PenguinPayApp

## App Architecture:
- MVVM Architecture + Repository 

## Dependencies of the project:
Pods:
- RxSwift: for iOS 12+ support
- RxCocoa: for iOS 12+ support
- MBProgressHUD: for hud display

## Requirements

- iOS 12+
- Make sure you have [Cocoapods](https://cocoapods.org) installed along with Xcode 13.

## Usage
- Clone this repository, branch : develop
- Generate a apiKey for consuming Api of Exchange Rates [ExchangeRateApi](http://openexchangerates.org/), once you have your apiKey replace it in ServerConstants.swift (for security reasons the apiKey is not commited in the repository):

```
struct ServerConstants {
    static let apiKey = "{api-key}"
    ....
}
```
- Execute `pod install` in the terminal
- Run the proyect

## Pending Requirements

Due to the 3 hour development time limit:
- The complete development of the transfer flow was prioritized, leaving aside the functionality of detecting the country of origin based on the phone number entered.
- All scenes need to be scrollable for small devices
- viewmodel and repositories are pending to be tested
