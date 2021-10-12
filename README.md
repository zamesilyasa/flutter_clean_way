# Flutter - clean way

## Sample project, which uses clean architecture approaches adn BLoC(cubit) pattern.

### The reasons of the project
I mostly develop enterprise android applications and often we write
the same application for different platforms(android/iOS). When a business needs an
application it usually means a 'thing', which can help the business to fulfill it's
needs. For mobile developers the 'thing' means 2 different applications for android and iOS.
When we tell the business that we can develop a single app which works on all the most
used mobile platforms it usually welcomes the initiative because they actually need an
app, which helps the business, they don't really care about the platforms but about the business. 
From my point of view flutter looks exactly what we need for enterprise applications. It works on
different platforms, the development process is fast and predictable, the community is huge
so we don't wander if the platform will rapidly die.

### Why do we need the clean way
Wen we talk about enterprise applications, we usually imply long terms support. Long terms
support means that we need to be careful about the decisions we make, especially when it comes
to architectures. I am a big fan of clean architecture approach designed by Bob Martin. I used
the architecture in many enterprise applications which I worked with and it proved that it's quite
good for mobile platforms and can be easily extended. It also allows us to cover all the app parts
with tests and it's quite convenient for dividing the work into small parts, it allows us to have big
teams for the project development.

### MVVM MVP and BLoC
As I am an android developer and I am used to using MVVM and MVP patterns for the UI layer.
it was quite hard for me to understand the BLoC pattern at the very beginning. I assume that BLoC
pattern confused me a lot because the name implies working with business logic(layer) but not
the UI layer. Eventually I came with the conclusion that the BLoC pattern is quite similar to MVVM
and it's designed mostly for working on the UI layer. the MVVM pattern is not ideal and it has it's
own pros and cons. The most critical drawback about the MVVM pattern is - it's really hard to reuse the
code of view models on different screens. Usually we have one view model per one screen. What I like
about BLoC is that BLoCs are not coupled with the screens, but with the UI logic. Here how I see
BLoC: BLoC is MVVM divided into parts. For example we have a LoginPage and LoginViewModel, which has
multiple methods for login, resetting passwords and so on like this:
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
use cubits instead of blocs. Cubits look much more similar to MVVM pattern which has methods for 
input events instead of event objects, what is much more convenient to use. We also don't need to 
care about the streams because cubits will provide the state automatically similar to pure Providers. 

### The goal
The goal is to create a simple project, which demonstrates how we can build an app using clean 
architecture and BLoC pattern.

### Structure
We have an application, which sets up the build processes, environments, and dependencies for the 
internal modules.

we have 3 layers here:

* **domain** - the most internal layer, which can be used by any module. The module doesn't 
  have flutter dependencies, it is used mostly for defining interfaces, DTOs which are used 
  in gateways and the gateway interfaces  
* **data** - this module implements the domain layer gateways, which are used for data manipulation
* **presentation** - all the views and BLoC/cubit implementations

links:
https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

https://medium.com/ideas-by-idean/a-flutter-bloc-clean-architecture-journey-to-release-the-1st-idean-flutter-app-db218021a804

https://bloclibrary.dev/#/

https://habr.com/ru/company/mobileup/blog/335382/
