process SYNAPSE_GET {
  label "process_low"
  echo params.echo
  input:
    val synid
  output:
    tuple val(synid), file('*')
  stub:
  """
  touch "test.tif"
  """
  script:
  """
  echo "synapse -c $params.synapseconfig get $synid"
  synapse -c $params.synapseconfig get $synid
  """
}