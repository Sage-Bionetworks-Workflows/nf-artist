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

    # Open the OME-TIFF file and read the base (full resolution) image
    # Let PIL handle the resizing via thumbnail() - it's more robust
    with tifffile.TiffFile('$image') as tif:
        # Always read from the base series (full resolution)
        # Don't try to use pyramid levels as they may be too small or have odd shapes
        if len(tif.series) > 0:
            img_array = tif.series[0].asarray()
        else:
            img_array = tif.asarray()
    
    # Handle array shape - squeeze out singleton dimensions
    img_array = np.squeeze(img_array)
    
    # Ensure we have at least 2D array
    if img_array.ndim < 2:
        # After squeezing, if we end up with 1D, reshape to 2D
        img_array = img_array.reshape(1, -1)
    
    # Handle different array shapes
    # Expected shapes: (Y, X), (Y, X, 3), (Y, X, 4) for grayscale, RGB, or RGBA
    if img_array.ndim > 3:
        # If more than 3 dimensions after squeeze, take first slice
        # This handles cases like (C, Y, X, S) -> take first channel
        img_array = img_array[0]
        img_array = np.squeeze(img_array)
        # Check again after squeezing
        if img_array.ndim < 2:
            img_array = img_array.reshape(1, -1)
    
    # Ensure proper data type for PIL (uint8)
    if img_array.dtype != np.uint8:
        # Scale to uint8 range if needed
        img_min = img_array.min()
        img_max = img_array.max()
        if img_max > 255:
            # Avoid division by zero
            if img_max > img_min:
                img_array = ((img_array - img_min) / (img_max - img_min) * 255).astype(np.uint8)
            else:
                img_array = np.zeros_like(img_array, dtype=np.uint8)
        else:
            img_array = img_array.astype(np.uint8)
    
    # Convert numpy array to PIL Image
    thumb = Image.fromarray(img_array)
    
    # Create thumbnail (maintains aspect ratio)
    # PIL's thumbnail is efficient and handles large images well
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
