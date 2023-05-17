<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Programming{{/title}}{{$content}}

(This page is still under heavy construction. Come back soon!)

**Choreographic Programming** is a programming paradigm where programs are [choreographies](Choreographies) [[Montesi 2013](#M13p)].
A choreographic programming language is a special case of a [choreographic language](ChoreographicLanguage).
A program given in a choreographic programming language is called choreographic program, or simply choreography when it is clear from the context.

Choreographic programming languages are typically accompanied by a compiler, which translates choreographies into executable code for concurrent and distributed systems. The theory of [endpoint projection](EndpointProjection) (EPP for short) usually plays an important role in such compilers, in addition to the details of the target executable language.

Choreographic programming was pioneered in [[Montesi 2013](#M13p)], but the principles of endpoint projection were studied before. See [[Montesi 2023](#M23)] for an overview and an introduction.
The name 'endpoint projection' was originally introduced by [Carbone et al [2012]](#CHY12).

## Implementations

- [Choral](https://www.choral-lang.org). An object-oriented choreographic programming language that supports higher-order choreographies and compiles to libraries in Java. Arguably the most applicable choreographic programming language so far.
- [AIOCJ](http://www.cs.unibo.it/projects/jolie/aiocj.html). A choreographic programming language that supports runtime adaptation. Compiles to code in the Jolie programming language.
- [Chor](https://www.chor-lang.org/)

AIOCJ (website).[5] A choreographic programming language for adaptable systems that produces code in Jolie.
Chor (website).[4] A session-typed choreographic programming language that compiles to microservices in Jolie.
Choral (website). A higher-order, object-oriented choreographic programming language that compiles to libraries in Java.
Core Choreographies.[15] A core theoretical model for choreographic programming. A mechanised implementation is available in Coq.[16][17]
Kalas.[18] A choreographic programming language with a verified compiler to CakeML.
Pirouette.[7] A mechanised choreographic programming language theory with higher-order procedures.

- Choral, 

## Mechanisations

There exist several mechanisations of choreographic programming in theorem provers.

## References
<a id="further-reading"></a>

<a id="CHY12"></a>Carbone, M., Honda, K., Yoshida, N. [2012],
'Structured Communication-Centered Programming for Web Services', _ACM Trans. Program. Lang. Syst._ 34(2): 8:1-8:78. <https://doi.org/10.1145/2220365.2220367>

<a id="M13p"></a>Montesi, F. [2013], 'Choreographic Programming', PhD Thesis, _IT University of Copenhagen_. <https://www.fabriziomontesi.com/files/choreographic-programming.pdf>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

Wikipedia Authors, 'Choreographic Programming', _Wikipedia_. <https://en.wikipedia.org/wiki/Choreographic_programming>

<!-- --> {{/content}}{{/fm-bliki.html}}