process render_pyramid {
  tag "$meta.id"
  label "process_medium"
  publishDir "$params.outdir",
    saveAs: { _filename -> "${meta.id}/minerva" }

  input:
      tuple val(meta), path(image), path(story)

  output:
      tuple val(meta), path('minerva')

  script:
  """
  python3  /minerva-author/src/save_exhibit_pyramid.py $image $story 'minerva'
  """

  stub:
  """
  mkdir minerva
  touch minerva/tile1.png
  touch minerva/author.json
  touch minerva/index.html
  """
}
