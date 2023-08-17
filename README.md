# HTAN Artist

A NextFlow pipeline to run image rendering process to generate resources for the [HTAN Portal](https://github.com/ncihtan/htan-portal).

- Converts bioformats files into OME-TIFF
- Generates a `story.json` file using [Auto-Minerva](https://github.com/jmuhlich/auto-minerva)
- Renders a Minerva story using [Minerva Author](https://github.com/labsyspharm/minerva-author)
- Renders a thumbnail image using [Miniature](https://github.com/adamjtaylor/miniature)

A Docker container ([ghcr.io/sage-bionetworks-workflows/nf-artist](https://github.com/sage-bionetworks-workflows/nf-artist/pkgs/container/nf-artist)) is used to ensure reproducibility.

## Example usage

```
nextflow run ghcr.io/sage-bionetworks-workflows/nf-artist --input <path-to-samplesheet> --outdir <output-directory>
```

## Options

`--input` [required] - Path to samplesheet. See samplesheet requirements  
`--outdir` - Output directory. Default: `outputs`

#### Samplesheet requriments

The samplesheet specified in the `input` parameter should be a CSV file with the following columns

- `image`: [string] Path or URI to image to be processed
- `convert`: [boolean] Should the image be converted to a OME-TIFF
- `he`: [boolean] Is the image a H&E image
- `minerva`: [boolean] Should a Minerva story be generated
- `miniatuee`: [boolean] Should a Miniature thumbnail be generated

