# HTAN Artist

A NextFlow pipeline to run image rendering process to generate resources for the [HTAN Portal](https://github.com/ncihtan/htan-portal).

- Converts bioformats files into OME-TIFF
- Generates a `story.json` file using [Auto-Minerva](https://github.com/jmuhlich/auto-minerva)
- Renders a Minerva story using [Minerva Author](https://github.com/labsyspharm/minerva-author)
- If the `--all` parameter is set, renders a thumbnail, an autominerva story and gets the metadata
- If the `--miniature` parameter is set, renders a thumbnail image using [Miniature](https://github.com/adamjtaylor/miniature)
- `--he` assumes the channel is a brighfield microscopy image of H&E stained tissue and uses a fixed, unscaled `story.json` and a custom color legend
- `--input` can be the path to an image (with `*` wildcards) or a csv manifest of cloud storage uris (one per line).

A Docker container ([ghcr.io/sage-bionetworks-workflows/nf-artist](https://github.com/sage-bionetworks-workflows/nf-artist/pkgs/container/nf-artist)) is used to ensure reproducibility.

## Example usage

```
nextflow run ghcr.io/sage-bionetworks-workflows/nf-artist --input_path <path-to-image> --outdir <output-directory> --all
```

## Options

`--outdir` - output directory. Default: `.`  
`--minerva`: Renders an [Auto-Minerva](https://github.com/jmuhlich/auto-minerva) story  
`--miniature` - Renders a thumbnail image using [Miniature](https://github.com/adamjtaylor/miniature)   
`--metadata` -  Extract headers from the image and save as a json  
`--all` - set `--minerva` `--miniature` and `--metadata`   
`--he` - Use an unscaled scene for Minerva story and thumbnail generation. Suitable for H&E images  
`--input_csv` - Path to a csv with a file path, uid, or synapseID per row  
`--input_synid` - A synapse ID  
`--input_path` - The path to a file. Can take wildcards  
`--watch_path` - A path to watch for files that are created or modified  
`--watch_csv` - A path to a csv to watch for if it is modified  
`--echo` - Echo outputs  
`--keepBg` - Keep the background in thumbnails  
`--level` - the pyramid level used in thumbnauls, Default: `-1` (highest)  
`--bioformats2ometiff` - Convert images to ome-tiff. Default: `true`  
`--synapseconfig` - Path to a synapseConfig file. Required for Synapse authentication  

## Example flow diagram:

![image](https://user-images.githubusercontent.com/14945787/133272620-18223615-ce22-41c3-807b-3f3007b8f080.png)

## Docker pointers

### Test docker container

`docker run -ti ghcr.io/sage-bionetworks-workflows/nf-artist`

## Build docker container

`docker build -t ghcr.io/sage-bionetworks-workflows/nf-artist docker/`
