
process STORY {
    label "process_medium"
    publishDir "$params.outdir/$workflow.runName"
        mode: 'copy'
    
    echo params.echo
    
    when:
        params.minerva == true || params.all == true
    
    input:
        tuple val(synid), file(ome)
    
    output:
        tuple val(synid), file('story.json'), file(ome)
    
    stub:
    """
    touch story.json
    """
    
    script:
    """
    python3 /auto-minerva/story.py $ome > 'story.json'
    """
}


process RENDER {
    label "process_medium"
    publishDir "$params.outdir/$workflow.runName",
        mode: 'move' 
    
    echo params.echo
    
    input:
        tuple (val); synid, file(story), file(ome)
        file synapseconfig from synapseconfig
    
    output:
        file 'minerva'
    
    stub:
    """
    mkdir minerva
    touch minerva/index.html
    touch minerva/exhibit.json
    """
    
    script:
    """
    python3  /minerva-author/src/save_exhibit_pyramid.py $ome $story 'minerva'
    cp /index.html minerva
    wget -O inject_description.py $params.minerva_description_script
    python3 inject_description.py minerva/exhibit.json --synid $synid --output minerva/exhibit.json --synapseconfig $synapseconfig
    """
}

process RENDER_HE {
    label "process_medium"

    publishDir "$params.outdir/$workflow.runName",
        mode: 'move'     
    
    echo params.echo

    input:
        tuple val(synid), file(ome)
        file synapseconfig from synapseconfig

    output:
        file 'minerva'

    stub:
    """
    mkdir minerva
    touch minerva/index.html
    touch minerva/exhibit.json
    """

    script:
    """
    wget -O story.json $params.heStory
    python3  /minerva-author/src/save_exhibit_pyramid.py $ome $story 'minerva'
    cp /index.html minerva
    wget -O fix_he_exhibit.py $params.heScript
    python3 fix_he_exhibit.py minerva/exhibit.json
    wget -O inject_description.py $params.minerva_description_script
    python3 inject_description.py minerva/exhibit.json -synid$synid --synapseconfig $synapseconfig
    """
}

