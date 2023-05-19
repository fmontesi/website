<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Language{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}19 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

A **choreographic language** is a language for expressing [choreographies](Choreography) [[Montesi 2023](#M23)].
Key to choreographic languages is having a high-level primitive for expressing a communication between independent processes (also called roles, or participants). This is inspired by the ['Alice and Bob' notation of security protocols](https://en.wikipedia.org/wiki/Security_protocol_notation), which presents the primitive

```
A -> B: M
```

for expressing the communication of a message `M` from `A` (Alice) to `B` (Bob) [[Needham and Schroeder 1978](#NS78)].

Choreographic languages can be roughly divided in two categories:
- Choreographic languages that include primitives for expressing computation, as often found in distributed applications, security protocols, etc. These are typically called [choreographic programming languages](ChoreographicProgramming).
- Choreographic languages without computation, aimed at expressing abstract specifications of protocols. Notable examples include [global types](#GlobalType), [BPMN choreographies](https://www.ibm.com/docs/en/rational-soft-arch/9.7.0?topic=diagrams-bpmn-choreography), and (at least in the way they are typically applied) [sequence diagrams](#SequenceDiagram).

Another possible source of categorisation: choreographic languages can be textual, graphical, or visual. Some examples are given next. In the remainder, `p`, `q`, `r`, `s`, etc. are process names.

Choreographic languages can be translated to executable distributed code or abstract models of participants by means of [endpoint projection](EndpointProjection).

## Recursive Choreographies<a id="RecursiveChoreographies"></a>

An example of a choreographic language is the language of Recursive Choreographies [[Montesi 2023](#M23)]. I often refer to it examples in the other entries.

Recursive Choreographies is defined by the following grammar, in BNF format (the original presentation is adapted to ASCII here).
Note that, in the examples on these pages, I sometimes take the liberty of omitting trailing `0`s and `else` branches.

<figure class="bliki-figure">

```
(Choreographies)	C ::=	I;C							(sequence)
						|	0							(empty choreography)

(Instructions)		I ::=	p.e -> q.x					(value communication)
						|	p -> q[L]					(selection)
						|	p.x := e					(assignment)
						|	if p.e then C1 else C2		(conditional)
						|	X(p...)						(procedure call)

(Expressions)		e ::=	v							(value)
						|	x							(variable)
						|	f(e...)						(function call)
```

<figcaption>

The syntax of Recursive Choreographies [[Montesi 2023](#M23)].
</figcaption>
</figure>

In the syntax, `p` ranges over process names, `L` over selection labels (special ), `X` ranges over procedure names, `v` ranges over (data) values, `x` ranges over local variables, and `f` ranges over function names that are assumed to be defined in a separate language.
Each process is assumed to have a local memory store that maps variables to values.

A choreography `C` is essentially a list of instructions (`I`), terminated by `0`.
Instructions can be read as follows.
- `p.e -> q.x` reads '`p` locally evalutes `e` and communicates the resulting value to `q`, which stores the value in its local variable `x`. 
- `p -> q[L]` reads '`p` communicates the selection label `L` to `q`'. See [knowledge of choice](KnowledgeOfChoice) about the role of selections.
- `p.x := e` reads '`p` locally evaluates `e` and stores the result in its variable `x`'.
- `if p.e then C1 else C2` reads 'if `p` evaluates `e` to the value `true`, proceed as `C1`, otherwise as `C2`'.
- `X(p...)` means 'the processes `p...` enter procedure `X`'. `p...` stands for a list of process names, e.g., `p, q, r`. Procedures are mapped to choreographies in a context of procedure definitions, and can be recursive.

## Choreographic Programming Languages<a id="ChoreographicProgrammingLanguage"></a>

A choreographic programming language is a choreographic language for expressing executable concurrent and distributed code. See [choreographic programming](ChoreographicProgramming).
Recursive Choreographies is a choreographic programming language.

## Global Types<a id="GlobalType"></a>

Global types are choreographies where communications define propositions about the transmitted data, instead of the computations used to produce or manipulate the data [[Honda et al. 2016](#HYC16)].
They are often used in theories of static verification for process calculi.

Languages for global types are typically similar to Recursive Choreographies, with some notable key differences:
- Value communication specifies the type of the transmitted message (e.g., an integer), instead of the expression and variable used for computing and storing the message.
- There is no assignment instruction.
- Conditionals are nondeterministic choices, e.g., `C1 + C2`.

## Sequence Diagrams<a id="SequenceDiagram"></a>

Sequence diagram are visualisations of choreographies, where the timelines of participants are represented by vertical lines and their interactions by connecting horisontal lines. See [sequence diagrams on Wikipedia](https://en.wikipedia.org/wiki/Sequence_diagram).

Tools for sequence diagrams typically give a lot of freedom in what can be written about interactions, so the choice of including computation or not can be left to the user.

## References

<a id="HYC16"></a>Honda, K., Yoshida, N., Carbone, M. [2016], 'Multiparty Asynchronous Session Types', _J. ACM 63(1): 9:1-9:67_. <https://doi.org/10.1145/2827695>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<a id="NS78"></a>Needham, Roger M., Schroeder, Michael D. [1978], 'Using Encryption for Authentication in Large Networks of Computers', _Commun. ACM 21(12): 993-999_. <https://doi.org/10.1145/359657.359659>

<!-- --> {{/content}}{{/fm-bliki.html}}