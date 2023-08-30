# T6-Mobile-EDC
A Mobile application of EDC [Web Application](https://staging.study.talosix.com).

## Technical Used in Project
- [BLoC Pattern](https://bloclibrary.dev/#/).
- [The Clean Architecture for Flutter](project_docs/clean_architecture.md)
- [The Implementation Flow of Project](project_docs/architecture.pdf)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

## Project Structure
```
|-- lib/
    |-- app/                          <--- application layer
        |-- configs/                  <-- all things related to the configuration (theme, style,...) of the project
        |-- blocs/                    <-- all controllers hold business logic, navigation of the application
        |-- extensions/               <-- extension class using inside project
        |-- models/                   <-- view models using in application layer
        |-- presentations/            <-- all views (main screens, custom view, ...) in application
            |-- screens/                  <-- all screens in application
            |-- widgets/                  <-- custom widgets component can use multiple place in the app
        |-- utils/                        <-- utility functions/classes/constants
        |-- main.dart                     <--- entry point
        
    |-- data/                         <--- data layer
        |-- entities/                     <-- entities class used in data layer
        |-- mappers/                      <-- mapper class helps map from entities to business model
        |-- repositories/                 <-- repositories (retrieve data, heavy processing etc..)
          |-- auth_repository.dart           <-- example repo: handles all authentication
        |-- helpers/                      <-- any helpers e.g. http helper
        |-- constants.dart                <-- constants such as API keys, routes, urls, etc..
        
    |-- device/                       <--- device layer (optional)
        |-- repositories/                 <--- repositories that communicate with the platform e.g. GPS, Bluetooth
        |-- utils/                        <--- any utility classes/functions
        
    |-- domain/                       <--- domain layer (business and enterprise) PURE DART
        |-- models/                   <--- enterprise entities (core classes of the app)
          |-- user.dart                   <-- example entity
        |-- usecases/                   <--- business processes e.g. Login, Logout, GetUser, etc..
          |-- login_usecase.dart          <-- example usecase extends `UseCase` or `CompletableUseCase`
        |-- repositories/               <--- abstract classes that define functionality for data and device layers
    |-- main.dart                     <--- entry point
```

## Features
- Integrating Unit Test.
- Create an easy to use API provider



<!-- omit in toc -->
- [Development Setup Guide](#development-setup-guide)
    - [Setup](#setup)
    - [Running](#running)
    - [Debug mode  (hot reloading enabled by default)](#debug-mode--hot-reloading-enabled-by-default)
    - [Release mode](#release-mode)
    - [Profile mode  (performance testing)](#profile-mode--performance-testing)
    - [Building](#building)
- [Testing](#testing)
    - [Writing Tests](#writing-tests)
    - [Running Tests](#running-tests)
        - [Setup code coverage report plugin](#setup-code-coverage-report-plugin)
        - [Running Unit Test and generate coverage report](#running-unit-test-and-generate-coverage-report)
        - [Running Integration Tests](#running-integration-tests)
- [Application Architecture](#application-architecture)
    - [Application Layers](#application-layers)
    - [Adding String Resources](#adding-string-resources)
    - [Creating Responsive Widgets](#creating-responsive-widgets)
- [Application Architecture Decisions](#application-architecture-decisions)
- [Incident Handling Guide](app_docs/Incidents/incidents.md)


## Development Setup Guide
### Setup
1. Clone the `mobile_apps` repo
    * ```git clone https://ghe.coxautoinc.com/Autotrader/mobile_apps.git```
2. Navigate to the installed repository
    * ```cd mobile_apps```
3. Install flutter package dependencies
    * ```flutter doctor```


### Running
Run the app using ```flutter run``` command additionally you can specify the build mode with which 
you want to run i.e debug, release or profile.

Flutter  uses ```--dart-define=SOME_KEY=SOME_VALUE``` to pass environment variables.

### Debug mode  (hot reloading enabled by default)

* pointing to Staging

```flutter run --debug --flavor staging --dart-define=ENV=staging -t lib/main.dart```

* pointing to Production

```flutter run --debug --flavor production --dart-define=ENV=production -t lib/main.dart```


### Release mode

* pointing to Staging

```flutter run --release  --dart-define=ENV=staging -t lib/main.dart```

* pointing to Production

```flutter run --release  --dart-define=ENV=production -t lib/main.dart```


### Profile mode  (performance testing)

* pointing to Staging

```flutter run --profile  --dart-define=ENV=staging -t lib/main.dart```

* pointing to Production

```flutter run --profile  --dart-define=ENV=production -t lib/main.dart```



### Building

Create a build artifact for Android or iOS using ```flutter build``` command

## Testing

### Writing Tests
- [Integration Tests](app_docs/Testing/integration_test.md)
- [Unit Tests](app_docs/Testing/unit_tests.md)
- [Widget Tests](app_docs/Testing/widget_tests.md)


### Running Tests
#### Setup code coverage report plugin

**- If you are on linux**

`sudo apt-get update -qq -y`

`sudo apt-get install lcov -y`

**- If you are using Mac**

`brew install lcov`

#### Running Unit Test and generate coverage report

On Mac device, we need to run this command for the first time `chmod +x ./run_unit_tests.sh`

and run command: `./run_unit_tests.sh`

When finish, it will open the code coverage report in the browser

#### Running Integration Tests

On Mac device, we need to run this command for the first time `chmod +x ./integration_tests.sh`

and run command:
```./integration_tests.sh```

When finish, you can see all the screenshots under `screenshot` folder

## Application Architecture

### [Application Layers](app_docs/App%20Architecture/application_layers.md)
### [Adding String Resources](app_docs/App%20Architecture/../App%20Architecture/adding_string_resources.md)
### [Creating Responsive Widgets](app_docs/App%20Architecture/../App%20Architecture/creating_responsive_widgets.md)


## Application Architecture Decisions

Text(AtcLanguage.NewScreen.title)

Refer to this folder for past decisions about app functionality and architecture decisions.
[Decisions](app_docs/Architecture%20Decisions/)

