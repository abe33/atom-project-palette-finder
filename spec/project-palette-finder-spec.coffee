fs = require 'fs'
path = require 'path'
temp = require 'temp'
wrench = require 'wrench'
Color = require 'pigments'
ProjectPaletteFinder = require '../lib/project-palette-finder'

waitsForPromise = (fn) -> window.waitsForPromise timeout: 30000, fn

describe "ProjectPaletteFinder", ->

  beforeEach ->
    atom.project.setPath(path.join(__dirname, 'fixtures'))

    tempPath = fs.realpathSync(temp.mkdirSync('atom'))
    fixturesPath = atom.project.getPath()
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPath(tempPath)

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
