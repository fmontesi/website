<!-- --> {{< fm-bliki.html}}{{$title}}Teaching with Introduction to Choreographies{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}31 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

<!-- Ever wondered how teaching concurrency theory would change if you adopted an 'intention-first' approach?
What if you always kept focus on defining and  focused first on the high-level structures that you wish to codify  -->

For the past few years I have been experimenting with an original way of teaching concurrency theory, or even the integration of communicating participants in a concurrent or distributed system.
I call it the _choreography-first approach_.

<figure class="bliki-figure">
<ul class="mb-0 bliki-tip-list">
<li>
Wanna study or teach by following this approach? The book <a href="/introduction-to-choreographies">Introduction to Choreographies</a> is designed exactly to guide you through this method step by step, with nearly 100 examples and 100 exercises.
</li>
<li>
Curious of what students think of this? Check out the highlights of a <a href="#course-evaluation">course evaluation at the bottom of this page</a>.
</li>
</ul>
</figure>

The idea is to start with high-level languages for expressing _what_ communication behaviour we wish for, rather than immediately diving into languages for expressing _how_ this behaviour should be implemented.
In other words, I teach formal languages for expressing [choreographies](Choreography) before those for modelling local behaviours (e.g., [process calculi](https://en.wikipedia.org/wiki/Process_calculus)).

Choreographies represent the plans that we are trying to implement when we program a system based on message passing. So it can make sense to teach them as soon as possible, just like we typically start teaching programming with high-level languages instead of low-level bytecode or assembly. Concepts over implementation details.

However, many people keep choreographies as informal and vague objects in their heads instead of writing them down. This makes concurrency harder than it needs to be in a lot of cases.
This is also why I start right away by equipping students with a formal language to write (very simple) choreographies. I call this language Simple Choreographies.

## Simple Choreographies 
The name says it all: Simple Choreographies is really straightforward. It can just express a finite list of point-to-point communications. Here is its grammar, where `p` and `q` range over process names.

<figure class="bliki-figure">

```
(Choreographies)	C ::=	p -> q; C		(communication)
						|	0				(empty choreography)
```

<figcaption>

The syntax of Simple Choreographies [[Montesi 2023]](#M23).
</figcaption>
</figure>

A choreography, `C`, can have one of two forms:
- `p -> q; C`, read 'process `p` communicates a message to process `q`, and then the choreography proceeds as `C`';
- or `0`, which is the terminated choreography.

For example, we can write a choreography where a `client` communicates a message to a `proxy`, which then forwards it to a `server`:

```
client -> proxy; proxy -> server; 0
```

This corresponds to the following sequence diagram.

<pre class="mermaid">
sequenceDiagram
	client->>proxy: -
	proxy->>server: -
</pre>

Simple Choreographies is so simple that all choreographies express finite protocols, there are no ways of expressing alternative behaviour, and there is no state. In fact, we are not even writing what the payloads of messages are! However, Simple Choreographies is interesting enough that it can be given a concurrent semantics by using out-of-order execution. This semantics corresponds to parallelism at the process level.

Much more interesting things happen once we introduce the language for implementing Simple Choreographies, described next.

## Simple Processes

Simple Processes is the process calculus equivalent to Simple Choreographies. We use it to describe implementations of these choreographies. The syntax is rather simple:

<figure class="bliki-figure">

```
(Processes)		P ::=	p!; P		(send)
					|	p?; P		(receive)
					|	0			(empty process)
```

<figcaption>

The syntax of Simple Processes [[Montesi 2023]](#M23).
</figcaption>
</figure>

A process can either be:
- `p!;P`, read 'send a message to `p` and then do `P`';
- `p?;P`, read 'receive a message from `p` and then do `P`';
- or `0`, the terminated process.

You can put processes together in networks, ranged over by `N`, which are written `p[P] | q[Q] | ...`.
For example, the implementation of our previous choreography:

```
client[proxy!; 0] | proxy[client?; server!; 0] | server[proxy?; 0]
```



is designed to give a linear and clear  propose a particular way of teaching concurrency theory and theory of concurrent and distributed programming languages.

<a id="course-evaluation"></a>
## What Do Students Think? A University Course Evaluation



## References

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}