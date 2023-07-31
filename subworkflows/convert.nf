include { bioformats2ometiff } from '../modules/bioformats2ometiff.nf'

workflow CONVERT {
    take: images
    main:
    images
        .filter {
            it[0].convert == true
        }
        .set {bioformats}

    bioformats2ometiff(bioformats)

    images
      .filter {
         it[0].convert == false
      }    
      .mix (bioformats2ometiff.out)
      .set {converted}

    emit: converted
}
