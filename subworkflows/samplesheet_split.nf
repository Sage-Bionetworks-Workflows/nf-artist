workflow SAMPLESHEET_SPLIT {
    take:
    samplesheet

    main:
    channel
        .fromPath(samplesheet)
        .splitCsv(header: true, sep: ',')
        // Make meta map from the samplesheet
        .map { row ->
            def meta = [:]
            if (row.id) {
                meta.id = row.id
            } else {
                meta.id = file(row.image).simpleName
            }
            meta.ome = row.image ==~ /.+\.ome\.tif{1,2}$/
            meta.convert = row.convert.toBoolean()
            meta.he = row.he.toBoolean()
            meta.miniature = row.miniature.toBoolean()
            meta.minerva = row.minerva.toBoolean()
            def image = file(row.image)
            [meta, image]
        }
        .set { images }

    emit:
    images
}
