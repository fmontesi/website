<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Language{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}18 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

A **choreographic language** is a language for expressing [choreographies](Choreography) [[Montesi 2023](#M23)].
Key to choreographic languages is having a high-level primitive for expressing a communication between independent processes (also called roles, or participants). This is inspired by [security protocol notation](https://en.wikipedia.org/wiki/Security_protocol_notation) (also called 'Alice and Bob' notation), which presents the primitive

```
A -> B: M
```

for expressing the communication of a message `M` from `A` (Alice) to `B` (Bob) [[Needham and Schroeder 1978](#NS78)].

Choreographic languages can be roughly divided in two categories:
- Choreographic languages that include primitives for expressing computation, as often found in distributed applications, security protocols, etc. These are typically called [choreographic programming languages](ChoreographicProgramming).
- Choreographic languages without computation, aimed at expressing abstract specifications of protocols. Notable examples include [global types](#GlobalType), [BPMN choreographies](https://www.ibm.com/docs/en/rational-soft-arch/9.7.0?topic=diagrams-bpmn-choreography), and (at least in the way they are typically applied) [sequence diagrams](#SequenceDiagram).

Another possible source of categorisation: choreographic languages can be textual, graphical, or visual. Some examples are given next. In the remainder, `p`, `q`, `r`, `s`, etc. are process names.

Choreographic languages can be translated to executable distributed code or abstract models of participants by means of [endpoint projection](EndpointProjection).

## Examples of Choreographic Languages

### Languages in 'Introduction to Choreographies'

The book 'Introduction to Choreographies' [[Montesi 2023](#M23)] presents a series of choreographic languages of increased sophistication, aimed at the study of principles behind choreographies and [endpoint projection](EndpointProjection). They can be summarised as follows. We report their syntax in BNF format, adapted to ASCII.

Note that, in the examples on these pages, I sometimes take the liberty of omitting trailing `0`s and `else` branches.

#### Simple Choreographies<a id="SimpleChoreographies"></a>

```
(Choreographies)	C ::=	p -> q; C | 0
```

Notes:
- `p -> q` means '`p` communicates a message to `q`'. Message payloads are not specified in this language.
- A choreography in this language is essentially a finite list of communications.

#### Stateful Choreographies<a id="StatefulChoreographies"></a>

```
(Choreographies)	C ::=	I;C | 0
(Instructions)		I ::=	p.e -> q.x | p.x := e
(Expressions)		e ::=	v | x | f(e...)
```

Above, `v` ranges over values, `x` ranges over local variables, and `f` ranges over function names that are assumed to be defined in a separate language.
Each process is assumed to have a local memory store that maps variables to values.

Notes:
- `p.e -> q.x` means '`p` locally evalutes `e` and communicates the resulting value to `q`, which stores the value in its local variable `x`. 
- `p.x := e` means '`p` locally evaluates `e` and stores the result in its variable `x`'.
- In `f(e...)` the `e...` stands for a list of expressions, e.g., `e1, e2, e3`.

#### Conditional Choreographies<a id="ConditionalChoreographies"></a>

Augments the grammar of Stateful Choreographies with the production:
```
(Instructions)		I ::=	... | if p.e then C1 else C2
```

Notes:
- `if p.e then C1 else C2` reads 'if `p` evaluates `e` to the value `true`, proceed as `C1`, otherwise as `C2`'.
- Stateful Choreographies is sufficient to display the issue of [knowledge of choice](KnowledgeOfChoice).

#### Selective Choreographies<a id="SelectiveChoreographies"></a>

Augments the grammar of Conditional Choreographies with the production:
```
(Instructions)		I ::=	... | p -> q[L]
```

Notes:
- `p -> q[L]` means '`p` communicates the selection label `L` to `q`'.

#### Recursive Choreographies<a id="RecursiveChoreographies"></a>

Augments the grammar of Selective Choreographies with the production:
```
(Instructions)		I ::=	... | X(p...)
```

`X` ranges over procedure names, which are mapped to choreographies in a context of procedure definitions.

Notes:
- `X(p...)` means 'the processes `p...` enter procedure `X`'.

#### Tail-Recursive Choreographies<a id="TailRecursiveChoreographies"></a>

It is the fragment of Recursive Choreographies where procedure calls (`X(p...)`) and conditionals do not have continuations, i.e., they are always followed by a `0`.

### Choreographic Programming Languages<a href="ChoreographicProgrammingLanguage"></a>

A choreographic programming language is a choreographic language for expressing executable concurrent and distributed code. See [choreographic programming](ChoreographicProgramming).

### Global Types<a href="GlobalType"></a>

Global types are choreographies where communications define propositions about the transmitted data, instead of the computations used to produce or manipulate the data [[Honda et al. 2016](#HYC16)].
They are often used in theories of static verification for process calculi.

### Sequence Diagrams<a href="SequenceDiagram"></a>

Sequence diagram are visualisations of choreographies, where the timelines of participants are represented by vertical lines and their interactions by connecting horisontal lines. See [sequence diagrams on Wikipedia](https://en.wikipedia.org/wiki/Sequence_diagram).

## References

<a id="HYC16"></a>Honda, K., Yoshida, N., Carbone, M. [2016], 'Multiparty Asynchronous Session Types', _J. ACM 63(1): 9:1-9:67_. <https://doi.org/10.1145/2827695>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<a id="NS78"></a>Needham, Roger M., Schroeder, Michael D. [1978], 'Using Encryption for Authentication in Large Networks of Computers', _Commun. ACM 21(12): 993-999_. <https://doi.org/10.1145/359657.359659>

<!-- --> {{/content}}{{/fm-bliki.html}}