process render_pyramid {
  input:
      tuple val(meta), file(image), file (story)
  output:
      tuple val(meta), path('minerva')
  publishDir "$params.outdir/$workflow.runName",
    saveAs: {filename -> "${meta.id}/$workflow.runName/minerva"}
  stub:
  """
  mkdir minerva
  touch minerva/tile1.png
  touch minerva/author.json
  touch minerva/index.html
  """
  script:
    """
    python3  /minerva-author/src/save_exhibit_pyramid.py $image $story 'minerva'
    cp /index.html minerva
    """
    
}
