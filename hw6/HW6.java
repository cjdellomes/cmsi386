/* Name: Christopher Dellomes

   UID: 976113672

   Others With Whom I Discussed Things:
   Peyton Cross
   Justin Sanny
   Victor Frolov
   Nick Soffa
   Joe Barbosa
   J.B. Morris

   Other Resources I Consulted:
   
*/

/* Homework 6 - The Pipeline of Eratosthenes
 *
 * In this assignment you will use multithreading to build a fast
 * prime number sieve in Java. In reality, we will build a chain of
 * sieves, each running *concurrently* in separate threads. The chain
 * forms a pipeline: the output of each sieve is given as input to the
 * next sieve.
 *
 * Each sieve has knows about some prime numbers, and filters out all
 * numbers evenly divisible by any of its primes. Thus we have the
 * following picture:
 *
 *                              Numbers 
 *                                ||
 *                                ||
 *                                \/
 *                   +----------------------------+
 *                   |          Sieve 1           |
 *                   |    Primes: P1, ..., Pn     |
 *                   +----------------------------+
 *                                ||
 *                                ||  Numbers not evenly divisible by any
 *                                ||  of P1, ..., Pn
 *                                ||
 *                                \/
 *                   +----------------------------+
 *                   |          Sieve 2           |
 *                   |   Primes: Pn+1, ..., Pm    |
 *                   +----------------------------+
 *                                ||
 *                                ||  Numbers not evenly divisible by any
 *                                ||  of P1, ..., Pn, Pn+1, ..., Pm
 *                                ||
 *                                \/
 *                   +----------------------------+
 *                   |                            |
 *
 *
 * At the top of the pipeline, a generator "pours" a bunch of numbers
 * into Sieve 1. The output of Sieve 1 will be all numbers that are
 * not evenly divisible by any of the primes that Sieve 1 knows
 * about. Those numbers are then fed into Sieve 2, which filters out
 * numbers divisible by any of its primes. Thus, Sieve 2 will output
 * all number that are not divisible by any Sieve 1's primes or any of
 * Sieve 2's primes.
 *
 * How many Sieves do we need in the pipeline? Well, that depends on
 * (a) how many primes we want to find, and (b) how many primes each
 * sieve will hold. Suppose we want to generate the primes less than
 * 100, and each Sieve can hold 100 primes. In this case we only need
 * 1 sieve, since there are fewer than 100 primes less than 100.
 *
 * What if we want to generate all the primes less than 100 million,
 * and each Sieve can hold 100 primes? How many Sieves do we need
 * then? Furthermore, which primes do we put into each sieve? The
 * answer to both of these questions is that we will grow the pipeline
 * of sieves over time. Initially, we'll have just one sieve. Each
 * time we find a new prime, we add that new prime to the sieve's set
 * of primes. Once that sieve is full, we create a new sieve
 * (initially empty) and append it to the pipeline.
 *
 * How do we find a new prime? The generator will generate the
 * sequence of numbers 2, 3, 4, 5, 6, ... up to some maximum. For each
 * number n that is fed into the sieve pipeline, we will check if any
 * prime less than n can evenly divide n. If n makes it through the
 * entire pipeline, then there is no such prime, and n is therefore
 * itself prime (by the fundamental theorem of arithmetic).
 *
 * The key to making this fast is that we will use Java threads to run
 * each sieve in the pipeline concurrently. This should speed up the
 * process of generating primes by a factor of <something close to the
 * number of cores in your computer>.
 *
 * Here is some background reading for this assignment:
 *   https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
 *   https://en.wikipedia.org/wiki/Thread_(computing)
 *   https://docs.oracle.com/javase/tutorial/essential/concurrency/
 *
 * Now for some implementation details.
 * 
 * Up until now, inputs have always been given as function parameters,
 * and outputs produced as return values. This won't work for the
 * sieves, since they are running in separate threads. We need some
 * way to pass inputs and outputs between threads. Java's standard
 * library comes with a nice implementation of the Queue data
 * structure that fits the bill nicely. Each thread in our program
 * will have designated input and output queues, and each queue will
 * be the output queue of exactly 1 thread and the input queue of
 * exactly 1 thread. Each thread reads its inputs from the front of
 * its input queue, and writes its outputs to the back of its output
 * queue. Thus, all the queues are composed into a single pipeline.
 *
 * If you look up at the diagram above, the arrows denote the queues.
 * The queue pointing into each sieve is its input queue, and the
 * queue pointing away from it is its output queue.
 *
 * We'll use the java.util.concurrent.BlockingQueue interface, which
 * specially designed to work well in multi-threaded programs:
 *   https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html
 *
 * For this assignment, here's what you need to know about
 * BlockingQueue: each queue has some size, which determines how many
 * elements can be in the queue. There are two operations we will use:
 * put, which adds an element to the back of the queue, and take,
 * which removes an element from the front. These operations "block"
 * (hence the name BlockingQueue) in the following sense: if they
 * can't be performed immediately, the call will simply wait until
 * they can.  For example, we can't put an element if the queue is
 * full, so we wait until some space opens up. Similarly, if the queue
 * is empty when we want to take an element, we will wait until an
 * element shows up. This only makes sense in a multi-threaded
 * setting, where some other thread is going to make the change we are
 * waiting for.
 * 
 * You're going to need an implementation of BlockingQueue as
 * well. ArrayBlockingQueue is a reasonable choice:
 *   https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ArrayBlockingQueue.html
 *
 * The last bit you need to know is about Threads. We'll talk about
 * them in class, and they're also described in the background
 * reading:
 *   https://docs.oracle.com/javase/tutorial/essential/concurrency/
 *
 * The thread JavaDoc will also be helpful of course:
 *   http://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html
 *
 * There are 2 essential things you need to do with threads: construct
 * them (which includes telling them what code they should run), and
 * start them.
 * 
 * So now let's turn to constructing threads. We will use the 
 * Thread(Runnable target) constructor, which takes a Runnable argument:
 *   http://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html
 *
 * A Runnable is just an object with a run method that has no input
 * parameters and returns void.
 * 
 *    Thread t = new Sieve(...)
 *
 * To start a thread, call its start() method:
 *    Thread t = // Construct a thread somehow (more later)
 *    t.start(); // Now t is started!
 *    // Keep running.
 *
 * OK, so now there's a thread called t that's running some code
 * somewhere else. But the above code keeps running too. We have two
 * threads that are now running concurrently.
 *
 * Calling t.start() will call the Runnable's run() method. Once that
 * run() method returns, the thread exits.  The entire program keeps
 * running until main() returns *and* all the the threads exit.  So
 * you need a way to indicate to your sieve threads that no more
 * numbers are coming and so they should return from run(). A
 * reasonable way to do this by writing a designated value -1 to the
 * blocking queue.
 */

