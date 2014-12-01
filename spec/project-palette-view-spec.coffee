fs = require 'fs'
path = require 'path'
temp = require 'temp'
wrench = require 'wrench'
Color = require 'pigments'
ProjectPaletteFinder = require '../lib/project-palette-finder'

waitsForPromise = (fn) -> window.waitsForPromise timeout: 30000, fn

describe 'ProjectPaletteView', ->
  [workspaceElement] = []

  beforeEach ->
    atom.project.setPaths([path.join(__dirname, 'fixtures')])

    tempPath = fs.realpathSync(temp.mkdirSync('atom'))
    fixturesPath = atom.project.getPaths()[0]
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPaths([tempPath])
    readyCallback = null

    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage('project-palette-finder')

    runs ->
      readyCallback = jasmine.createSpy('readyCallback')
      ProjectPaletteFinder.on 'palette:ready', readyCallback

    waitsFor -> readyCallback.callCount is 1

  describe 'when palette:view command is triggered', ->
    it 'should have created a pane with the palette ui', ->
      paletteView = null
      runs ->
        atom.commands.dispatch workspaceElement, "palette:view"

      waitsFor ->
        paletteView = workspaceElement.querySelector('.palette')
        paletteView?

      runs ->
        expect(paletteView.querySelectorAll('.color').length).toEqual(12)
