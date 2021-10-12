
class InternalClass {
  InternalClass() {
    throw Exception("Should not be visible to external modules");
  }
}