<!-- --> {{< fm-bliki.html}}{{$title}}The Formal Frontier and Formal-First Research{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$content}}

The **formal frontier** is the current extent of our shared, machine-verified knowledge, as embodied in [formal libraries](CSLibLibraryGradeComputerScience) such as [CSLib](https://cslib.io/) [[Barrett et al., 2026](#cslib); [Henson and Montesi, 2026](#cslib-spine)] and [Mathlib](https://mathlib.org/).[¹](#footnote-1)

As these libraries grow, they open new research and innovation opportunities. Results that once required substantial preparatory work may become directly accessible through reusable definitions, theorems, and APIs. Together with increasingly capable tools, particularly AI, this makes **formal-first research** an increasingly accessible approach to formal sciences (like computer science and mathematics).

By **formal-first research**, I mean research that is:

- **Planned** with awareness of where the formal frontier stands.
- **Conducted** with the aid of the formal frontier and its tooling.

What changes is not only when we formalise, but also how the existing body of formal knowledge informs the questions we ask and the research we undertake. We start by understanding what we can already build upon, identifying what is missing, and deciding how to advance our knowledge while contributing to shared formal foundations.

This contrasts with some traditional research approaches in which formalisation is treated as a subsequent step, perhaps even a clean-up exercise, if it happens at all. Formal-first research brings formalisation into the process from the earliest stages of conceptualisation.

By this, I do not mean to suggest that we should abandon informal research, or pursue only problems that are easy to formalise. Rather, I am trying to give words to intuitions that are already developing among researchers working with the formal frontier. Making these ideas explicit can help us discuss them, refine them, and put them into practice more effectively. As a starting point, I propose the following taxonomy.

## A taxonomy of project traits

Here is a first taxonomy of traits of *formal frontier projects*, based on how they relate to the existing frontier:

- A **Needle Project** pursues a specific goal far beyond the current frontier, developing a focused path towards it and formalising what is needed along the way.
- A **Foundation Project** extends the scope of the formal frontier by establishing the definitions, abstractions, and results needed to make new areas of knowledge formally accessible.
- An **Amplification Project** increases what can be accomplished with existing formal knowledge, for example by generalising theories, connecting APIs, or developing better automation.
- An **Exploration Project** investigates new research questions made accessible by the existing formal frontier, building upon established foundations to discover new results.

The taxonomy admits a geometric interpretation: **Needles reach far, Foundations extend outwards, Amplifications strengthen within, and Explorations discover nearby.** The next figure illustrates these four ways of relating to the frontier.

<figure class="bliki-figure">

<div class="row p-3">
  <div class="col-12 col-sm-6">
    <p class="text-center text-dark font-weight-bold mt-3 mb-0">Needle</p>
    <img src="/images/formal-frontier/needle.svg" style="background-color: #f7f8f5;" class="img-fluid"/>
  </div>
  <div class="col-12 col-sm-6">
    <p class="text-center text-dark font-weight-bold mt-3 mb-0">Foundation</p>
    <img src="/images/formal-frontier/foundation.svg" style="background-color: #f7f8f5;" class="img-fluid"/>
  </div>
  <div class="col-12 col-sm-6">
    <p class="text-center text-dark font-weight-bold mt-3 mb-0">Amplification</p>
    <img src="/images/formal-frontier/amplification.svg" style="background-color: #f7f8f5;" class="img-fluid"/>
  </div>
  <div class="col-12 col-sm-6">
    <p class="text-center text-dark font-weight-bold mt-3 mb-0">Exploration</p>
    <img src="/images/formal-frontier/exploration.svg" style="background-color: #f7f8f5;" class="img-fluid"/>
  </div>
</div>

<figcaption>

A geometric interpretation of the four formal-first project traits. Green represents the existing formal frontier, while purple represents new development. The traits may coexist within the same project.
</figcaption>
</figure>

Importantly, **these four traits describe different ways of relating to the formal frontier, rather than different kinds of scientific achievements**. They imply no ranking of ambition, difficulty, or scientific merit. Nor are they mutually exclusive: a project may exhibit several traits simultaneously. Even the terminology matters: the names should evoke different research strategies without suggesting a hierarchy of prestige.[²](#footnote-2)

For example, developing a reusable theory of compiler correctness in CSLib might involve establishing foundations for operational semantics and rule formats, amplifying these foundations through reusable abstractions and automation, and exploring their applicability to concrete compilers. Work on one aspect may reveal new requirements for another.

Projects can also evolve over time. A needle may eventually become a shared foundation, while an exploration may reveal opportunities for amplification. Different researchers within the same team, or across the world, may pursue complementary activities simultaneously.

The formal frontier is continually evolving, and so should our ways of contributing to it. The taxonomy is intended to help us understand, discuss, and plan these possibilities, not constrain them.

This is particularly powerful when we treat formal libraries as collaborative knowledge bases in continuous evolution.

For example, I contributed the initial module for transition systems to CSLib. Other contributors subsequently improved proofs, optimised performance, and suggested additional results to make the API more broadly applicable. What began as an individual contribution gradually developed into richer, shared infrastructure. Later, this infrastructure supported developments in areas such as automata theory and distributed consensus. In terms of our taxonomy, an initial Foundation effort attracted Amplification contributions, eventually enabling new Explorations and Needles.

**Shared formal libraries make machine-verified knowledge available for direct reuse. Formal-first projects deliberately build upon it.**

## AI and the Formal Frontier

As AI systems become more capable, formal-first research offers a promising way to **keep humans in the captain's chair** of research and innovation.

As formal libraries grow, navigating their contents becomes increasingly challenging. AI can help researchers discover relevant results, understand existing APIs, identify missing abstractions, and recognise opportunities that might otherwise go unnoticed.

It can also help us advance the frontier: constructing proofs, developing new foundations, amplifying existing APIs, pursuing needles, and exploring new research questions.

Researchers can choose the initial scientific questions, design the abstractions, and determine where to direct their efforts. The formal frontier gives humans and AI a shared, explicit foundation on which to build, helping researchers understand the assumptions and dependencies of AI contributions, evaluate their results, and guide subsequent work. Formal verification makes it possible to check the resulting proofs independently of how they were produced. Of course, deciding whether we have formalised the right questions and developed useful abstractions remains a matter of scientific judgement.

## Doing science together

The implications of formal-first research extend beyond individual projects.

An awareness of the formal frontier can help individual researchers, developers, research supervisors, groups, and organisations plan their work more consciously. It can help us recognise valuable contributions beyond individual theorems, including the foundations and APIs that enable entire families of future results.

And because these foundations are shared, this way of thinking can extend beyond individual institutions to a global research community.

Formal-first research is not intended to replace other approaches. It is an increasingly accessible way of doing science together, starting from shared, machine-verified knowledge and deliberately contributing to its evolution.

**The formal frontier helps us understand where we stand, so that we can deliberately choose where to go next – and help others go further.**

---

<a id="footnote-1"></a> ¹ Not to be confused with the [Formal Frontier project](https://mathlib-initiative.org/formal-frontier/) by the Mathlib Initiative, which aims to advance the formalisation of mathematical knowledge. Here, *formal frontier* refers to the current extent of shared formalised knowledge, rather than a particular formalisation initiative.

<a id="footnote-2"></a>² For example, I deliberately use *Needle* rather than *Moonshot*. The latter suggests exceptional ambition or importance, whereas distance from the current formal frontier says nothing about a project's scientific merit. *Needle* emphasises the focused path towards a distant goal, without assigning value to that goal.

---

## References

{{#fn.citation}}cslib cslib-arxiv{{/fn.citation}}

{{#fn.citation}}cslib-spine computer-science-as-infrastructure-arxiv{{/fn.citation}}

<!-- --> {{/content}}{{/fm-bliki.html}}