// DO NOT IMPORT ANYTHING OTHER THAN java.util.concurrent.* !!
import java.util.concurrent.*;
    
/* Step 1: Read the description and complete the implementation of
   DivideFilter. Compile and run `java TestDivideFilter` to test it.
   Add more tests. Once you are convinced that your DivideFilter
   works, move on to step 2.

   A DivideFilter is used by a Sieve. It contains some divisors, and
   can check if one of its divisors evenly divides some other number.
   
   We can add divisors to a DivideFilter, but each DivideFilter has
   some maximum capacity. Once full, no more numbers can be added.
 */

class NoMoreRoomException extends Exception {}

class DivideFilter {
    int capacity;
    int iterator;
    Integer[] divisors;
    
    DivideFilter(int capacity) {
      this.capacity = capacity;
      divisors = new Integer[capacity];
      iterator = 0;
    }

    // returns true if one of its stored divisors evenly divides i.
    boolean anyEvenlyDivides(Integer i) {
      try {
        for (int j = 0; j < divisors.length; j++) {
          if (i % divisors[j] == 0) {
            return true;
          }
        }
        return false;
      }
      catch (Exception e) {
        return false;
      }
    }

    // add a divisor
    // If the DivideFilter is full, then addDivisor should throw
    // a NoMoreRoomException.
    void addDivisor(Integer i) throws NoMoreRoomException {
      try {
        divisors[iterator] = i;
        iterator++;
      }
      catch(Exception e) {
        throw new NoMoreRoomException();
      }
    }

    // returns true if maximum capacity has been reached.
    boolean full() {
      return iterator >= capacity;
    }
}

// test your DivideFilter by running:
// $ java -ea TestDivideFilter
class TestDivideFilter {
  public static void main(String[] args) {
    TestDivideFilter tester = new TestDivideFilter();
    tester.test1();
    // tester.test2();  // So you can add more tests...
    // tester.test3();
  }

  void test1() {
    DivideFilter filter = new DivideFilter(1);
    assert(filter.anyEvenlyDivides(125) == false);

    try {
      filter.addDivisor(5);
      assert(filter.anyEvenlyDivides(125) == true);
    } catch(NoMoreRoomException e) {
      assert(false); // should not reach this point!
      System.out.println("This message shouldn't be printed");
    }

    assert(filter.full());

    try {
      filter.addDivisor(7);
      assert(false); // should not reach this point!
      System.out.println("This message shouldn't be printed");
    } catch (NoMoreRoomException e) {
      assert(filter.full() == true);
      // cool. was full, so addDivisor threw NoMoreRoomException.
    }
  }
}

