include "console.iol"
include "internal/hooks/pre_response.iol"
include "internal/hooks/post_response.iol"

include "internal/leonardo/ports/LeonardoAdmin.iol"

include "internal/dblp/dblp_utils.iol"

outputPort DBLP {
Interfaces: DBLPUtilsInterface
}

embedded {
Jolie:
	"-C Standalone=false internal/leonardo/cmd/leonardo/main.ol" in LeonardoAdmin,
	"internal/dblp/dblp_utils.ol" in DBLP
}

main
{
	with( config ) {
		.wwwDir = "../web";
		.PreResponseHook.location = PreResponseHook.location;
		.PostResponseHook.location = PostResponseHook.location;
		with( .redirection[0] ) {
			.name = "dblp";
			.binding.location = DBLP.location
		}
	};
	config@LeonardoAdmin( config )();
	linkIn( Shutdown )
}
