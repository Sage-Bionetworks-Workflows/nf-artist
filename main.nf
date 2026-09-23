#!/usr/bin/env nextflow

params.input = null
params.outdir = "outputs"
params.save_ometiff = false
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
  if (!params.input) {
    error 'Input samplesheet not specified!'
  }
  NF_ARTIST ()
}
