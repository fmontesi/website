<!-- --> {{< fm-bliki.html}}{{$title}}Teaching with 'Introduction to Choreographies'{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}31 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

<!-- Ever wondered how teaching concurrency theory would change if you adopted an 'intention-first' approach?
What if you always kept focus on defining and  focused first on the high-level structures that you wish to codify  -->

For the past few years I have been experimenting with a different way of teaching concurrency theory, or even the integration of communicating participants in a concurrent or distributed system.
I call it the _choreography-first approach_. It's the soul behind [the book](/introduction-to-choreographies/) that I've recently written about theory of choreographic languages.

<figure class="bliki-figure bg-data-chor">
<ul class="mb-0 bliki-tip-list">
<li>
Wanna study or teach by following this approach? The book <a href="/introduction-to-choreographies/">Introduction to Choreographies</a> is designed exactly to guide you through this method step by step, with nearly 100 examples and 100 exercises.
</li>
<li>
Curious of what students think of this? Check out the highlights of a <a href="#course-evaluation">course evaluation at the bottom of this page</a>.
</li>
</ul>
</figure>

## The approach

The idea is to start with high-level languages for expressing _what_ communication behaviour we wish for, rather than immediately diving into languages for expressing _how_ this behaviour should be implemented.
In other words, I teach formal languages for expressing [choreographies](Choreography) before those for modelling local behaviours (e.g., [process calculi](https://en.wikipedia.org/wiki/Process_calculus)).

Choreographies represent the plans that we are trying to implement when we program a system based on message passing. So it can make sense to teach them as soon as possible, just like we typically start teaching programming with high-level languages instead of low-level bytecode or assembly. Intention and design over implementation details.

However, many people keep choreographies as informal and vague objects in their heads instead of writing them down. This makes concurrency harder than it needs to be in a lot of cases.
This is also why I start right away by equipping students with a formal language to write (very simple) choreographies. I call this language Simple Choreographies.

<!-- <figure class="bliki-figure">
<ul class="mb-0 bliki-tip-list">
<li>Outside of concurrency theory, this is actually pretty common practice. For example, think of when we teach introductory programming courses. Under the hood, a computer consists of multiple components like CPUs, their caches, RAM, hard drives, etc. These components interact in nontrivial ways to implement the computations that we write in high-level languages, but all of this is typically hidden away.</li>
</ul>
</figure> -->

### Simple Choreographies

The name says it all: Simple Choreographies is really straightforward. It can just express a finite list of point-to-point communications. Here is its grammar, where `p` and `q` range over process names.

<figure class="bliki-figure">

```bnf
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

Simple Choreographies is so simple that all choreographies express finite protocols, there are no ways of expressing alternative behaviour, and there is no state. In fact, we are not even writing what the payloads of messages are! However, Simple Choreographies is interesting enough that it can be given a concurrent semantics by using out-of-order execution. This semantics corresponds to parallelism at the process level [[Montesi 2023]](#M23).

More interesting things happen once we introduce the language for implementing Simple Choreographies, described next.

### Simple Processes

Simple Processes is the process calculus counterpart to Simple Choreographies. That is, we use it to describe implementations of these choreographies. The syntax is, again, rather simple:

<figure class="bliki-figure">

```bnf
(Processes)		P ::=	p!; P		(send)
					|	p?; P		(receive)
					|	0			(empty process)
```

<figcaption>

The syntax of Simple Processes [[Montesi 2023]](#M23).
</figcaption>
</figure>

A process can be either:
- `p!;P`, read 'send a message to `p` and then do `P`';
- `p?;P`, read 'receive a message from `p` and then do `P`';
- or `0`, the terminated process.

You can put processes together in networks, ranged over by `N`, which are written `p[P] | q[Q] | ...`.
For example, the implementation of our previous choreography:

```
client[proxy!; 0] | proxy[client?; server!; 0] | server[proxy?; 0]
```

### Safety and Liveness

Simple Choreographies and Simple Processes are simple, but not trivial.
In particular, given appropriate operational semantics, they suffice for discussing the notions of parallelism and interleaving.

More importantly, there are some interesting differences between the two languages for (high-level) choreographies and (low-level) processes.
For example, using Simple Processes, we can:
- Illustrate safety issues, like two processes trying to communicate via incompatible actions.
- Exemplify liveness issues, like a network of processes getting stuck.
- Formulate general statements of safety and liveness properties.
- Show the difference between these properties.

In Simple Choreographies, these issues do not really present themselves. The syntax of communications in choreographies always pairs correctly the intended send and receive actions. This means that all correct implementations of a choreography in Simple Processes can never reach an unsafe state or get stuck, which is one of the cornerstone results of the choreographic method.

### Going Forward

Showing Simple Choreographies, Simple Processes, their differences, and their relationship establishes a mental framework that comprises how to define intentions (choreographies) and the challenges that await us in the implementation of these intentions (as processes).

From there, I start extending these languages with more features that make them more realistic, like message payloads, memory, conditionals, nondeterminism, recursion, etc.
The two layers, choreographies and processes, are kept in sync with respect to features. This is important because some features present their own unique challenges. A prime example is [knowledge of choice](KnowledgeOfChoice): introduce choices, and suddenly you have to deal with agreement.

<a id="course-evaluation"></a>

## Opinions from the course 'Concurrency Theory'

The choreography-first approach is the result of years of teaching both concurrency theory (MSc level) and concurrent programming (BSc level) in higher education. (There's a lot to be said also about research and professional work, but let's stick to teaching here.)
My admittedly personal experience is that putting choreographies at the forefront in the beginning and then keeping them side to side with processes gives students a clearer sense of what we are doing and why. After seeing mechanical methods for translating choreographies into processes for a while ([endpoint projection](ChoreographicProgramming#EndpointProjection)), they start applying the same principles in their heads while looking at examples. How do I know? Sometimes they correct me when I write processes on the blackboard... ;-)

How do students feel about it? Here are some of the comments that my students left in the evaluation of the first course I taught by using the book. (DM861: Concurrency Theory, University of Southern Denmark, Spring 2023.)

- 'The teaching methods were really unique and interesting.'
- 'Fun and engaging lectures with easy to follow examples and explanations.'
- 'I really enjoyed the course.'
- '[...] a very interesting course taught on very modern methods and examples.'
- '[...] unique and effective.'
- '[...] very interesting lectures.'


## References

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}