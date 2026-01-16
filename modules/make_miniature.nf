process make_miniature {
  tag {"$meta.id"}
  label "process_high"
  input:
      tuple val(meta), file(image) 
  output:
      tuple val(meta), file('miniature.jpg')
  publishDir "$params.outdir",
    saveAs: {filename -> "${meta.id}/thumbnail.jpg"}
  stub:
  """
  mkdir data
  touch data/miniature.jpg
  """
  script:
  if ( meta.he){
    """
    #!/usr/bin/env python

    import pyvips

    # Use pyvips for robust thumbnail generation from any whole slide format
    # Supports SVS, OME-TIFF, and other formats efficiently
    image = pyvips.Image.new_from_file('$image', access='sequential')
    
    # Create thumbnail with max dimension of 512px
    thumbnail = image.thumbnail_image(512)
    
    # Save as JPEG
    thumbnail.write_to_file('miniature.jpg')
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
