<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Programming{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}12 June 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a> and <a href="https://en.wikipedia.org/wiki/Choreographic_programming">Choreographic Programming (Wikipedia)</a>.{{/subHeader}}{{$content}}

**Choreographic Programming** is a programming paradigm where programs are [choreographies](Choreography) [[Montesi 2013](#M13p)].
A choreographic programming language is a special case of a [choreographic language](ChoreographicLanguage).
A program given in a choreographic programming language is called choreographic program, or simply choreography when it is clear from the context.

<figure class="bliki-figure">

```
Alice.modPow(g, a, p) -> Bob.x;
Bob.modPow(g, b, p) -> Alice.y;
```

<figcaption>

A snippet of the [Diffie-Hellman protocol for key exchange](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange), given in the language of [Recursive Choreographies](ChoreographicLanguage#RecursiveChoreographies).
</figcaption>
</figure>

<a id="epp"></a>
## Endpoint Projection (EPP)

Choreographic programming languages are typically accompanied by a compiler, which translates choreographies into executable code for concurrent and distributed systems [[Montesi 2023](#M23)]. The theory of endpoint projection (EPP for short) usually plays an important role in such compilers, in addition to the details of the target executable language.


<figure class="bliki-figure">

<div class="row">
<div class="col-auto">

Code for `Alice`:
```
send modPow(g, a, p) to Bob;
recv y from Bob;
```
</div>
<div class="col-auto">

Code for `Bob`:
```
recv x from Alice;
send modPow(g, b, p) to Alice;
```
</div>
</div>

<figcaption>

Implementations of `Alice` and `Bob` compiled from the previous choreography, given in pseudocode.
</figcaption>
</figure>

In general a choreography might involve many participants, so EPP must be able to distribute code onto many target programs.

Ideally, EPP should not produce executable code that requires central control (choreographies are [intended to be decentralised](Choreography#Decentralised)).
This introduces an interesting challenge known as [knowledge of choice](KnowledgeOfChoice), which deals with ensuring that processes agrees on the alternative behaviours selected during the execution of the choreography.

<!-- ## Implementations

Choreographic programming was formulated as a programming paradigm and prototyped in [[Montesi 2013](#M13p)].

The name 'endpoint projection' was originally introduced by [Carbone et al. [2012]](#CHY12), for a theory inspired by the specification language of  .

## Implementations

- [Chor](https://www.chor-lang.org/). The first prototype of choreographic programming. Supports typing choreographic programs with [global types](ChoreographicLanguage#GlobalType).
- [Choral](https://www.choral-lang.org). An object-oriented choreographic programming language that supports higher-order choreographies and compiles to libraries in Java. Arguably the most applicable choreographic programming language so far.
- [AIOCJ](http://www.cs.unibo.it/projects/jolie/aiocj.html). A choreographic programming language that supports runtime adaptation. Compiles to code in the Jolie programming language.
- hacc. A partially-certified compilation pipeline from choreographies to several programming languages.
- HasChor. A library for choreographic programming in Haskell.


## Mechanisations

There exist several mechanisations of choreographic programming in theorem provers.

- A formalisation of [tail-recursive choreographies](ChoreographicLanguage#TailRecursiveChoreographies)

Core Choreographies.[15] A core theoretical model for choreographic programming. A mechanised implementation is available in Coq.[16][17]
Kalas.[18] A choreographic programming language with a verified compiler to CakeML.
Pirouette.[7] A mechanised choreographic programming language theory with higher-order procedures.

-->

## References
<a id="further-reading"></a>

<a id="M13p"></a>Montesi, F. [2013], 'Choreographic Programming', PhD Thesis, _IT University of Copenhagen_. <https://www.fabriziomontesi.com/files/choreographic-programming.pdf>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}
