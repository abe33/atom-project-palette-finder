fs = require 'fs'
path = require 'path'
temp = require 'temp'
wrench = require 'wrench'
Color = require 'pigments'
ProjectPaletteFinder = require '../lib/project-palette-finder'
{WorkspaceView} = require 'atom'

waitsForPromise = (fn) -> window.waitsForPromise timeout: 30000, fn

describe "ProjectPaletteFinder", ->

  beforeEach ->
    atom.project.setPaths([path.join(__dirname, 'fixtures')])

    tempPath = fs.realpathSync(temp.mkdirSync('atom'))
    fixturesPath = atom.project.getPaths()[0]
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPaths([tempPath])

    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage('project-palette-finder')

  it 'scans the project on activation', ->
    readyCallback = jasmine.createSpy('readyCallback')
    ProjectPaletteFinder.on 'palette:ready', readyCallback

    waitsFor -> readyCallback.callCount is 1

    runs ->
      palette = readyCallback.argsForCall[0][0]
      expect(palette).toBeDefined()

      expect(palette.items.length).toEqual(12)

      expect(Color.colorExpressions.palette).toBeDefined()

  describe 'palette:find-all-colors command', ->
    it 'scans the project to find every colors', ->
      readyCallback = jasmine.createSpy('readyCallback')
      ProjectPaletteFinder.on 'palette:search-ready', readyCallback

      atom.workspaceView.trigger('palette:find-all-colors')

      waitsFor -> readyCallback.callCount is 1

      runs ->
        palette = readyCallback.argsForCall[0][0]
        expect(palette).toBeDefined()

        expect(palette.items.length).toEqual(22)
