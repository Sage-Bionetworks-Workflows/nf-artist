include { autominerva_story } from "../modules/autominerva_story.nf"
include { render_pyramid } from "../modules/render_pyramid.nf"

workflow MINERVA {
  take:
  converted

  main:
  // If H&E, used a fixed story from the assets dir
  he_story = converted
    .filter { meta, _image -> meta.minerva && meta.he }
    .map { meta, image -> [meta, image, file("$projectDir/assets/he_story.json", checkIfExists: true)] }

  // If not H&E, run auto-minerva
  auto_story = converted
    .filter { meta, _image -> meta.minerva && !meta.he }

  // Mix with the `he_story` channel and render the pyramid
  autominerva_story(auto_story)
  render_pyramid(autominerva_story.out.mix(he_story))
}
