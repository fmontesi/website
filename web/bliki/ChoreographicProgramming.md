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

## Development

Choreographic programming was proposed as a programming paradigm in [[Montesi 2013](#M13p)], which is also where the term was coined.
The paradigm builds on and extends a series of previous theoretical results on the design of [choreographic languages](ChoreographicLanguage) and endpoint projection. For historical remarks and an introduction to theory of choreographies and their compilation, see [Introduction to Choreographies](/introduction-to-choreographies/) [[Montesi 2023](#M23)].


## Implementations

- [Chor](https://www.chor-lang.org/) [[Montesi 2013](#M13p); [Carbone and Montesi 2013](#CM13)]. The first prototype of choreographic programming. Supports typing choreographic programs with [global types](ChoreographicLanguage#GlobalType).
- [Choral](https://www.choral-lang.org) [[Giallorenzo et al. 2020](#GMP20)]. An object-oriented choreographic programming language that supports higher-order choreographies and compiles to libraries in Java.
- [AIOCJ](http://www.cs.unibo.it/projects/jolie/aiocj.html) [[Dalla Preda et al. 2017](#DGGLM17)]. A choreographic programming language that supports runtime adaptation. Compiles to code in the [Jolie programming language](https://www.jolie-lang.org/).
- hacc [[Cruz-Filipe et al. 2023](#CLM23)]. A compilation pipeline from choreographies to several programming languages with a certified phase from choreographies to an intermediate technology-agnostic representation.
- HasChor [[Shen et al. 2023](#SKK23)]. A library for choreographic programming in Haskell.


## Mechanisations

There are several mechanisations of choreographic programming in theorem provers.

- A Coq formalisation of the theory of synchronous tail-recursive choreographies presented in [Introduction to Choreographies](/introduction-to-choreographies/) [[Montesi 2023](#M23)] (up to Chapter 8) [[Cruz-Filipe et al. 2023](#CMP23)].
- A verified compiler of a choreographic programming language to CakeML [[Pohjola et al. 2022](#PGSN22)].
- A Coq formalisation of a choreographic programming language with (orchestrated) higher-order procedures [[Hirsch and Garg 2022](#HG22)].


## References
<a id="further-reading"></a>

<a id="CM13"></a>
Carbone, M., Montesi, F. [2013], 'Deadlock-freedom-by-design: multiparty asynchronous global programming', _POPL 2013_ 263-274. <https://doi.org/10.1145/2429069.2429101>

<a id="CLM23"></a>
Cruz-Filipe, L., Lugovic, L., Montesi, F. [2023], 'Certified Compilation of Choreographies with hacc', _Proc. FORTE_, to appear. arXiv: <https://doi.org/10.48550/arXiv.2303.03972>

<a id="CMP23"></a>
Cruz-Filipe, L., Montesi, F., Peressotti, M. [2023], 'A Formal Theory of Choreographic Programming', _J. Autom. Reason._ 67(2): 21. <https://doi.org/10.1007/s10817-023-09665-3>

<a id="DGGLM17"></a>
Dalla Preda, M., Gabbrielli, M., Giallorenzo, S., Lanese, I., Mauro, J. [2017], 'Dynamic Choreographies: Theory And Implementation', _Log. Methods Comput. Sci._ 13(2). <https://doi.org/10.23638/LMCS-13(2:1)2017>

<a id="GMP20"></a>
Giallorenzo, S., Montesi, F., Peressotti, M. [2020], 'Choral: Object-oriented Choreographic Programming', _CoRR abs/2005.09520_.
<https://arxiv.org/abs/2005.09520>

<a id="HG22"></a>
Hirsch, A. K., Garg, D. [2022], 'Pirouette: higher-order typed functional choreographies', _Proc. ACM Program. Lang._ 6(POPL): 1-27. <https://doi.org/10.1145/3498684>

<a id="M13p"></a>Montesi, F. [2013], 'Choreographic Programming', PhD Thesis, _IT University of Copenhagen_. <https://www.fabriziomontesi.com/files/choreographic-programming.pdf>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<a id="PGSN22"></a>
Pohjola, J. Å., Gómez-Londoño, A., Shaker, J., Norrish, M. [2022], 'Kalas: A Verified, End-To-End Compiler for a Choreographic Language', _Proc. ITP_ 2022: 27:1-27:18. <https://doi.org/10.4230/LIPIcs.ITP.2022.27>

<a id="SKK23"></a>
Shen, G., Kashiwa, S., Kuper, L. [2023], 'HasChor: Functional Choreographic Programming for All (Functional Pearl)', _Proc. ACM Program. Lang._ (ICFP), to appear. arXiv: <https://doi.org/10.48550/arXiv.2303.00924>

<!-- --> {{/content}}{{/fm-bliki.html}}
