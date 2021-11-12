## Domain layer

Domain layer includes definitions of all the use cases, entities and gateway
interfaces. The implementations of the repositories depend on platforms.

The top level application is responsible for particular implementation instantiations


mobile_gateway -> implements domain repositories

web_gateway -> implements domain repositories

app instantiates particular implementations and passes the instances to the 
use case constructors 
example:

**************** domain layer ****************
class User {
  final String name;
  User(this.name);
}

abstract class UserGateway {
  List<User> getUsers();
  User addUser(User user);
}
**************** domain layer ****************

***************** data layer *****************

class DataUserGateway extends UserGateway {
  override List<User> getUsers() {
  }
  User addUser(User user);
}

### IDs
In fact, any ID which comes from a persistence layer is the details fo the
particular data layer implementation and probably shouldn't be the part of domain 
entities. However, we need this information, to indirectly 'speak' to the datalayer 
when we need to get/remove/update entities. When it comes to the id type, 
it begs a lot of questions. I still don't have a strong opinion of what type the
id should be. It can be 

- `dynamic` - data layer knows about the type, it can be anything. The minis side
  of this type is that it's not serializable. We can accidentally put a quite 
  big and inconsistent data there.
- `Id?` - a custom type(class/interface). Data layer implements it and eventually
  casts it to the type it needs. The drawback of this approach is that it still
  can't protect us from anything, because any layer can put an implementation of the
  id and the data layer will fail during the casting.
- `String?` - serialized id. The data layer uses strings for id fields. In fact, it 
  can be `int`, `uuid`, `json` or anything else serialized to a string. The bad side
  of the approach is that the type is quite generic and for instance the UI can 
  accidentally assign `"-1"` to the id field and the data layer will try to find
  records with id -1 and fail.

All these options have minus sides.  I personally prefer strings, at least in my
projects, but you are free to choose any option or use any other approach.

### Tests
?????????
