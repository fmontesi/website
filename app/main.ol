include "internal/hooks/pre_response.iol"
include "internal/hooks/post_response.iol"

include "internal/leonardo/ports/LeonardoAdmin.iol"

include "internal/dblp/dblp_utils.iol"

include "internal/format_converter/ports/FormatConverter.iol"

outputPort DBLP {
Interfaces: DBLPUtilsInterface
}

outputPort StringUtilsSrv {
Interfaces: StringUtilsInterface
}

embedded {
Jolie:
	"-C Standalone=false internal/leonardo/cmd/leonardo/main.ol" in LeonardoAdmin,
	"internal/dblp/dblp_utils.ol" in DBLP,
	"internal/string_utils/main.ol" in StringUtilsSrv,
	"internal/format_converter/main.ol" in FormatConverter
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
		};
		with( .redirection[1] ) {
			.name = "StringUtils";
			.binding.location = StringUtilsSrv.location
		};
		with( .redirection[2] ) {
			.name = "FormatConverter";
			.binding.location = FormatConverter.location
		}
	};
	config@LeonardoAdmin( config )();
	linkIn( Shutdown )
}
