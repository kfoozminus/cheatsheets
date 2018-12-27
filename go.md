https://medium.com/rungo/go-introductory-tutorials-896aeda0fb8a

go env GOPATH		//shows effective current GOPATH
echo $GOROOT		//go installation directory
add bin directory to $PATH	//to compile

Whenever Go program hits import statement, it looks for package(s) in Go’s standard library ($GOROOT/src). If package is not present there, then Go refers to system's environment variable GOPATH which is path to Go workspace directory and looks for packages in $GOPATH/src directory.

A package object is created when you use go install command on non-main packages. You will learn about main and non-main packages in packages lesson. Package object are also called as cached objects or cached packages.	//getting started with go




go build 'package directory under GOPATH'		//outputs binary into current directory (where terminal is)
ex: go build github.com/kfoozminus/learngo/helloworld	//that's a folder/package btw
							//go build will work too if I'm in the package directory
go install <same as before>				//into bin directory
							//go install will work too if I'm in the package directory
go run <same as before>					//compile and execute
							//go run won't work


If a program is part of main package, then go install will create a binary file; which upon execution calls main function of the program. If a program is part of package other than main, then a package archive file is created with go install command.
"Since, app is not an executable package, it created app.a file inside pkg directory. We can not execute this file as it’s not a binary file."


//you can also build/run/install a single go file by
go build main.go
go run main.go
go install main.go


main.go is not necessary anywhere
main function is not necessary in a non-main package.
Exactly One main function is necessary in a main package





if you build, execute with './hello'
if you install you can just run 'hello'	//works like command, overwrites native commands
					//you can run everything in GOBIN as command
					//"This will install hello binary file in bin directory of your current Go workspace. Since, bin directory is in PATH, we can execute it from anywhere."
					//so when you type a command, it will search in every $PATH
go run doesn't save binary



godoc fmt Println



go get github.com/tahsin/oj		//will save the package in my GOPATH/src/github.com/tahsin/oj


Go exports a variable if a variable name starts with Uppercase. All other variables not starting with an uppercase letter is private to the package.

When you import a package, Go creates a global variable using package declaration of the package. In above case, greet is the global variable created by Go because we used package greet declaration in programs contained in greet package.	//medium "packages in go"

So, In *.go -  'import ""' should have the package directory, and if the package files contains "package x", then the *.go should write x.__ for importing function/variables. the global variable of the imported package is - x


Generally, when you install a 3rd party package, Go compiles the package and create package archive file. If you have written package locally, then your IDE might create package archive as soon as you save the file in the package or when package gets modified.


all the files in your program folder contains "package main" but only one file has main function

"go install or go build command requires a package name, which includes all the files inside a package, so we don’t have to specify them like above."

notice that, if one file in a package has a global variable/functin, it can accessed from another file from same package, because of the package scope.

You are not allowed to re-declare global variable with same name in the same package.


The rule is this. If the last token before a newline is an identifier (which includes words like int and float64), a basic literal such as a number or string constant, or one of the below tokens
break continue fallthrough return ++ -- ) }

//declaration
var x int
var x int = 5
var x = 5		//only works if initialized, picks up type from value
x := 5			//only if initialized - valid only if at least one variable wasn't declared before
			//only works inside functions and in small letter/local variables


var x, y, z int
var x, y, z int = 4, 5, 6	//every variable is same type
var x, y, z = 1, 3.4, false	//different type
x, y, z := 1, 4.5, true
var (
	x = 1
	y = false
	z string = "jen"
	xyz bool
)
Short hand notation syntax := can only be used inside function body. Also, it can only be used when at least one of the variables in the left side of := is newly declared.


in global, initialization cycle is used for declaration
var a = b
var b = c
var c = 2
declaration order is c, b, a
In local, it won't work


types - uint8, uint16, uint32, uint64, int8, int16, int32, int64
byte = uint8
rune = int32
float32, float64(works like double)
complex64, complex128


type float float64	//typedef
float and float64 aren't same type


