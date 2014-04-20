ProjectPaletteFinder = require '../lib/project-palette-finder'
Color = require 'pigments'
path = require 'path'
waitsForPromise = (fn) -> window.waitsForPromise timeout: 30000, fn

describe "ProjectPaletteFinder", ->

  beforeEach ->
    atom.project.setPath(path.join(__dirname, 'fixtures'))

    waitsForPromise ->
      atom.packages.activatePackage('project-palette-finder')

  it 'scan', ->
    readyCallback = jasmine.createSpy('readyCallback')
    ProjectPaletteFinder.on 'palette:ready', readyCallback

    waitsFor -> readyCallback.callCount is 1

    runs ->
      palette = readyCallback.argsForCall[0][0]
      expect(palette).toBeDefined()

      expect(palette.items.length).toEqual(12)
