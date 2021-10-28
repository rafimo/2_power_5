// concurrency in swift
// cerner_2tothe5th_2021
import Foundation
 
let thread = DispatchQueue(label: "mythread", attributes: .concurrent)

// synchronous thread
thread.sync {
    print("1")
    print("3")
}

// run async
thread.async {
    print("A")
    print("B")
    print("C")
}

// run async
thread.async {
    print("2")
}

print("In Main")
