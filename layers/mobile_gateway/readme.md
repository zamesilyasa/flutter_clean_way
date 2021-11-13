## Mobile data layer
Implements domain interfaces for mobile platforms - iOS and android.

# Tests
We can't use sqflite in tests directly, because it requires a mobile environment. 
For this reason we use sqflite_common_ffi for mocking sqflite. It also can be used
for integration tests