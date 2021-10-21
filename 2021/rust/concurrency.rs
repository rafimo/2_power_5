// concurrency in rust
// cerner_2tothe5th_2021
use std::thread;
use std::time::Duration;

fn main() {
    let thread = thread::spawn(|| {
        for i in 1..10 {
            println!("starting {} - thread", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("starting {} - main", i);
        thread::sleep(Duration::from_millis(1));
    }

    // wait for spawned thread to finish..
    thread.join().unwrap();
}
