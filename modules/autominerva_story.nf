process autominerva_story {
  tag "$meta.id"
  label "process_low"
  publishDir "$params.outdir",
      pattern: 'story.json',
      saveAs: { _filename -> "${meta.id}/story.json" }

  input:
      tuple val(meta), path(image)

  output:
      tuple val(meta), path(image), path('story.json')

  script:
  """
  python3 /auto-minerva/story.py $image > 'story.json'
  """

  stub:
  """
  touch story.json
  """
}
