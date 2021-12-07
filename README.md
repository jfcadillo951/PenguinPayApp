# PenguinPayApp

## App Architecture:
- MVVM Architecture + Repository 

## Dependencies of the project:
Pods:
- RxSwift
- RxCocoa
- Cucko: for unit testsing mock

## Requirements

- iOS 12+
- Make sure you have [Cocoapods](https://cocoapods.org) installed along with Xcode 13.

## Usage
- Clone this repository, branch : develop
- Generate a apiKey for consuming Api of Exchange Rates [ExchangeRateApi](http://openexchangerates.org/), once you have your token replace it in Server.swift (for security reasons the apiKey is not commited in the repository):

```
struct ServerConstants {
    static let apiKey = "{api-key}"
    ....
}
```

- Run the proyect

## Pending Requiriments

Due to the 3 hour development time limit:
- The complete development of the transfer flow was prioritized, leaving aside the functionality of detecting the country of origin based on the phone number entered.
- All scenes need to be scrollable for small devices
- viewmodel and repositories are pending to be tested
