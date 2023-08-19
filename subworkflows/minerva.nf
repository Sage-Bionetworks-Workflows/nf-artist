include { autominerva_story } from "../modules/autominerva_story.nf"
include { render_pyramid } from "../modules/render_pyramid.nf"

he_story_file = file( "assets/he_story.json", checkIfExists: true)

workflow MINERVA {
  take:
  converted
  
  main:
  converted
    .filter {
      it[0].minerva && it[0].he
    }
    .map { it -> [it[0], it[1], he_story_file] }
    .set { he_story }

    converted
    .filter {
      it[0].minerva && it[0].he == false
    }
    .set { for_am }

  autominerva_story(for_am)
    .set { am_story }

  am_story.mix( he_story )
    .set { mixed }

  render_pyramid(mixed)
  
}
