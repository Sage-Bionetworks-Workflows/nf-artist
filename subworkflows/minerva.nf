include { autominerva_story } from "../modules/autominerva_story.nf"
include { render_pyramid } from "../modules/render_pyramid.nf"

workflow MINERVA {
  take:
  converted
  
  main:
  converted
    .filter {
            it[0].minerva == true
        }
    .set {for_minerva }
  autominerva_story(for_minerva)
  render_pyramid(autominerva_story.out)
}
