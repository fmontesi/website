<!-- --> {{< fm-bliki.html}}{{$title}}CSLib: Library-Grade Computer Science{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$content}}

<figure class="bliki-figure">

<img src="/images/cslib-logo-lines-white.svg" class="img-fluid"/>

<figcaption>

[CSLib](https://cslib.io)'s logo.
</figcaption>
</figure>

[**CSLib**](https://cslib.io) is the Lean Computer Science Library, a project we started with the aim of building a shared formal infrastructure for computer science and verified programming [[Barrett et al., 2026](#cslib); [Henson and Montesi, 2026](#cslib-spine)].

At the time of this writing, CSLib has recently reached its 1000th pull request (code contribution submission). That feels like a good occasion to reflect on a central question that pervades the library and I as lead maintainer often have to think about: when is a formalisation 'good' for CSLib?
The answer is multifaceted. It should be correct, of course. It should be well designed, maintainable, and useful. But none of these quite capture a clear guideline, and we always gotta leave room for realism and allow for incremental improvement – often, making CSLib-quality code requires inventing new things!
So we are not talking about hard requirements; we are talking about an aspiration, a vision.

Now, since CSLib aims to be a shared infrastructure for computer science and programming, I think that a better formulation of the question is:

> What does it mean to do **library-grade** computer science?

A central part of the answer is reuse.
Not just software reuse in the ordinary sense, but reuse of formalised knowledge: definitions, abstractions, theorems, interfaces, and automation that facilitate future developments.
**The key idea is that knowledge and tools should compound into powerful infrastructure, rather than merely accumulate.**

I find a distinction from the literature on software reuse useful. <a href="#pd93">Prieto-Díaz [1993]</a> distinguishes between:
- _vertical reuse_, within the same domain or application area; and
- _horizontal reuse_, where generic components are reused across different applications and domains.

Let's unfold this a bit in the context of formal computer science. As a running example, I'll stick to our recent development of a generic framework for modal logic in CSLib [[Girlando and Montesi, 2026](#gm26)].

## Vertical Reuse

The goal of vertical reuse is that specialised developments should inherit as much as possible from more general ones.

In the example of modal logic, there is an entire family of logics that use modalities to achieve different things: basic modal logic, temporal logics, Hennessy–Milner Logic, provability logics, epistemic logics, and so on. The surface languages and semantics of these logics have many common ideas, but they formally differ.
In the words of [Blackburn et al. [2001]](#brv01) in their textbook:

<blockquote>
	<p>‘Ask three modal logicians what modal logic is, and you are likely to get at least three different answers.’</p>
	<span class="big-quote-author">Patrick Blackburn, Maarten de Rijke, Yde Venema, ‘<a href="#brv01">Modal Logic</a>’.</span>
</blockquote>

For CSLib, however, we want to ask the question:

> How much of the theory can be formalised once and then reused?

We were not ready to deal with this question right off the bat. Logic has some common abstractions (like inference systems, logical equivalence, and more) that we had to explore through simpler cases first. Recently, we had formalised Hennessy–Milner logic in a way that integrates well with CSLib's abstractions [[Montesi et al., 2026](#cslib-hml)] and, likewise, basic modal logic.
At this point we could reason about statements like the following, using separate developments.

<figure class="bliki-figure">

<img src="/images/unimodal-axiom-dual.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<img src="/images/hml-axiom-dual.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<figcaption>

Duality of the diamond and box modalities in basic modal logic (first image), and duality of the 'dynamic' (or indexed) diamond and box modalities in Hennessy-Milner Logic (second image).
</figcaption>
</figure>

We then turned our attention to the textbook generic framework for modal languages [[Blackburn et al., 2001](#brv01)], in the hope of unifying some developments.
This formalisation effort led us to develop generalised properties and a hierarchy of abstractions that allow for deriving more specialised modal interfaces.

Basic modal logic, basic temporal logic, and Hennessy–Milner Logic can be obtained by specialising this common infrastructure, inheriting semantics and shared metatheory.
For example, both of the previous axioms about duality are direct consequences of the more general duality axiom for generic modal logic, given next.

<figure class="bliki-figure">

<img src="/images/modal-axiom-dual.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<figcaption>

Duality of 'triangles' and 'nablas' in generic modal logic. This axiom subsumes the previous two for basic modal logic and Hennessy-Milner Logic.
</figcaption>
</figure>

I particularly like the example of how Hennessy–Milner logic looks before and after; that is, the ad hoc implementation versus the one derived from the general framework. Factoring out generic parts led to a 67% reduction in logic-specific code, and all useful instances are obtained completely automatically. Not only did we get a leaner codebase, we even got new features: the new implementation inherits the possibility of having atomic propositions.

<figure class="bliki-figure">

<img src="/images/gm26-table.jpeg" class="img-fluid"/>

<figcaption>

Code statistics on the formalisation of Hennessy–Milner logic in CSLib, before and after the introduction of the generic modal framework. Source: [[Girlando and Montesi, 2026](#gm26)].
</figcaption>
</figure>

In general, when a new development belongs to an existing family, it should inherit the knowledge we already have about that family rather than reproduce it.

## Horizontal Reuse

In horizontal reuse, the goal is not to derive another member of the same family, but to make an abstraction useful somewhere else: we want to apply it to other developments and domains.

Keeping to modal logic, the area can be seen as a reasoning methodology for relational structure. Once its semantics is connected to ordinary Lean predicates, sets, transition systems, and other structures, the modal library can be used as a reasoning tool outside modal logic itself.

In CSLib, we have shown how these connections enable the application of modal logic to reason about mathematics, programming languages, and concurrency theory. None of these is ‘another modal logic’.
Instead, we expose an independently formalised object through an appropriate interface, and an existing body of modal theory becomes applicable to it.

This is where library-grade formalisation becomes especially powerful. A formalised theory stops being only an object of study and becomes a reasoning technology for other theories and applications.

A straightforward example is using Hennessy-Milner Logic to prove that a concurrent process respects a specification, as in the next figure.

<figure class="bliki-figure">

<img src="/images/hml-vending-coin-spec.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<figcaption>

A statement in Hennessy-Milner Logic establishing that a vending machine offers a choice between coffee and tea after the insertion of a coin.
</figcaption>
</figure>

Perhaps more surprising is the fact that we can use modal logic to reason about algebraic properties, as shown below. While this is not a new theorem, finding out that modal logic can be used to reason about radicals of ideals in mathematics was a really satisfying development! Particularly because we made a general construction that translates algebraic properties into properties of modal logic models, so the entire approach is reusable.

<figure class="bliki-figure">

<img src="/images/cslib-ideal-radical-denotation.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<img src="/images/cslib-radical-idem.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<img src="/images/cslib-radical-idem-equiv-step.svg" class="img-fluid" style="width: min(100%, 32rem);"/>

<figcaption>

Modal reasoning for mathematics, here applied to radicals of ideals.
First, we establish a modal model whereby the radical of an ideal `I` is equal to the denotation of `◇I` (first image). Then, we prove the standard idempotency result for radicals (second image) by leveraging the modal law that `◇◇I ` is equivalent to `◇I` in this model (third image).
</figcaption>
</figure>


## Making reuse usable

Reuse does not happen automatically just because we have found the right abstractions.
We can build something wonderfully general, but we should also strive to make it easy to apply.

A useful principle is:

> General underneath, natural at the surface.

Keeping to the example of modal logic, the generic framework supports operators of arbitrary arity through a fairly general representation. But somebody working with basic modal logic should not have to think about that: they should see the familiar operators `◇` and `□`, with their usual semantics. Somebody working with Hennessy–Milner Logic should see modalities indexed by transition labels.

The same holds for theorems.
Having a theorem somewhere in the library is not quite the same as making its knowledge reusable. If every downstream application requires manually rediscovering a chain of five generic lemmas, unfolding representations, and translating between abstraction layers, then using the library becomes cumbersome.

We have found proof automation to be very useful in making generic knowledge easy to activate in specialisations.
This is why **we treat proof automation as part of the library interface**. In modal logic, this is exposed as a `grind` set called `modal`, which gives access to a dedicated database of modal results so that routine reasoning can be automatically discharged.

This also gives us useful feedback as library designers. If an elementary fact repeatedly requires bespoke proofs, that may be telling us that the problem is not the proof: perhaps an interface is missing, a theorem is stated in the wrong form, or an abstraction boundary needs to move.

So library-grade computer science has another requirement: **the accumulated knowledge should not only be available, but easy to activate**.


## Conclusion

None of these are hard admission criteria; library development is incremental, and getting to the right abstraction often requires first building some concrete objects.
But they describe the direction in which we are going.

I have used modal logic as an example, but CSLib offers many others. This includes, but is not limited to, reusable APIs for semantics, shared infrastructure for automata and computability, and a rich vocabulary for reasoning about relations.

In other words, to conclude:

**The question is not only what we have formalised, but what becomes possible to formalise because CSLib exists.**

## References

{{#fn.citation}}cslib cslib-arxiv{{/fn.citation}}

<a id="brv01"></a>Patrick Blackburn, Maarten de Rijke, Yde Venema [2001], ‘Modal Logic’, _Cambridge University Press_. DOI: 10.1017/CBO9781107050884.

{{#fn.citation}}gm26 library-grade-modal-logic-arxiv{{/fn.citation}}

{{#fn.citation}}cslib-spine computer-science-as-infrastructure-arxiv{{/fn.citation}}

{{#fn.citation}}cslib-hml hennessy-milner-logic-in-cslib-the-lean-computer-science-library-arxiv{{/fn.citation}}

<a id="pd93"></a>Rubén Prieto-Díaz [1993], ‘Status Report: Software Reusability’, _IEEE Software_ 10(3), pp. 61–66. DOI: 10.1109/52.210605.

<!-- --> {{/content}}{{/fm-bliki.html}}