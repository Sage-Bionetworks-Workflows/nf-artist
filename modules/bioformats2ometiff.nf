process bioformats2ometiff {
  tag {"$meta.id"}
  label "process_medium"
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file("${image.simpleName}.ome.tiff")
  publishDir "$params.outdir",
    enabled: params.save_ometiff,
    pattern: "*.ome.tiff",
    saveAs: {filename -> "${meta.id}/ometiff/${filename}"}
  stub:
  """
  touch raw_dir
  touch "${image.simpleName}.ome.tiff"
  """
  script:
  def rgb_flag = meta.he ? '--rgb' : ''
  """
  bioformats2raw $image 'raw_dir'
  raw2ometiff ${rgb_flag} 'raw_dir' "${image.simpleName}.ome.tiff"
  """
}
