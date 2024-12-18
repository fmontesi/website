<!-- --> {{< fm-bliki.html}}{{$title}}EMI (Efficiency, Maintainability, and Isolation): a Conceptual Framework for API Refactoring{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$content}}

The **EMI (Efficiency, Maintainability, and Isolation) framework** is a conceptual framework for making decisions regarding the refactoring of APIs (Application Programming Interfaces).
It helps developers systematically evaluate and implement API changes by balancing three key quality aspects: efficiency, maintainability, and isolation. If you are interested in learning EMI, I recommend reading [our paper [Montesi et al. 2025]](#emi) ([pdf](/files/mppz25.pdf)). For a quick overview, keep reading.

EMI was introduced in [[Montesi et al. 2025](#emi)], building on the catalogue of API patterns by [Zimmermann et al. [2022]](#api-patterns) and the study of forces that might drive API refactorings by [Stocker and Zimmermann [2023]](#api-refactoring).

## The problem: API evolution

APIs evolve continuously, because of changing business and technical requirements. Therefore, refactoring of APIs is often required in the development and maintenance of many software architectures. Such refactorings can help with introducing new features, reduce coupling, improving efficiency of communication, etc. A typical example is the introduction of an API key to authenticate requests to an API (see: [API Key pattern](https://microservice-api-patterns.org/patterns/structure/specialPurposeRepresentations/APIKey)).

What implementation choices and tradeoffs should developers keep in mind when dealing API refactoring? This is where EMI comes into play.

## EMI in a nutshell

EMI identifies two dimensions that affect the quality of an API refactoring and should therefore be considered during design and implementation. The granularity at which these dimensions are analysed is kept quite coarse on purpose, in order to make EMI lean and usable in the first exploration of the design space of refactorings.

### Dimension 1: Generality
The _generality_ dimension concerns whether the code of the new functionality (the changes introduced by an API refactoring) depends on or abstracts from the definition of the original API.
There are two possibilities:

- **Ad-hoc**: The code of the new functionality contains hardcoded information about the original API (names of operations, types, behavioural details, etc.).
- **Parametric**: The code of the new functionality abstracts from such information.

### Dimension 2: Distribution

The _distribution_ dimension concerns where the code of the new functionality is placed.
Three possibilities are given:

- **Internal**: It is mixed with the code of the original API provider.
- **Adjacent**: It is in a separate service, which shares local computational resources with the original service but otherwise executes independently. This enables efficient communication by means of inter-process channels, loopback network interfaces, etc.
- **External**: It is placed in a separate service, which is deployed remotely from the original. This means that communication is remote and happens through the network.

The next figure visualises these possibilities.

<figure class="bliki-figure">

<img src="/images/emi-distribution.png" class="img-fluid"/>

<figcaption>

Possible choices for distribution in EMI, from [[Montesi et al. 2025](#emi)].
</figcaption>
</figure>

### EMI scoring table

The different choices along the two dimensions of generality and distribution can be mixed. Here are two examples of different implementation strategies for introducing an API key.
1. **Internal/Ad-hoc**: We edit the code of each operation in the original API provider to require and validate an API key in requests.
2. **Parametric/External**: We create a proxy that intercepts calls to the original API provider, inspects only the API key, and then forwards valid requests to the original API provider. The proxy code does not depend on the operation names nor message types: it forwards any request, as long as it contains an API key.

Solution 1 is very efficient, but can be hard to maintain because we have mixed old and new code. Solution 2 is less efficient, but is much more modular and keeps the resources of the proxy isolated from those of the original API provider.

In general, any EMI strategy yields a score from 1 to 3 on each quality aspect of **Efficiency (E)**, **Maintainability (M)**, and **Isolation (I)**. These aspects presents interesting trade-offs: optimising for one comes at the cost of another. This is illustrated in the next table, from the paper [[Montesi et al. 2025](#emi)].


<figure class="bliki-figure">

<img src="/images/emi-scoring-table.jpg" class="img-fluid"/>

<figcaption>

The EMI score table, from [[Montesi et al. 2025](#emi)]. Note the typical absence of a 'silver bullet' strategy, because of the tension between the three quality aspects under consideration.
</figcaption>
</figure>

## Further reading

That's basically the gist of it. In [our paper [Montesi et al. 2025]](#emi) ([pdf](/files/mppz25.pdf)), we give a more detailed presentation, exemplify the strategies on different patterns, and extract mechanical recipes for refactoring APIs that can be used to obtain the wished EMI scores.

Hope that you have enjoyed reading this article!
We welcome feedback and discussions on extending EMI, for example by considering new patterns, more granular scores, and other quality aspects.

## References

{{#fn.citation}}emi a-conceptual-framework-for-api-refactoring{{/fn.citation}}

<a id="api-patterns"></a>Olaf Zimmermann, Mirko Stocker, Daniel Lübke, Uwe Zdun, Cesare Pautasso [2022], ‘Patterns for API Design: Simplifying Integration with Loosely Coupled Message Exchanges’, _Addison-Wesley Professional_. ISBN: 9780137670093

<a id="api-refactoring"></a>Mirko Stocker, Olaf Zimmermann [2023], ‘API refactoring to patterns: Catalog, template and tools for remote interface evolution’, in Proceedings of EuroPLoP, pages 2:1–2:32, ACM. <https://doi.org/10.1145/3628034.3628073>

<!-- --> {{/content}}{{/fm-bliki.html}}