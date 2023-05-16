<!-- --> {{< fm-bliki.html}}{{$title}}Knowledge of Choice{{/title}}{{$content}}

This page is still under construction.

A [choreography](Choreography) has the **Knowledge of choice** property if it ensures that all participants are aware of which alternative behaviours are chosen at runtime.

As an example, consider the following choreography for single-sign on. A client (`c`) communicates some credentials to an authenticator (`a`), which then decides if a web service (`ws`) should communicate a new session token to the client.
```
c.credentials -> a.x;
if a.valid(x) then
	ws.newToken() -> c.token
```

<pre class="mermaid">
sequenceDiagram
	A->>B: M
</pre>
<!-- --> {{/content}}{{/fm-bliki.html}}