process autominerva_story {
  input:
      tuple val(meta), file(image)
      path he_story
  output:
      tuple val(meta), file(image), file('story.json')
  publishDir "$params.outdir",
    pattern: 'story.json',
    saveAs: {filename -> "${meta.id}/minerva/story.json"}
  stub: 
  """
  touch story.json
  """
  script:
  if (meta.he) {
    """
    cp he_story.json story.json
    """
  } else {
    """
    python3 /auto-minerva/story.py $image > 'story.json'
    """
  }
}
