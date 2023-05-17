<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Language{{/title}}{{$content}}

(This page is still under heavy construction. Come back soon!)

A **choreographic language** is a language for expressing [choreographies](Choreography).

Choreographic languages can be textual, graphical, or visual. Some examples are given next. In the remainder, `p`, `q`, `r`, `s`, etc. are process names.

## Languages in 'Introduction to Choreographies'

The book 'Introduction to Choreographies' [[Montesi 2023](#M23)] presents a series of choreographic languages of increased sophistication, aimed at the study of principles behind choreographies and [endpoint projection](EndpointProjection). They can be summarised as follows. We report their syntax in BNF format, adapted to ASCII.

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


## References



<!-- --> {{/content}}{{/fm-bliki.html}}