<!-- --> {{< fm-bliki.html}}{{$title}}Choreography{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}18 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

In computer science, a **choreography** is a coordination plan for processes that participate in concurrent and distributed systems [[Montesi 2023](#M23)].
It defines the communications that these processes are expected to perform, usually with the intention that these processes collaborate in order to achieve a joint goal.

Choreographies are typically given in a [choreographic language](ChoreographicLanguage), which feature high-level primitives for expressing communications between processes. The design of these languages often depends on the desired application.
When a choreographic language is powerful enough to express executable distributed programs, it is called a [choreographic programming](ChoreographicProgramming) language.

<figure class="bliki-figure">

```
buyer.product -> seller.x;
seller.priceOf(x) -> buyer.price;
if buyer.likes(price) then
	buyer -> seller[Accept];
	seller -> shipper[PrepareShipping];
	buyer.address -> shipper.destination;
else
	buyer -> seller[Reject];
	seller -> shipper[NoShipping];
```

<figcaption>

A simple choreography where a `buyer` requests the price of a product from a `seller` and then decides whether to go forward with the product's shipping by a third-party `shipper`, given in [Recursive Choreographies](ChoreographicLanguage#RecursiveChoreographies). (Example adapted from [[Carbone et al. 2012]](#CHY12).)
</figcaption>
</figure>

<figure class="bliki-figure">

<pre class="mermaid text-center">
sequenceDiagram
	participant b as buyer
	participant s as seller
	participant sh as shipper
	b->>s: product
	s->>b: price
	alt buyer.likes(price)
		b->>s: Accept
		s->>sh: PrepareShipping
		b->>sh: address
	else
		b->>s: Reject
		s->>sh: NoShipping
	end
</pre>

<figcaption>

The buyer-seller-shipper example revisited as a [sequence diagram](ChoreographicLanguage#SequenceDiagram).
</figcaption>
</figure>

## Data Choreographies

Choreographies in computer science are not to be confused with choreographies in other fields. When disambiguation is necessary, the choreographies in computer science can be called 'Data Choreographies' (<https://youtu.be/B7MNZk1v37g>).

<a id="Decentralised"></a>
## Decentralised nature

By nature, choreographies do not require central control. They are often contrasted with the concept of orchestration, whereby a central coordinator (the orchestrator) invokes and composes the operations offered by the other processes in the system.

However, while choreographies do not **need** centralised control, this does not mean that all choreographies describe decentralised systems. It is indeed conceivable to write a choreography that describes an orchestrated system.

## References

<a id="CHY12"></a>Carbone, M., Honda, K., Yoshida, N. [2012],
'Structured Communication-Centered Programming for Web Services', _ACM Trans. Program. Lang. Syst._ 34(2): 8:1-8:78. <https://doi.org/10.1145/2220365.2220367>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}
