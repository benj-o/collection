# Collection: A SwiftUI Collection view

Present content in an ordered grid.  
Provides only the most essential functionality.

# Usage

Collection works like most other SwiftUI Views: Name, parameters, trailing closure.  
Example usage:

```swift

import SwiftUI

struct Person: Identifiable {
    var id = UUID()
    
    var name: String
    var age: Int
    
    init(_ name: String, _ age: Double) {
        self.name = name
        self.age = age
    }
    
}

let people = [
    Person("Lucy", 13),
    Person("Jim", 50),
    Person("Alice", 101)
]

Collection(people, columns: 2) { person in // Single parameter, the current value in `people`
    // Content:
    VStack {
         Text(person.name)
         Text(person.age)
    }
}
```
    
# Declaration 

```swift
struct Collection<Element, Content> : View where Element : Identifiable, Content : View
```

This means that the elements of the Array you provide as content **must conform to the *Identifiable* protocol.**


# Issues

- Currently, Collection does not handle the last row correctly if the number of items to display is less than the column count. The result is that the last columns's items will stretch to fill the container.

# More documentation

Option-Click Collection in Xcode for more help!

# Installation

Currently, Collection.swift does not support the Swift Package Manager or other package/dependency tools. Just copy-and-paste the contents of Collection.swift (please add the license in as well) to your project.
