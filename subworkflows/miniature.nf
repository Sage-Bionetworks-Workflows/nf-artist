include { make_miniature } from '../modules/make_miniature.nf'

workflow MINIATURE {
  take:
  converted
  
  main:
  converted
    .filter {
            it[0].miniature == true
        }
    .set {for_miniature }
  make_miniature(for_miniature)

}
