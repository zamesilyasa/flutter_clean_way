### Domain layer

Domain layer includes definitions of all the use cases, entities and repository
interfaces. The implementations of the repositories depend on platforms.

The top level application is responsible for particular implementation instantiations

data layer -> implements domain repositories
app instantiates particular implementations and passes the instances to the 
use case constructors 
example:

**************** domain layer ****************
class User {
  final String name;
  User(this.name);
}

abstract class UserRepository {
  List<User> getUsers();
  User addUser(User user);
}
**************** domain layer ****************

***************** data layer *****************

class DataUserRepository extends UserRepository {
  override List<User> getUsers() {
  }
  User addUser(User user);
}


