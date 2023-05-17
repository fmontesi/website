<!-- --> {{< fm-bliki.html}}{{$title}}Knowledge of Choice{{/title}}{{$content}}

This page is still under construction.

A [choreography](Choreography) has the **knowledge of choice** property if it ensures that all participants are aware of which alternative behaviours are chosen at runtime.

As an example, consider the following choreography for single-sign on, written in the language from [M23]. A client (`c`) communicates some credentials to an authenticator (`a`), which then decides if a web service (`ws`) should communicate a new session token to the client.

```
c.credentials -> a.x;
if a.valid(x) then
	ws.newToken() -> c.token
```



<pre class="mermaid">
sequenceDiagram
	participant c
	participant a
	participant ws
	c->>a: credentials
	alt a.valid(credentials)
		ws->>c: newToken()
	end
</pre>

## References

[M23]: Ciao

<!-- --> {{/content}}{{/fm-bliki.html}}