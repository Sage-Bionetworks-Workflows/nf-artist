process make_miniature {
  label "process_medium"
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file('miniature.jpg')
  publishDir "$params.outdir/$workflow.runName",
    saveAs: {filename -> "${meta.id}/$workflow.runName/thumbnail.jpg"}
  stub:
  """
  mkdir data
  touch data/miniature.jpg
  """
  script:
  if ( meta.he){
    """
    #!/usr/bin/env python

    from tiffslide import TiffSlide
    import matplotlib.pyplot as plt
    import os

    slide = TiffSlide('$image')

    thumb = slide.get_thumbnail((512, 512))
    thumb.save('miniature.jpg')
    """
  } else {
    """
    python3 /miniature/bin/paint_miniature.py \
      $image 'miniature.jpg' \
      --level $params.level \
      --dimred $params.dimred \
      --colormap $params.colormap \
      --n_components $params.n_components
    """
  }
}
