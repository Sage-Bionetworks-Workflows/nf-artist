include { make_miniature } from '../modules/make_miniature.nf'

workflow MINIATURE {
  take:
  converted

  main:
  for_miniature = converted.filter { meta, _image -> meta.miniature }
  make_miniature(for_miniature)
}
