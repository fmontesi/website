include "console.iol"
include "internal/hooks/pre_response.iol"
include "internal/hooks/post_response.iol"

include "internal/leonardo/ports/LeonardoAdmin.iol"

embedded {
Jolie:
	"-C Standalone=false internal/leonardo/cmd/leonardo/main.ol" in LeonardoAdmin
}

main
{
	with( config ) {
		.wwwDir = "../web";
		.PreResponseHook.location = PreResponseHook.location;
		.PostResponseHook.location = PostResponseHook.location
	};
	config@LeonardoAdmin( config )();
	linkIn( Shutdown )
}