class Helpers {
  // This class contains some helper functions for BlockingQueue and
  // Thread. You don't need to implement anything here. They are
  // just wrappers around put and take that ignore any
  // InterruptedExceptions and retries until the operation succeeds.
  // Don't worry about InterruptedException. It's important for
  // real-world multi-threaded programs, but is an unnecessary
  // complication for us.
    
  public static <E> void put(BlockingQueue<E> queue, E elem) {
    while(true) {
      try {
        queue.put(elem);
        return;
      } catch(InterruptedException e) {
        // Ignoring this. Just retry until it works.
      }
    }
  }
    
  public static <E> E take(BlockingQueue<E> queue) {
    while(true) {
      try {
        return queue.take();
      } catch(InterruptedException e) {
        // Ignoring this. Just retry until it works.
      }
    }
  }

  // You shouldn't need to use this directly, but some of the tests
  // I've provided do.
  public static void join(Thread t) {
    while(true) {
      try {
        t.join();
        return;
      } catch(InterruptedException e) {
        // Ignoring this. Just retry until it works.
      }
    }
  }
}

/* Part 2: Generator and Printer.
 * 
 * Generator and Printer are respectively the beginning and end of the
 * pipeline. Generator puts every integer from 2 up to (but not
 * including) some max value into the first queue. Then generator puts
 * -1 to signal the end of input. Printer takes numbers from the last
 * queue (which are the primes) and prints them to System.out. Once it
 * takes -1, it returns.
 */

class Generator implements Runnable {
  Integer max;
  BlockingQueue<Integer> output;

  Generator(Integer max, BlockingQueue<Integer> output) {
    this.max = max;
    this.output = output;
  }

  public void run() {
    // Generate numbers up to <max>, and puts them onto the BlockingQueue
    // <output>. Then put -1 to signal end of input and return.
    for (int i = 2; i < max; i++) {
      Helpers.put(output, new Integer(i));
    }
    Helpers.put(output, new Integer(-1));
    return;
  }
}

// test your Generator by running:
// $ java -ea TestGenerator
class TestGenerator {
  public static void main(String[] args) {
    BlockingQueue<Integer> queue = new ArrayBlockingQueue<Integer>(5);
    Generator gen = new Generator(100, queue);

    // start generator
    Thread t = new Thread(gen);
    t.start();
  
    for(int i = 2; i < 100; i++) {
      assert(Helpers.take(queue) == i);
    }

    // wait for generator thread to finish.
    Helpers.join(t);

    assert(Helpers.take(queue) == -1);
    assert(queue.isEmpty());
  }
}

class Printer implements Runnable {
  BlockingQueue<Integer> input;

  Printer(BlockingQueue<Integer> input) {
    this.input = input;
  }

  public void run() {
    // Print every number from input to System.out until we get -1.
    // then return.
    if (!input.isEmpty()) {
      Integer toPrint = -5;
      while(toPrint != -1) {
        toPrint = Helpers.take(input);
        System.out.println(toPrint);
      }
      return;
    }
    return;
  }
}

// TODO: Write a TestPrinter class to test your Printer!
class TestPrinter {
  public static void main(String[] args) {
    BlockingQueue<Integer> queue = new ArrayBlockingQueue<Integer>(5);
    Printer print = new Printer(queue);
  }
}

/* Part 3: Implement the Sieve.
 */
class Sieve implements Runnable {
  DivideFilter filter;
  BlockingQueue<Integer> input, output;
  Integer filterSize, queueSize;

  Sieve(BlockingQueue<Integer> input,
  BlockingQueue<Integer> output,
  Integer filterSize,
  Integer queueSize) {
    this.input = input;
    this.output = output;
    this.filterSize = filterSize;
    this.queueSize = queueSize;
    filter = new DivideFilter(filterSize);
  }

  public void run() {
  // For each numbers taken from input:

  // If we take -1 from input we need to stop. Signal the next
  // segment to stop by putting -1 into output, and then return.

  // Next check if any number in filter evenly divides it, and
  // if not put into output.

  // Next, check if filter is full. If not, this is the last
  // Sieve in the pipeline. Therefore, the is actually be prime,
  // so add it to the filter.

  // Next, if adding the number to filter made it full, we need
  // to create a new Sieve and add splice it in after this one.
  // Think carefully about how to do this!
    while(true) {
      Integer current = Helpers.take(input);
      if (current != -1) {
        if (!filter.anyEvenlyDivides(current)) {
          Helpers.put(output, current);
          if (!filter.full()) {
            try{
              filter.addDivisor(current);
            }
            catch(Exception e) {
            }
            if (filter.full()) {
              BlockingQueue<Integer> newInput = new ArrayBlockingQueue<Integer>(queueSize);
              BlockingQueue<Integer> newOutput = output;
              output = newInput;
              Sieve nextSieve = new Sieve(newInput, newOutput, filterSize, queueSize);
              Thread sieveThread = new Thread(nextSieve);
              sieveThread.start();
            }
          }
        }
      }
      else {
        Helpers.put(output, current);
        return;
      }
    }
  }
}

