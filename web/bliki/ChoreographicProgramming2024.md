<!-- --> {{< fm-bliki.html}}{{$title}}Choreographic Programming 2024{{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$date}}27 June 2024{{/date}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

[Choreographic Programming 2024](https://pldi24.sigplan.org/home/cp-2024) 
(CP'24) ended. It was the first full international workshop on [choreographic programming](ChoreographicProgramming), co-located with [PLDI 2024](https://pldi24.sigplan.org/).
I'm heading home as I'm beginning to write this entry, in very good spirits and with a head full of fresh ideas.

It's been a really great event, and I'm not the only one to think that! I've heard many positive opinions from both experts and outsiders. There's been a bit for everyone: [the program](https://pldi24.sigplan.org/home/cp-2024#program) had talks for anybody interested in learning more about the paradigm, with lots of work in progress on foundations, expressivity, logical methods, security, and applications.

We owe this experience to the three organisers (next picture).

<figure class="bliki-figure">

<img src="/images/cp24/lgp-sign.jpg" class="img-fluid"/>

<figcaption>

From left to right: the workshop chairs [Lindsey Kuper](https://decomposition.al/), [Saverio Giallorenzo](https://saveriogiallorenzo.com/), and [Marco Peressotti](https://marcoperessotti.com/) proudly display the sign of CP'24 at Radisson Blu Scandinavia Hotel, Copenhagen.
</figcaption>
</figure>

For many, the workshop has been an opportunity to meet some people that they've known only by name, or over online video calls.
People came from many different places, as Marco showed during the opening (next picture).

<!-- <div class="row justify-content-center">
<div class="col-8"> -->
<figure class="bliki-figure">

<img src="/images/cp24/cp24-data.jpg" class="img-fluid"/>

<figcaption>

The workshop got together many people who met for the first time, coming from different countries.
</figcaption>
</figure>
<!-- </div>
</div> -->

Another evident aspect was that many people, including outsiders, were intrigued by the topic.
Co-locating with PLDI was obviously a very good choice.
As I was testing my laptop for my keynote, I asked 'Are we sure that we have enough chairs?' More and more people were coming in, and before we knew it there were attendees who had to sit on the floor and tables.
The room stayed full for most of the workshop and talks.

## What was said?

If you missed the workshop, you can see some abstracts of the talks in [the program](https://pldi24.sigplan.org/home/cp-2024#program).
Edited videos of the workshop should be posted in the future, too. Keep an eye on the [ACM SIGPLAN YouTube channel](https://www.youtube.com/@acmsigplan/videos).

I'm gonna upload my slides, too, as soon as I can figure out a good way to host them..!

## Interesting questions

At some point during my keynote I stated something like this:
if we accept that interaction (like data communication) is important in concurrent and distributed programming, then we should have an abstraction for it.
I then proceeded to show what has been discovered so far, including:
- The different syntactic shapes that the communication abstraction has taken in the last decade or so.
- Some laws that have been established about this abstraction, in particular the equivalence of two programs executing independent communications in different orders (since these orders cannot be observed).
- How research groups have integrated choreographic communication abstractions with mainstream programming languages like Java, Haskell, Rust, Scala, etc.

At the end of the talk, attendees asked some very relevant questions, including (and paraphrasing a bit):
- What's the story of choreographic programming in a Byzantine setting? (WIP!)
- Should we dispense with other approaches? (No!)
- Are there things that you can't do with choreographic programming? (Who knows!)
- What's the relation to work in programming technologies for High-Performance Computing? (WIP!)
- Is there more than point-to-point communication? (Yes!)
- Are there patterns that can be modelled in choreographies but not in other methods? (Not that I know of.)
- What's the relation to actor languages? (Choreographies sit on a higher level of abstraction).
- How to deal with participants joining and leaving? (Quantifiers for Choral; reactive choreographies; manipulating collections of process names in choreographies.)
- How to deal with aliasing of process names? (Verification and/or runtime checks.)
- Do you have any applications for low-level accelerators, etc.? (Not yet, but there's potential. We have experience with multithreading.)

## What's next?

The workshop triggered so many discussions. People talked about how we could:
- Scale to settings malicious actors.
- Explore how choreographic programming applies to more domains.
- Understand choreographies from a formal logical viewpoint.
- and much more...

But these are technical points. And there is so much to do.
We need to make it easier for new researchers and professionals to get started with choreographic programming and understand current limitations, applications, and future directions.
This is perhaps what was discussed the most. More on that in the near future!

<!-- --> {{/content}}{{/fm-bliki.html}}