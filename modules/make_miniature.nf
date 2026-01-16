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
    import numpy as np

    # Open the OME-TIFF file
    with tifffile.TiffFile('$image') as tif:
        # For pyramidal images, use the smallest level for efficiency
        if len(tif.series) > 0 and hasattr(tif.series[0], 'levels') and len(tif.series[0].levels) > 1:
            # Get the smallest pyramid level
            level = tif.series[0].levels[-1]
            img_array = level.asarray()
        else:
            # No pyramid or single level, read the full resolution
            img_array = tif.asarray()
    
    # Ensure proper data type for PIL (uint8)
    if img_array.dtype != np.uint8:
        # Scale to uint8 range if needed
        if img_array.max() > 255:
            img_array = ((img_array - img_array.min()) / (img_array.max() - img_array.min()) * 255).astype(np.uint8)
        else:
            img_array = img_array.astype(np.uint8)
    
    # Convert numpy array to PIL Image
    thumb = Image.fromarray(img_array)
    
    # Create thumbnail (maintains aspect ratio)
    thumb.thumbnail((512, 512))
    
    # Ensure RGB mode
    if thumb.mode != "RGB": 
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
