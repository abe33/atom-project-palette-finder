ProjectPaletteFinder = require '../lib/project-palette-finder'

describe "ProjectPaletteFinder", ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('projectPaletteFinder')
