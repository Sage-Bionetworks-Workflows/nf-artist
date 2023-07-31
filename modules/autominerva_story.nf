process autominerva_story {
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file(image), file('story.json')
  publishDir "$params.outdir/$workflow.runName",
    pattern: 'story.json',
    saveAs: {filename -> "${meta.id}/$workflow.runName/story.json"}
  stub: 
  """
  touch story.json
  """
  script:
  if (meta.he) {
    """
    wget -O story.json $params.heStory
    """
  } else {
    """
    python3 /auto-minerva/story.py $image > 'story.json'
    """
  }
}
