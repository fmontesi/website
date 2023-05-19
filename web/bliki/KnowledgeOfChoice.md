<!-- --> {{< fm-bliki.html}}{{$title}}Knowledge of Choice{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}18 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

A [choreography](Choreography) has the **knowledge of choice** property if it ensures that all participants are aware of which alternative behaviours are chosen at runtime [[Montesi 2023](#M23)]. The name 'knowledge of choice' was introduced by [Castagna et al. [2012]](#CDP12) in the context of multiparty session types, but the problem is older and applies to all [choreographic languages](ChoreographicLanguage).

## The problem

Consider the following choreography for [single-sign on](https://en.wikipedia.org/wiki/Single_sign-on). A client (`c`) communicates some credentials to an authenticator (`a`), which then decides if a web service (`ws`) should communicate a new session token to the client. In the negative case, the web service should communicate a special `NoToken` value to the client, denoting failure.


<figure class="fm-figure">

```
c.credentials -> a.x;
if a.valid(x) then
	ws.newToken() -> c.token
else
	ws.NoToken -> c.token
```

<figcaption>

A simplistic choreography for single-sign on, given in the language of [Recursive Choreographies](ChoreographicLanguage#RecursiveChoreographies). As we are going to see, there is a problem with this choreography.
</figcaption>
</figure>

<figure class="fm-figure">

<pre class="mermaid">
sequenceDiagram
	participant c
	participant a
	participant ws
	c->>a: credentials
	alt a.valid(credentials)
		ws->>c: newToken()
	else
		ws->>c: NoToken
	end
</pre>

<figcaption>

The same choreography, but given as a [sequence diagram](ChoreographicLanguage#SequenceDiagram).
</figcaption>
</figure>

There is a problem here. The behaviour of `ws` depends on the internal choice made by `a` regarding `c`'s credentials.
In other words, **`ws` needs to know about `a`'s choice**.
However, there is no communication that ever reaches `ws` carrying information about `a`'s choice.

Therefore, this choreography does not ensure knowledge of choice.
While there is nothing wrong with this in principle, lack of knowledge of choice can be very relevant in practice. For example, here, the implementor of the choreography will be forced to develop some mechanism by which `ws` gets to know about `a`'s choice. This can have bad consequences:
- The implementor might decide to add extra communications in the implementation, for example the communication of a Boolean from `a` to `ws` that would inform `ws` about `a`'s choice. But this would entail that the choreography would not be representative anymore, since the implementation would enact unforeseen communications.
- The implementor might decide to use hidden side-effects that break decentralisation or introduce tight coupling. For example, one could use a shared database to store `a`'s choice (`a` would write it and `ws` would read it).

A better solution is to fix the choreography, such that it remains representative and.

## Achieving knowledge of choice

Fixing our choreography is relatively simple. We just need to add communications that allow `ws` to infer what it should do. Here is the resulting choreography, both in textual and visual forms.

<figure class="fm-figure">

```
c.credentials -> a.x;
if a.valid(x) then
	a -> c[OK];
	ws.newToken() -> c.token;
else
	a -> c[KO];
	ws.NoToken -> c.token;
```

<pre class="mermaid text-center">
sequenceDiagram
	participant c
	participant a
	participant ws
	c->>a: credentials
	alt a.valid(credentials)
		a->>ws: OK
		ws->>c: newToken()
	else
		a->>ws: KO
		ws->>c: NoToken
	end
</pre>

<figcaption>

The corrected version of the previous choreography, which now ensures knowledge of choice.
</figcaption>
</figure>

Compared to the previous choreography, we have added two selections.
A selection is a communication that carries a constant value. In practice, it is usually an instance of an enumerated type.
In the then-branch, `a` communicates the label `OK` to `ws`, whereas in the else-branch the communicated label is `KO`.
This means that the implementation of `ws` can now operate as follows:
1. Receive a label from `a`.
2. If the received label is `OK`, then send `newToken()` to `c`. Otherwise, if the received label is `KO`, then send `NoToken` to `c`.

This behaviour can be easily implemented with a local switch construct at `ws` (or an equivalent construction in whatever language the implementation of `ws` is written). In pseudocode:
```
// Implementation of ws

switch( recv from a ) {
case OK:
	send newToken() to c;
case KO:
	send NoToken to c;
}
```


## Amendment

The transformation of a choreography into one that guarantees knowledge of choice is called **amendment**, or **repair**.
There exist automatic procedures for amendment, for example in [[Basu and Bultan 2016](#BB16); [Cruz-Filipe and Montesi 2020](#CM20); [Lanese et al. 2013](#LMZ13)]. At least one is formalised in the Coq theorem prover [[Cruz-Filipe and Montesi 2023](#CM23)].

## Additional notes

- Some [choreographic programming](ChoreographicProgramming) frameworks avoid the problem of knowledge of choice by adding extra communications in implementations, e.g., see [[Dalla Preda et al. 2017](#DGGLM17); [Shen et al. 2023](#SKK23)]. That is, the code compiled for choreographic conditionals include instructions that broadcast the choice made to all other processes. While this is a suboptimal solution, it is simple and remains predictable, so one could argue that the choreography is still representative in this case (choreographic conditionals in this case should be read as both a local choice and a set of communications).

## References

<a id="BB16"></a>Basu, S., Bultan, T. [2016], 'Automated Choreography Repair', _Proceedings of FASE 2016_. <https://doi.org/10.1007/978-3-662-49665-7_2>

<a id="CDP12"></a>Castagna, G., Dezani-Ciancaglini, M. & Padovani, L. [2012], 'On global types and multi-party session', _Log. Methods Comput. Sci._ 8(1). <https://doi.org/10.2168/LMCS-8(1:24)2012>

<a id="CM23"></a>Cruz-Filipe, L., Montesi, F., 'Now It Compiles! Certified Automatic Repair of Uncompilable Protocols', _Proceedings of ITP 2023_. <https://doi.org/10.48550/arXiv.2302.14622>

<a id="DGGLM17"></a>Dalla Preda, M., Gabbrielli, M., Giallorenzo, G., Lanese, I., Mauro, J. [2017], 'Dynamic Choreographies: Theory And Implementation', _Log. Methods Comput. Sci._ 13(2). <https://doi.org/10.23638/LMCS-13(2:1)2017>

<a id="LMZ13"></a>Lanese, I., Montesi, F., Zavattaro, G. [2013], 'Amending Choreographies', _Proceedings of WWV 2013_. <https://doi.org/10.4204/EPTCS.123.5>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<a id="SKK23"></a>Shen, G., Kashiwa, S., Kuper, L. [2023], 'HasChor: Functional Choreographic Programming for All (Functional Pearl)', _CoRR abs/2303.00924_. <https://doi.org/10.48550/arXiv.2303.00924>

<!-- --> {{/content}}{{/fm-bliki.html}}
