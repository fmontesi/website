<!-- --> {{< fm-bliki.html}}{{$title}}Teaching with Introduction to Choreographies{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}31 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

<!-- Ever wondered how teaching concurrency theory would change if you adopted an 'intention-first' approach?
What if you always kept focus on defining and  focused first on the high-level structures that you wish to codify  -->

For the past few years I have been designing and following a new way of teaching concurrency theory, or even the integration of communicating participants in a concurrent or distributed system.
I call it the _choreography-first approach_.

<figure class="bliki-figure">
💡 Wanna study or teach with this approach? The book <a href="/introduction-to-choreographies">Introduction to Choreographies</a> is designed exactly to guide you through this method step by step, with nearly 100 examples and 100 exercises.
<br/>
💡 Wanna see what students thought of this in a course of mine? Check it out at <a href="#course-evaluation">the bottom of this page</a>.
</figure>

The idea is to start with high-level languages for expressing _what_ communication behaviour we wish for, rather than immediately diving into languages for expressing _how_ this behaviour should be implemented.
In other words, I teach [choreographies](Choreography) before [processes](https://en.wikipedia.org/wiki/Process_calculus).

If you think about it, choreographies are essentially the plans that we are trying to implement when we program a system based on message passing. So it can make sense to teach them as soon as possible, just like we typically start teaching programming with high-level languages instead of low-level bytecode or assembly.
However, most people keep choreographies as informal and vague objects in their heads instead of writing them down. This makes concurrency harder than it needs to be in a lot of cases.
This is why I start right away by equipping students with a formal language to write (very simple) choreographies. I call this language Simple Choreographies.

The name says it all: Simple Choreographies is really straightforward. It can just express a finite list of point-to-point communications. Here is its grammar.

<figure class="bliki-figure">

```
(Choreographies)	C ::=	p -> q; C					(communication)
						|	0							(empty choreography)
```

<figcaption>

The syntax of Simple Choreographies, from [Montesi [2023]](#M23).
</figcaption>
</figure>

A choreography, `C`, can have one of two forms:
- `p -> q; C`, read 'process `p` communicates a message to process `q`, and then the choreography proceeds as `C`';
- or `0`, which is the terminated choreography.

For example, we can write a choreography where a `client` communicates a message to a `proxy`, which then forwards it to a `server`:

```
client -> proxy; proxy -> server; 0
```

You 

<figure class="bliki-figure">

<img src="/images/itc-cover.png" height="200"/>

<figcaption>
</figcaption>
</figure>

The book [Introduction to Choreographies](/introduction-to-choreographies) 

is designed to give a linear and clear  propose a particular way of teaching concurrency theory and theory of concurrent and distributed programming languages.

<a id="course-evaluation"></a>
## What Do Students Think? A University Course Evaluation



## References

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}