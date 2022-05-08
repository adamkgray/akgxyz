# Writing a Turing Machine in Go

_07.05.2022_

## About

My conversion MSc program had us take a course called "Fundamentals of Computing" which was essentially computer science's greatest hits. This included, of course, turing machines.

The backbone of a turing machine is its associated state transition table (STT). The STT contains the rules of the turing machine - given this state and this symbol, do this and then go to this next state. 

There are some tools online to us learners learn about the inner working of turing machines, but none that suited the problems we were given. Namely, we had to interpret and construct our own STTs. For example, we had to state in English the transformation that a given STT would perform on an input. Or, given a transformation in English, we had to write our own state transition table.

So, I did what any other programmer would do - code it myself!

The STT must have 4 columns:
1. the current state
2. the character under the head
3. the next state
4. the action to perform

The action to perform can be 1 of 4 things:
1. erase the character under the head
2. replace the character under the head with another character
3. move the head left
4. move the head right

These are the basic actions of a turing machine.

The benefit of my program is that you can write you STT in a file, and the just run it through the program. The program will show you what the turing machine does with the input data step by step, so you can see in real time how it behaves. This makes it easy to validate that your STT does what you think it does.

The most difficult part, IMO, is handling the actual tape transformations. I will cover this in the next section.

## Approach

The naive approch to coding the tape transformations is to create a large `switch` block for each possible state, which in turn leads to a `switch` block for each possible symbol read in that state. The code for this would be easy to understand but very long. So long that it may in fact become unclear if I go back to refactor in a few years. I wanted a way to convey they same logic without the headache of managing massive blocks. Moreover, I needed a way to dynamically create these mappings no matter what states and symbols are passed to the turing machine.

To solve this issue, I observed that each row in a valid state transition table will have a unique combinations of (1) current state and (2) symbol read. Given this unique constraint, I used the joined string of `current state` plus `symbol read` as the key in an instruction lookup table. This way, I could create a dynamic table in just a few lines of code.

From there, there are only three options:
1. move the head left
2. move the head right
3. do something with the character under the head

And that is really all it takes to create the machine which can supposedly solve every computational problem ever.

As for data structures, it made sense to create 2 simple structs to make the code read better:
1. machine
2. instruction

The machine struct looks like this:
```go
type machine struct {
        state string
        halt  string
        head  int
}
```

It contains 3 fields for the current state, a boolean flag for halting, and the current index of the head.

The instruction struct looks like this:
```go
type instruction struct {
        next   string
        action string
}
```

It only contains the next state and the action to perform.


## Code Sample

I include the main loop here to demonstrate the logic of the program.

```go
func main() {
	// Parse command line args
	initial := flag.String("s", "s", "initial state symbol")
	halt := flag.String("h", "h", "halting state symbol")
	input := flag.String("i", "", "string representing input tape")
	file := flag.String("t", "table.csv", "path to CSV file of turing machine rules")
	flag.Parse()

	// Prepend the input tape with '^' for clearer visualisation
	tape := "^" + *input

	// Init the turing machine struct with the initial tape, halting symbol and the head at position 1
	m := machine{
		state: *initial,
		halt:  *halt,
		head:  1,
	}

	// Read the state transition table
	rules := readCsvFile(*file)

	// Parse the state transition table into a map of instructions
	table := make(map[string]instruction)
	for _, rule := range rules {
		// The key is the unique combination of the current state and the character read
		current := rule[0]
		read := rule[1]
		next := rule[2]
		action := rule[3]
		key := current + read
		table[key] = instruction{
			next:   next,
			action: action,
		}
	}

	// Clear the terminal, display the input tape, and wait
	clear()
	display(tape, m.head)
	wait(250)

	for {
		// Exit when the turing machine reaches the halting state
		if m.state == m.halt {
			break
		}

		// Clear the terminal
		clear()

		// Read the state and the character under the head together as a string
		rule := m.state + string(tape[m.head])
		// Given that string, pull the associated rules from the table
		result := table[rule]
		// Determine the next state
		m.state = result.next

		if result.action == "<-" { // Move the head to the left
			if m.head == 0 { // Throw error if the state transition table is buggy
				panic("attempted to move head past start of tape")
			}
			// Decrement the head position
			m.head--
		} else if result.action == "->" { // Move the head to the right
			if m.head == len(tape)-1 { // If the head moves past the end of the tape, we treat it as adding a blank space to the end of the tape
				tape += "_"
			}
			// Increment the head position
			m.head++
		} else { // Update or erase the character under the head
			tape = tape[:m.head] + result.action + tape[m.head+1:]
		}

		// Display the new state of the tape and wait
		display(tape, m.head)
		wait(250)
	}
}
```

## Source

Please find the full source code on my [GitHub](https://github.com/adamkgray/turingMachine). Have a nice day!