# print() is better than a debugger IRL

```{image} ./meme.png
:width: 15em
:align: left
```

_08.05.2022_

Debuggers are a sophisticated way to resolve issues in your code, but I rarely use them. Instead, I do the meme. I add `print()` statements. Tbh, it really is better.

If you aren't familiar with them, debuggers are tools which halt the execution of your code and drop you into a live environment. The whole idea is that you can interact with usually inaccessible local variables mid-execution. This sojourn into code-world helps you interrogate each object to confirm that it is doing what you think it should be doing. It helps you find your mistakes quickly and efficiently. Most high-level programming languages have debuggers. For Go there is `delve`. For JS there is the `debugger` keyword. And for Python there is now `pdb` (although it used to be `IPython` which has since evolved into project Jupyter).


When I was at [Launch Academy](https://launchacademy.com/), we learned Ruby and its popular debugger `pry`. If our code did not behave as expected, we were encouraged to `require pry` and then call `binding.pry` just before where the things went haywire. At the time, we were mostly writing simple scripts to be executed in the terminal. Later we started writing webservers with Sinatra. Throughout, the debugger did help debug my code efficiently.

But after leaving the bootcamp, I never used the bebugger again. In this post, I reflect on why that is.

### 1. The code is often not the problem

Post-bootcamp, I started working at Publishers Clearing House as a full-stack developer. I found that my ability to code augmented quickly, and the time I spent debugging code dimished. What I ended up doing more, was debugging whole systems.

At a certain point, maybe after 2 years, you get really comfortable with a language. This is especially true if the language is high-level, like Python, Ruby, JS or Go. It flows out of your fingertips and into the keyboard like a second language. You can translate most problems into well-known sub-problems that you have already solved many times before. And if there is an error, you can just read the error message and make a change.

The difficulty then becomes fitting your program into a larger system. Taken to a logical extreme, it is _working with other people_ that is the problem. In a professional setting, it is assumed everyone can write decent code. So, the harder part is gluing it together.

### 2. Debuggers are not collaborative

Debuggers can only be used by one person to solve one problem at a time. If you want to build something really really good, then you have to work with other people. The chances of you all huddling around one monitor, playing hot seat with the keyboard, and tag-teaming the debugger are low. It is better to have something you can all look at individually, at your own pace, in your own time.

### 3. Debuggers aren't for production

Unless your team is chill with breaking prod just to see what `M[i][j]` is on a REPL, you cannot use a debugger in prod. In fact, you shouldn't even do it in staging or dev either. Chances are your team doesn't have a lot of money, there is no dedicated solutions architect, and you all have to play nice in a limited set of environments. Delaying your teammates work to poke around in a debugger just doesn't make sense. Moreover, you probably can't even use a debugger in your prod setting. For example, if you are debugging a web services, the it's a liability to give any human direct access to a server.

### 4. The deepest bugs are the hardest to replicate

If a piece of code is throwing are error every time it runs, chances are you already caught it before you shipped it. The really nasty errors are the ones that happen randomly and for reasons you can't explain. Where do you put the debugger if you don't even know where to look? It is like trying to catch a fish with your bare hands in the middle of the ocean at night.

## So what do?

All software should produce a log file. This is the way to debug.

The log file asserts what the programmer thinks the application should do at each stage. Seasoned developers will know where the application is most likely to break, and put extra extra logs there. And since the logs will be in prod, by extension they will be in dev too. So what do you need the debugger for?

Logs are collarborative. Logs work in production. Logs capture all events.

And if you are developing on your own machine and want to quickly see if something works, I promise that throwing in a `print()` statement is genuinely the fastest way to find out.

Interesting, my bootcamp never taught us to use logs. We wrote complete react-on-rails apps without a single log anywhere. Can you imagine!?

In sum, my feeling is that the use-case for debuggers is limited. If you want to do anything of substance, then you have to do logs. And if you're logging, it's not unreasonable to put a cheeky `print()` in the code while you are developing. After 5 or so years working in professional software development, I can say that this is the way to do it.









