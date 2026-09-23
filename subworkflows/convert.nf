include { bioformats2ometiff } from '../modules/bioformats2ometiff.nf'

workflow CONVERT {
    take:
    images

    main:
    bioformats = images.filter { meta, _image -> meta.convert }

    bioformats2ometiff(bioformats)

    images
        .filter { meta, _image -> !meta.convert }
        .mix(bioformats2ometiff.out)
        .set { converted }

    emit:
    converted
}
