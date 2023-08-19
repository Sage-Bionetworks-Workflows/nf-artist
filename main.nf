#!/usr/bin/env nextflow

// Enable dsl2
nextflow.enable.dsl=2

if (params.input) { params.input = file(params.input) } else { exit 1, 'Input samplesheet not specified!' }

params.outdir = "outputs"
params.remove_bg = true
params.level = -1
params.dimred = "umap"
params.colormap = "UCIE"
params.n_components = 3

include { ARTIST } from './workflows/artist.nf'

workflow NF_ARTIST {
  ARTIST ()
}

workflow {
  NF_ARTIST ()
}
