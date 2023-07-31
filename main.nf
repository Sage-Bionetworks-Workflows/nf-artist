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

// made these into params so that they can be accessed anywhere in the pipeline
// can be added to profiles or other configuration later
params.heStory = 'https://gist.githubusercontent.com/adamjtaylor/3494d806563d71c34c3ab45d75794dde/raw/d72e922bc8be3298ebe8717ad2b95eef26e0837b/unscaled.story.json'
params.heScript = 'https://gist.githubusercontent.com/adamjtaylor/bbadf5aa4beef9aa1d1a50d76e2c5bec/raw/1f6e79ab94419e27988777343fa2c345a18c5b1b/fix_he_exhibit.py'
params.minerva_description_script = 'https://gist.githubusercontent.com/adamjtaylor/e51873a801fee39f1f1efa978e2b5e44/raw/c03d0e09ec58e4c391f5ce4ca4183abca790f2a2/inject_description.py'

include { ARTIST } from './workflows/artist.nf'

workflow NF_ARTIST {
  ARTIST ()
}

workflow {
  NF_ARTIST ()
}
