workflow SAMPLESHEET_SPLIT {
    take:
    samplesheet
    main:
    Channel
        .fromPath(samplesheet)
        .splitCsv (header:true, sep:',' )
        // Make meta map from the samplesheet
        .map { 
            row -> 
            def meta = [:]
            meta.id = file(row.image).simpleName
            meta.ome = row.image ==~ /.+\.ome\.tif{1,2}$/
            meta.convert = row.convert.toBoolean()
            meta.he = row.he.toBoolean()
            meta.miniature = row.miniature.toBoolean()
            meta.minerva = row.minerva.toBoolean()
            image = file(row.image)
            [meta, image]
        }
        .set {images }
        
    emit: 
    images
}