// test your Sieve by running:
// $ java -ea TestSieve
class TestSieve {
  public static void main(String[] args) {
    TestSieve tester = new TestSieve();

    // test DivideFilter size large enough that a single sieve
    // will work.
    tester.test(20);

    // this time we'll need multiple sieves
    tester.test(5);
  }

  void test(Integer filterSize) {
    BlockingQueue<Integer> input = new ArrayBlockingQueue<Integer>(10);
    BlockingQueue<Integer> output = new ArrayBlockingQueue<Integer>(10);

    Sieve sieve = new Sieve(input, output, filterSize, 10);
    Thread t = new Thread(sieve);
    t.start();
    for(int i = 2; i < 15; i++) {
      Helpers.put(input, i);
    }
    Helpers.put(input, -1);

    assert(Helpers.take(output) == 2);
    assert(Helpers.take(output) == 3);
    assert(Helpers.take(output) == 5);
    assert(Helpers.take(output) == 7);
    assert(Helpers.take(output) == 11);
    assert(Helpers.take(output) == 13);
    assert(Helpers.take(output) == -1);

    // Wait for thread t to exit.
    Helpers.join(t);

    assert(input.isEmpty());
    assert(output.isEmpty());
  }
}

class HW6 {
  public static void main(String[] args) {
    Integer max = Integer.parseInt(args[0]);
    Integer filterSize = Integer.parseInt(args[1]);
    Integer queueSize = Integer.parseInt(args[2]);

    long tStart = System.currentTimeMillis();
    // TODO: Construct and start a pipeline containing the
    // generator, a single sieve, and a printer.
    BlockingQueue input = new ArrayBlockingQueue<Integer>(queueSize);
    BlockingQueue output = new ArrayBlockingQueue<Integer>(queueSize);

    Generator gen = new Generator(max, input);
    Thread genThread = new Thread(gen);
    genThread.start();

    Sieve sieve = new Sieve(input, output, filterSize, queueSize);
    Thread sieveThread = new Thread(sieve);
    sieveThread.start();

    Printer print = new Printer(output);
    Thread printThread = new Thread(print);
    printThread.start();

    Helpers.join(genThread);
    Helpers.join(sieveThread);
    Helpers.join(printThread);

    long tEnd = System.currentTimeMillis();

    long tDiff = tEnd - tStart;
    System.out.format("Run time: %d minutes, %.2f seconds%n", tDiff/60000, (tDiff % 60000) / 1000.0);
  }
}

/* Part 4: Experiments
 *
 * For this part, make sure to run on a multi-core machine. 
 *
 * 1) How many CPUs cores does your machine have?
    4 Cores
 * 
 * 2) What is the run time for each of:
 *      java HW6 10000 1 1 = 1.09 seconds
 *      java HW6 10000 1 10 = 0.63 seconds
 *      java HW6 10000 10 1 = 0.25 seconds
 *      java HW6 10000 10 10 = 0.24 seconds
 *    What conclusions can you make from these times?
      The higher the max, the longer it takes.
      The higher the filter size, the faster the processing.
      The higher the queue size, the faster the processing.
 * 
 * 3) Use a system monitor (e.g. Task Manager on Windows, Activity 
 *    Monitor on Mac, top on linux or Mac) to observe your CPU
 *    utilization for each of:
 *      java HW6 100000 10 10 = 3.10 seconds and it spikes really hard
 *      java HW6 100000 10000 10 = 0.86 seconds and It spikes less hard
 *    What conclusions can you make from these observations?
      The lower the filter size, the more the CPU works.
 *
 * 4) Try a few different values of <filterSize> and <queueSize>
 *    and see which produce the lowest run time for: 
 *      java HW6 10000000 <filterSize> <queueSize>
 *    List the run times for each pair of values you tried.
      HW6 10000000 100000000 100000000 = 15 minutes, 23 seconds
 */

/* Part 5: Extra Credit
 *
 * Define a FastDivideFilter class that extends DivideFilter and
 * overrides its anyEvenlyDivides method. For each input number, only
 * test divisibility of primes less than its square root (use
 * Math.sqrt()). Hint: it will help if the primes are stored in
 * increasing order in the FastDivideFilter. List the run time of each
 * pair of <filterSize> and <queueSize> used in experiment #4 with
 * this optimization.
 */