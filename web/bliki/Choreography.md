<!-- --> {{< fm-bliki.html}}{{$title}}Choreography{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}18 May 2023{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

In computer science, a **choreography** is a coordination plan for processes that participate in concurrent and distributed systems [[Montesi 2023](#M23)].
It defines the communications that these processes are expected to perform, usually with the underlying intention that these processes collabolate in order to achieve a joint goal.

Choreographies are typically given in a [choreographic language](ChoreographicLanguage).

<figure class="fm-figure">

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

A simple choreography where a `buyer` requests the price of a product from a `seller` and then decides whether to go forward with the product's shipping by a third-party `shipper`, given in [Selective Choreographies](ChoreographicLanguage#SelectiveChoreographies).
</figcaption>
</figure>

<figure class="fm-figure">

<pre class="mermaid text-center">
sequenceDiagram
	participant b as buyer
	participant s as seller
	participant sh as shipper
	b->>s: product
	s->>b: price
	alt b.likes(price)
		b->>s: Accept
		s->>sh: PrepareShipping
		b->>sh: address
	else
		b->>s: Reject
		s->>sh: NoShipping
	end
</pre>

<figcaption>

A similar buyer-seller-shipper example, but given as a [sequence diagram](ChoreographicLanguage#SequenceDiagram).
</figcaption>
</figure>

## Data Choreographies

Choreographies in computer science are not to be confused with choreographies in other fields. When disambiguation is necessary, the choreographies in computer science can be called 'Data Choreographies' (<https://youtu.be/B7MNZk1v37g>).

## The family of Buyer-Seller examples

The Buyer-Seller-Shipper example is well-known in the field of choreographies. It is simple, but it suffices to showcase some central issues like [knowledge of choice](KnowledgeOfChoice). For this reason, many articles present some variation of the same example as an illustrative example.

In the communities of [choreographic programming](ChoreographicProgramming) and [multiparty session types](ChoreographicLanguage#GlobalType), some people (me included) like to joke about the fact that the codification of the buyer-seller-example in textual choreographic languages is the most impactful contribution of the seminal paper on endpoint projection by [[Carbone et al.](#CHY12)].

## Decentralised nature

By nature, choreographies do not require central control. They are often contrasted with the concept of orchestration, whereby a central coordinator (the orchestrator) invokes and composes the operations offered by the other processes in the system.

However, while choreographies do not **need** centralised control, this does not mean that all choreographies describe decentralised systems. It is indeed conceivable to write a choreography that describes an orchestrated system.

## References

<a id="CHY12"></a>Carbone, M., Honda, K., Yoshida, N. [2012],
'Structured Communication-Centered Programming for Web Services', _ACM Trans. Program. Lang. Syst._ 34(2): 8:1-8:78. <https://doi.org/10.1145/2220365.2220367>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}