specifier =
	%f for float
	%v for any value (input/output)
	%T for printing type (doesn't work with Println, have to use Printf
		//for alised type - it prints "package_name.alias_name"
    %X for printing hexadecimal format of a number
    %c for character


const (
	const_1 = 5
	const_2 string = "sdfdsf"
	const_3 = true
)
	//const must have values


In a parenthesized const declaration expressions can be implicitly repeated -this indicates a repetition of the preceding expression.
const(
	a = 1 // a == 1
	b = 2 // b == 2
	c     // c == 2
	d     // d == 2
)


const(
    a = iota // a == 0
    b = iota // b == 1
    c = iota // c == 2
    d        // d == 3 (implicitely d = iota)
)

const (
	a = iota + 1 // a == 1
	_            // (implicitly _ = iota + 1 )
	b            // b == 3 (implicitly b = iota + 1 )
	c            // c == 4 (implicitly c = iota + 1 )
)


if we import a package and don't use it, Go will complain, we can write
import (
	"fmt"
	_ "greet"
)


//package alias
import (
	"fmt"
	child "greet"
)


x := [5]int{5, 6,6, 45, 5}  //len(x) = 5
x := [5]int{
        5,
        6,
        6,
        45,
        5,
    }  //another declaration, have to use comma or Go would put semicolon there
x := [5]int{4, 4, 5, 6} //len(x) = 5, even if not initialized
x := [...]int{5, 6, 7, 32}  //len(x) = 4



[4]int and [5]int are not same type.
[3]int and [3]int is.
var a [3]int
var b [3]int
a == b is allowed
a = b is allowed


[...][2]int {
    [...]int{1, 2},
    [...]int{3, 4},
}
//cannot write [...][...] here because later [2] is the type

slice is just a reference to an array
that's why
var x []int
x == nil is true

//because zero-value of an array is 0, whereas zero value of a slice is nil.

//When a slice is created by simple syntax var s []int, it is not referencing any array, hence its value is nil.

type slice struct {
    zerothElement *type
    len int
    cap int
}       //slice is a struct which looks like this - so initially zerothElement is 0, which is nil. so zero-value of a slice is nil.

slice when needed to store more data, creates a new array of appropriate length behind the scene to accommodate more data.

slice := ar[2:4]
//refers to index 2 to 3
ar[2:] means ar[2:len]
ar[:4] means ar[0:4]
ar[:] means ar[0:len]

//if we want to allocate
slice := make([]int, 5, 10)     //5 is length and 10 is capacity - capacity is optional
//The make function takes a type, a length, and an optional capacity. When called, make allocates an array and returns a slice that refers to that array.
//make creates emply slice while previous declaration created nil slice


slice2 = append(slice1, ...)      //if slice2 crosses capacity of slice1, only slice2 will be copied to another location - otherwise both points to same location
                                //if copied - capacity will be doubled


copy(slice2, slice1)        //not same memory location

a := []string{"John", "Paul"}
b := []string{"George", "Ringo", "Pete"}
a = append(a, b...) // equivalent to "append(a, b[0], b[1], b[2])"
// a == []string{"John", "Paul", "George", "Ringo", "Pete"}


//... signifies both pack and unpack operator but if three dots are in the tail position, it will unpack a slice.

//unpack operator will use reference of the slice - that means, underlying array of the slice.

//cap value is important when appending. len value is important when copying.

re-slicing a slice doesn't make a copy of the underlying array. The full array will be kept in memory until it is NO LONGER REFERENCED.

//delete 2nd element
slice = append(slice[:2], slice[3:]...)

slice1 == slice2    //can't write this, only can compare to nil

slice1 := slice2    //allows assignment like object in C++

s1 := [][]int{
    []int{1, 2},
    []int{3, 4},
    []int{5, 6},
}
s2 := [][]int{
    {1, 2},
    {3, 4},
    {5, 6},
}


var mapp map[string]int     //creates nil map
mapp := make(map[string]int)    //creates empty map


Like slice, map can be only compared with nil.

Order of retrieval of elements in map is random when used in for iteration. Hence there is no guarantee that each time, they will be in order. That explains why we can’t compare two maps.


map1 = map2             //allowed like C++ object, reference copied
                        //to copy map, use for loop



mapMap := map[string]map[string]string {
    "H" : map[string]string {
        "name" : "hydrogen",
        "state": "gas",
    },
}


func f2() (r int) {
    r = 1
    return
}


func f() (int, int) {
    return 5, 6
}
func main() {
    x, y := f()
}


defer is a keyword in Go that makes a function executes in the end of the execution of parent function or when parent function hits return statement.

multiple defer function will be executed in stack/reverse order.

defer has 3 advantages: (1) it keeps our Close call near our Open call so its easier to understand, (2) if our function had multiple return statements (perhaps one in an if and one in an else ) Close will happen before both of them and (3) deferred functions are run even if a run-time panic occurs.

func main() {
    defer func() {
        str := recover()
        fmt.Println(str)
    }()
    panic("PANIC")
}


functions has type too.
they can be arguments or return value too.

"add is a anonymous function as it was created from a function that lacked name"

immediately invoked function.


func main() {
    x := 0
    increment := func() int {
        x++
        return x
    }
    fmt.Println(increment())
    fmt.Println(increment())
}

A function like this together with the non-local variables it references is known as a closure. In this case increment and the variable x form the closure.


Variadic functions are also functions but they can take infinite or variable number of arguments.
One important thing to notice is that only the last argument of a function is allowed to be variadic.


Closure and recursion are powerful programming techniques which form the basis of a paradigm known as functional programming.

panic generates error. recover collects the panic message.


go provides new function which allocates a memory and return pointer. Syntax of new function is
func new(Type) *Type
x := new(int)       //so x will be a pointer



var ptr *int        //ptr = nil
                    //it is not pointing to any value at this moment



Go is a garbage collected programming language which means memory is cleaned up automatically when nothing refers to it anymore.


zero-value of struct is zero value of every field.


we can also mix named fields and annonymous fields
type Employee struct {
	firstName, lastName string
	salary              int
	bool
}


structs can be compared with ==


type Employee struct {
	firstName string `json:"firstName"`
	lastName  string `json:"lastName"`
	salary    int    `json: "salary"`
	fullTime  int    `json: "fullTime"`
}


if variable is lowercase - it highest scope is within package
if uppercase - it can be exported outside of package


//It should be obvious from above error that in order to successfully implement an interface, you need to implement all methods declared by the interface.

//Interface has two types. A static type of interface is interface itself, for example Shape in above program. A interface do not have a static value, rather it points to a dynamic value. A variable of interface type can hold value of the Type that implements the interface. The value of that Type becomes dynamic value of the interface and that type becomes the dynamic type of the interface.

//Interface works in the similar way by dynamically holding reference to underlying type.

//dynamic type of interface also called as concrete type as when we access type of interface, it returns type of it’s underlying dynamic value and it’s static type remains hidden.



### [Concurrency](https://medium.com/rungo/achieving-concurrency-in-go-3f84cbf870ca)

- concurrency: doing different things concurrently, basically dividing the time between tasks
- parallelism: different core doing different tasks in parallel
- concurrency is dealing with multiple things at once, parallelism is doing multiple things
- go recommends using goroutines on one core, but we can modify to run in different cores
- when a program is sent to OS - a process has a primary thread, which creates other threads. when primary thread is done, the process exits
- process is a container that has compiled code, memory, OS resources, which is provided to threads. a process is a program in the memory
- thread is a lightwright process inside a process. actual executor of a piece of code.
- thread store variables in memory, called stack, fixed size of 1-2 MB. not shared with other threads
- process has heaps - shared memory among all threads of that process
- start a browser (program) - it will divide into different process like opening another tab - one process will open different threads like downloading, listening to music, browsing
- in multi-threading, threads need to be scheduled so that they work at a particular data at one time
- os threads are scheduled by kernel, some threads by runtime environment like JRE
- `race condition` a data is changed by other thread, while one thread is doing things - https://stackoverflow.com/questions/34510/what-is-a-race-condition
- use lock to prevent this
- java has a thread class to create multiple threads in a single process
- goroutine is an abstraction over threads
- `go runtime` will create few threads where multiple goroutines are spreaded/spawned/multiplexed. if one goroutine is terminated, another goroutine will come to that thread.
- this process by go runtime is much faster than thread scheduling
- if you want to use more than one cores, set `GOMAXPROCS` or use the function `runtime.GOMAXPROCS(n)`. but if you program communicates with channels more than computation, then increasing cores might degrade performance
- go has a `M:N` scheduler - schedules M goroutines among N os threads with GOMAXPROCS number of processors. normally, only one thread runs (in one core). when gomaxprocs is 1, go scheduler gives the upper hand to one goroutine then another, until all are finished
- there's a chart of differences between thread and goroutine. READ IT!
    - thread managed by kernel, has hardware dependency. goroutines by go runtime, doesn't have hardware dependency
    - threads have stack of 1-2MB, goroutines have 8KB
    - stack cannot grow, can grow upto 1GB
    - huge latency between inter-thread communication, goroutines use channels to communicate with other goroutine QJenny
    - threads have tid, goroutines doesn't have any id because go doesn't have thread local storage ([TLS](https://docs.microsoft.com/en-us/windows/desktop/ProcThread/thread-local-storage))
    - threads are scheduled preemptively, switching cost is high as scheduler needs to save 50 states and registers. goroutines are non-preemptive (cooperative) which saves only 3 registers
    - 



TODO: go get

GC: https://blog.twitch.tv/gos-march-to-low-latency-gc-a6fa96f06eb7

//go install vs go build
https://pocketgophers.com/go-install-vs-go-build/
go binary overwrites native shell commands - how to avoid this?
//so when you type a command, it will search in every $PATH, in what order?
go help

what if different files in same folder contains different "package <name>", what will "go install" or "go install <name>" do?


You are not allowed to re-declare global variable with same name in the same package. Hence, once version variable is declared, it can not be re-declared in the package scope. But you are free to re-declare elsewhere. --- https://medium.com/rungo/everything-you-need-to-know-about-packages-in-go-b8bac62b74cc
what the fuck is that?


blog er slice purata pori nai.
blog er string
