process make_miniature {
  label "process_high"
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file('thumbnail.jpg')
  publishDir "$params.outdir",
    saveAs: {filename -> "${meta.id}/thumbnail.jpg"}
  stub:
  """
  mkdir data
  touch data/thumbnail.jpg
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
    if thumb.mode in ("RGBA", "P"): 
      thumb = thumb.convert("RGB")
    thumb.save('thumbnail.jpg')
    """
  } else {
    """
    python3 /miniature/bin/paint_miniature.py \
      $image 'thumbnail.jpg' \
      --level $params.level \
      --dimred $params.dimred \
      --colormap $params.colormap \
      --n_components $params.n_components
    """
  }
}
