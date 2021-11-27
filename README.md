# Flutter - clean way

## Sample project, which uses clean architecture approaches adn BLoC(cubit) pattern.

### The reasons of the project
I mostly develop enterprise android applications and often we write
the same application for different platforms(android/iOS). When a business needs an
application it usually means a 'thing', which can help the business to fulfill it's
needs. For mobile developers the 'thing' means 2 different applications for android and iOS.
When we tell the business that we can develop a single app which works on all the most
used mobile platforms it usually welcomes the initiative because it actually needs an
app, which helps the business, it doesn't really care about the platforms but about the goals. 
From my point of view flutter looks exactly what we need for enterprise applications. It works on
different platforms, the development process is fast and predictable, the community is huge
so we don't wander if the platform will rapidly die.

### Why do we need the clean way
Wen we talk about enterprise applications, we usually imply long terms support. Long terms
support means that we need to be careful about the decisions we make, especially when it comes
to architectures. I am a big fan of clean architecture approach designed by Bob Martin. I used
the architecture in many mobile enterprise applications which I worked with and it proved that 
it's quite good for mobile platforms and can be easily extended. It also allows us to cover all
the app parts with tests and it's quite convenient for dividing the work into small parts, it 
allows us to have big teams for the project development.

### MVVM MVP and BLoC
As I am an android developer and I am used to using MVVM and MVP patterns for the UI layer,
it was quite hard for me to understand the BLoC pattern at the very beginning. I assume that BLoC
pattern confused me a lot because the name implies working with business logic(layer) but not
the UI layer. Eventually I came with the conclusion that the BLoC pattern is quite similar to MVVM
and it's designed mostly for working on the UI layer, providing the communication bridge between the
UI and the business logic. the MVVM pattern is not ideal and it has it's own pros and cons. The most
critical drawback about the MVVM pattern is - it's really hard to reuse the code of view models on 
different screens. Usually we have one view model per screen. What I like about BLoC is that BLoCs 
are not coupled with the screens, but with the UI logic. Here how I understand BLoC: BLoC is MVVM 
divided into parts. For example we have a LoginPage and LoginViewModel, which has multiple methods
for login, password reset and so on like this:
```dart
/// the view model has a set of methods, related to the login 
/// process and basically it's designed for login screen. 
/// It can't be used on a screen, which partially supports the 
/// functionality available in the view model. For example a 
/// settings screen contains only reset password button.
/// Providing LoginViewModel to Settings screen will allow 
/// settings screen to login, what is not acceptable
class LoginViewModel {
    LoginViewModel(dependencies)
    
    login(String name, String password)
    resetPassword(String email)
    guestMode()
}
```
If we use BLoC we have all the logic divided by BLoCs:
```dart
/// Here we see that all the logic is divided into separate BLoCs.
/// It is completely fine to have the reset password functionality 
/// without having to provide the view model, which supports log in
/// and other methods, which are not used(supported) by the screen. 
/// So we can say that blocs can be easily reused by different screens 
class LoginBloc { 
  // Implementation 
}

class LogoutBloc {
  // Implementation 
}

class ResetPasswordBloc {
  // Implementation 
}
```

The bad side of BLoC is that we have to write a lot of boiler plate code to create blocs. We have
to create messages, states, streams and `event => state` mappers. To solve this problem we can
use cubits instead of blocs. Cubits look much more similar to MVVM approach where we have methods for 
input events instead of event objects, what is much more convenient to use. We also don't need to 
care about the streams because cubits provide the state automatically similar to pure Providers. 

### The goal
The goal of this project is to create a prototype, which demonstrates how we can build an app using 
clean architecture and BLoC pattern together.

### Lints
We use lints for dart packages and flutter_lints for flutter packages.
If you want to run lints for a specific package, cd to the project
folder and run `flutter analyze` or `dart analyze`.

If you need to run the linters for the whole project, cd to the root folder
and run `flutter analyze`, it will run the analyzers for all the dart and
flutter subprojects. IDEs detect the lint and flutter_lints dependencies
automatically and highlight the problems

It's also recommended to add `flutter analyze` to your
`.git/hooks/pre-commit` file, which will run the analysis before any
commit.

### Tests
Different projects require different test approaches. Some projects have only unit tests,
some projects have integration tests and UI tests. Clean architecture helps us a lot with tests,
because each layer is isolated from other layers. This architecture allows us test a layer in 
isolation. We also can write integration and UI tests providing the mock or real layers the 
testing module depends on. It's also required to be easy to use TDD, ATDD, BDD and similar 
approaches, and it's quite easy to apply them in the projects, because every single piece of 
logic or blocks of logic can be easily isolated. 

### Tools
Flutter/dart tools work only for the current project so if you run `flutter clean` command
it runs only for the project in the current directory. 
To run commands like `pub get` or `flutter clean` use ci script, which runs the given command for
all the projects one by one:

`./ci flutter clean`

### Structure
We have an application, which sets up the build processes, environments, and dependencies for the 
internal modules. It doesn't have any code related to the app functionality, it only set's up the
platform and manages the dependency injection.

You can have as many layers as you want, the only requirement is to keep the dependency rule, see
[original image](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg). 
In this application we have different backends. On mobile platforms we usually use 
internal storage + rest/graph api, on web pages we use only backend(rest) backend for data storage. 
To simplify the sample I used local storage for mobiles and memory storage for the  web app. 
The UI Also differs. Web applications should follow web guidelines, mobile apps usually
follow material or apple human interface guidelines. In the project I used single UI module for 
mobiles because design is not the purpose of this sample.

* **mobile_presentation** - implements all the views and BLoC/cubit related to the mobile platforms
* **web_presentation** - implements all the views and BLoC/cubit related to the web representation
* **generic_blocs** - most of the blocs can be reused by all the UI modules, but in some cases
  modules can have unique blocs which are suitable only for the platform. For example settings
  functionality is only available for mobile platforms. 
* **domain** - the most internal layer, which can be used by any module. The module doesn't 
  have flutter dependencies, it is used mostly for defining interfaces, DTOs which are used 
  in gateways and the gateway interfaces  
* **web_gateway** - web version of the domain gateways
* **mobile_gateway** - mobile version of the domain gateways

links:
https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

https://medium.com/ideas-by-idean/a-flutter-bloc-clean-architecture-journey-to-release-the-1st-idean-flutter-app-db218021a804

https://bloclibrary.dev/#/

https://habr.com/ru/company/mobileup/blog/335382/
