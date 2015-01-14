fs = require 'fs'
path = require 'path'
temp = require 'temp'
wrench = require 'wrench'
Color = require 'pigments'
ProjectPaletteFinder = require '../lib/project-palette-finder'

waitsForPromise = (fn) -> window.waitsForPromise timeout: 30000, fn

describe "ProjectPaletteFinder", ->
  [workspaceElement] = []

  beforeEach ->
    atom.project.setPaths([path.join(__dirname, 'fixtures')])

    tempPath = fs.realpathSync(temp.mkdirSync('atom'))
    fixturesPath = atom.project.getPaths()[0]
    wrench.copyDirSyncRecursive(fixturesPath, tempPath, forceDelete: true)
    atom.project.setPaths([tempPath])

    atom.config.set('project-palette-finder.saveWatchersScopes', [
      'text.plain.null-grammar'
    ])

    waitsForPromise ->
      atom.packages.activatePackage('project-palette-finder')

  it 'scans the project on activation', ->
    readyCallback = jasmine.createSpy('readyCallback')
    ProjectPaletteFinder.onDidUpdatePalette readyCallback

    waitsFor -> readyCallback.callCount is 1

    runs ->
      palette = readyCallback.argsForCall[0][0]
      expect(palette).toBeDefined()

      expect(palette.items.length).toEqual(12)

      expect(Color.colorExpressions.palette).toBeDefined()

  describe 'when an editor is opened', ->
    [editor] = []
    describe 'with a supported file', ->
      beforeEach ->
        waitsFor ->
          atom.workspace.open('palette.less')

        runs ->
          workspaceElement = atom.views.getView(atom.workspace)
          jasmine.attachToDOM(workspaceElement)

          atom.workspace.getActivePane().activateNextItem()

        waitsFor ->
          editor = atom.workspace.getActiveTextEditor()

      it 'refreshes the palette on save', ->
        spyOn(ProjectPaletteFinder, 'scanProject')

        editor.getBuffer().emitter.emit('did-save')

        expect(ProjectPaletteFinder.scanProject).toHaveBeenCalled()

    describe 'with a unsupported file', ->
      beforeEach ->
        waitsFor ->
          atom.config.set('project-palette-finder.saveWatchersScopes', [])
          atom.workspace.open('sample.coffee')

        runs ->
          workspaceElement = atom.views.getView(atom.workspace)
          jasmine.attachToDOM(workspaceElement)

          atom.workspace.getActivePane().activateNextItem()

        waitsFor ->
          editor = atom.workspace.getActiveTextEditor()

      it 'does not refresh the palette on save', ->
        spyOn(ProjectPaletteFinder, 'scanProject')

        editor.getBuffer().emitter.emit('did-save')

        expect(ProjectPaletteFinder.scanProject).not.toHaveBeenCalled()


  describe 'palette:find-all-colors command', ->
    it 'scans the project to find every colors', ->
      readyCallback = jasmine.createSpy('readyCallback')
      ProjectPaletteFinder.onDidFindColors readyCallback

      atom.commands.dispatch(workspaceElement, 'palette:find-all-colors')

      waitsFor -> readyCallback.callCount is 1

      runs ->
        palette = readyCallback.argsForCall[0][0]
        expect(palette).toBeDefined()

        expect(palette.items.length).toEqual(22)
