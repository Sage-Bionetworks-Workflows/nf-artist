process bioformats2ometiff {
  tag {"$meta.id"}
  label "process_medium"
  publishDir "$params.outdir",
    enabled: params.save_ometiff,
    pattern: "*.ome.tiff",
    saveAs: {filename -> "${meta.id}/ometiff/${filename}"}
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file("${image.simpleName}.ome.tiff")
  stub:
  """
  touch raw_dir
  touch "${image.simpleName}.ome.tiff"
  """
  script:
  """
  bioformats2raw $image 'raw_dir'
  raw2ometiff 'raw_dir' "${image.simpleName}.ome.tiff"
  """
}
