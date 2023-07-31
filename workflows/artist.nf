include { SAMPLESHEET_SPLIT } from '../subworkflows/samplesheet_split.nf'
include { CONVERT } from '../subworkflows/convert.nf'
include { MINERVA } from '../subworkflows/minerva.nf'
include { MINIATURE } from '../subworkflows/miniature.nf'

workflow ARTIST {
    SAMPLESHEET_SPLIT ( params.input )
    CONVERT( SAMPLESHEET_SPLIT.out.images )
    CONVERT.out.converted.set{converted}
    MINERVA( converted ) 
    MINIATURE( converted )
}
