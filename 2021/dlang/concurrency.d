// concurrency in D cerner_2tothe5th_2021
import std.stdio, core.thread, std.concurrency;
 
void worker(int a) { 
   foreach (i; 0 .. 4) { 
        Thread.sleep(dur!("msecs")( i ) );
        writeln("Worker Thread ", a); 
   } 
}


void main() {
   foreach (i; 1 .. 4) { 
      writeln("Main Thread ",i); 
      spawn(&worker, i); 
   }
}
