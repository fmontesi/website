<!-- --> {{< fm-bliki.html}}{{$title}}Choreography-Defined Network (CDN){{/title}}{{$author}}Fabrizio Montesi{{/author}}{{$subHeader}}See also: <a href="/introduction-to-choreographies">Introduction to Choreographies</a>{{/subHeader}}{{$content}}

A **Choreography-Defined Network (CDN)** is a [software-defined network](https://en.wikipedia.org/wiki/Software-defined_networking) whose behaviour is programmed by means 
of [choreographic programming](ChoreographicProgramming).
This method, introduced [Giallorenzo et al. [2024]](#Getal24), targets in particular the coordination of Virtual Network Functions (VNFs).
By leveraging choreographic programming, CDNs offer a distributed and parallel programming model that eliminates centralised orchestration bottlenecks.
The method aims at simplifying the creation of efficient and scalable virtual network architectures, enabling better utilisation of cloud and edge computing in SDNs.

## Motivation

Programming VNFs such that they coordinate well with each other is challenging, because developers can introduce errors such as incompatible communication behaviours, message type mismatches, and unnecessary waiting times.
Therefore, traditional SDN and network function virtualisation frameworks rely on centralised orchestration to define the control and data flow across network functions.
However, this presents an important drawback: all coordination becomes centralised on the orchestrator(s), thereby increasing latency and communication overhead.

The challenge lies in creating a programming model that helps with correctness while enabling distributed, parallel execution of network functions.

## What is a Choreography-Defined Network?
CDN leverages [choreographic programming](ChoreographicProgramming) to program decentralised network function coordination by writing a unified [choreography](Choreography).
This choreography is then compiled into distributed programs that coordinate with each other in a decentralised way.

Having a unified choreography means that all interactions are still specified in a single program, retaining much of the programming simplicity of orchestration, but we now obtain a full distributed implementation without a central bottleneck.

### How it Works

The Choreography-Defined Network approach consists of the following steps:

1. **Define a Choreography.** Developers define the desired interactions and data exchanges across network functions as a choreography.
2. **Compile to Executables.** The choreography is automatically compiled into decentralised local programs.
3. **Deploy in Containers.** The local programs are containerized for deployment in modern cloud-native environments.

## Advantages

CDNs aim at bringing the advantages of [choreographic programming](ChoreographicProgramming) to software-defined networks.
These advantages include the following.

1. **Distributed Execution.** Network functions communicate directly without relying on a central orchestrator, reducing communication overhead.
2. **Parallelism.** CDNs facilitate the parallel execution of independent network functions, enhancing efficiency and throughput.
3. **Correctness by Design.** Choreographic programming prevents logical bugs that can cause deadlocks and message mismatches.
4. **Security.** Choreographies enable simpler reasoning about decentralised code, which can aid checking for security.

## Open Challenges

At the time of this writing, the following challenges about CDNs are open.

1. **Failure Handling.** The APIs for dealing with failures in choreographic programming are still quite low-level, and programming recovery from complex transactions can still be challenging. More research in the pragmatics of distributed transactions in choreographies is needed.
2. **Knowledge of Choice.** In order to guarantee correctness, choreography compilers might ask the programmer to add some extra communications for control. See also: [knowledge of choice](KnowledgeOfChoice).

## Read More

For more information on CDNs, see the paper by [[Giallorenzo et al. 2024]](#Getal24).
The paper uses the [Choral programming language](https://www.choral-lang.org) [[Giallorenzo et al. 2024](#GMP24)] to showcase the approach through a security case study for SDNs.

For information on the choreographic method, choreographic languages, and choreographic programming, see [Introduction to Choreographies](/introduction-to-choreographies) [[Montesi 2023]](#M23).


## References

<a id="Getal24"></a>Giallorenzo, S., Mauro, J., Melis, A., Montesi, F., Peressotti, M., Prandini, M. [2024], 'Choreography-Defined Networks: a Case Study on DoS Mitigation', _Proc. ICSOC_ 2024. [Pre-print](/files/gmmmpp24.pdf)

<a id="GMP24"></a>
Giallorenzo, S., Montesi, F., Peressotti, M. [2024], 'Choral: Object-oriented Choreographic Programming', _ACM Trans. Program. Lang. Syst._ 46(1): 1:1-1:59.
<https://doi.org/10.1145/3632398>

<a id="M23"></a>Montesi, F. [2023], 'Introduction to Choreographies', _Cambridge University Press_. <https://doi.org/10.1017/9781108981491>

<!-- --> {{/content}}{{/fm-bliki.html}}