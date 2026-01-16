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

    import tifffile
    from PIL import Image

    # Open the OME-TIFF file
    with tifffile.TiffFile('$image') as tif:
        # For pyramidal images, use the smallest level for efficiency
        if len(tif.series) > 0 and len(tif.series[0].levels) > 1:
            # Get the smallest pyramid level
            level = tif.series[0].levels[-1]
            img_array = level.asarray()
        else:
            # No pyramid, read the full resolution
            img_array = tif.asarray()
    
    # Convert numpy array to PIL Image
    thumb = Image.fromarray(img_array)
    
    # Create thumbnail (maintains aspect ratio)
    thumb.thumbnail((512, 512))
    
    # Ensure RGB mode
    if thumb.mode in ("RGBA", "P"): 
      thumb = thumb.convert("RGB")
    
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
