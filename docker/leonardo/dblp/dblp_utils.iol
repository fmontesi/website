type GetAuthorBibtexRequest:void {
	.initial:string
	.nameKey:string
}

interface DBLPUtilsInterface {
RequestResponse:
	getAuthorBibtex( GetAuthorBibtexRequest )( string )
}

