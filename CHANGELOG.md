<a name="v2.4.9"></a>
# v2.4.9 (2015-01-14)

## :bug: Bug Fixes

- Fix racing condition when the file is saved ([ee0d0f9c](https://github.com/abe33/atom-project-palette-finder/commit/ee0d0f9cc5fc279b5623f23f9b17e2036720da71))

<a name="v2.4.8"></a>
# v2.4.8 (2015-01-14)

## :bug: Bug Fixes

- Fix broken commands since change in pane's URI API ([61549b3b](https://github.com/abe33/atom-project-palette-finder/commit/61549b3bd3644064a7ac65a6b0ac031bca56e4d5))

<a name="v2.4.7"></a>
# v2.4.7 (2014-12-29)

## :bug: Bug Fixes

- Fix view regexp breaking with windows paths ([1a4adae2](https://github.com/abe33/atom-project-palette-finder/commit/1a4adae228b659c45c1a4db4a556faf789672f99), [#20](https://github.com/abe33/atom-project-palette-finder/issues/20))

<a name="v2.4.5"></a>
# v2.4.5 (2014-12-12)

## :bug: Bug Fixes

- Fix use of deprecated autocomplete-plus API ([490e42b5](https://github.com/abe33/atom-project-palette-finder/commit/490e42b52ba67ab21d2cb0fea1f6cd004faf1d2e))

<a name="v2.4.4"></a>
# v2.4.4 (2014-12-04)

## :bug: Bug Fixes

- Fix broken view when palette is sorted ([c02c6f9f](https://github.com/abe33/atom-project-palette-finder/commit/c02c6f9fe2b51e9d22ff30de50eb37cd22499b65), [#17](https://github.com/abe33/atom-project-palette-finder/issues/17))

<a name="v2.4.3"></a>
# v2.4.3 (2014-12-04)

## :bug: Bug Fixes

- Better version declaration for atom-space-pen-views ([3acc2cab](https://github.com/abe33/atom-project-palette-finder/commit/3acc2cabc075535806aef40079af5405e4a1a035))

<a name="v2.4.1"></a>
# v2.4.1 (2014-12-03)

## :bug: Bug Fixes

- Remove dead code in a view

<a name="v2.4.0"></a>
# v2.4.0 (2014-12-02)

## :sparkles: Features

- Add a scopes array in config to manage watched files ([f0588291](https://github.com/abe33/atom-project-palette-finder/commit/f05882918364ab202ad17053c7c90f1cd6a2d568), [#15](https://github.com/abe33/atom-project-palette-finder/issues/15))

## :bug: Bug Fixes

- Fix tooltip creation since deprecation of setTooltip ([e6195931](https://github.com/abe33/atom-project-palette-finder/commit/e61959319dded28f3ad3b577f9d0efcdfc19b07e))

## :racehorse: Performances

- Speed up startup by delaying requires ([a7858e1e](https://github.com/abe33/atom-project-palette-finder/commit/a7858e1ec0f6a0837ccc02175a7f5e100532a0eb))

<a name="v2.3.2"></a>
# v2.3.2 (2014-11-26)

## :bug: Bug Fixes

- Fix Color class is not the same instance in PaletteItem ([a158badb](https://github.com/abe33/atom-project-palette-finder/commit/a158badb9d3973cc494f1fb5d7f8db911d5ced31))

<a name="v2.3.1"></a>
# v2.3.1 (2014-11-26)

## :package: Dependencies

-  Update pigments version to 3.0.4

<a name="v2.3.0"></a>
# v2.3.0 (2014-11-26)

## :sparkles: Features

- Implement colors sort in the palette view ([79cece03](https://github.com/abe33/atom-project-palette-finder/commit/79cece033be2c235310c5ab5cc03648057369d0a))

<a name="v2.2.2"></a>
# v2.2.2 (2014-10-31)

## :bug: Bug Fixes

- Fix opacity of color suggestions preview ([932da65e](https://github.com/abe33/atom-project-palette-finder/commit/932da65ed3fe5942604c22f5787478fe69024b28))

<a name="v2.2.1"></a>
# v2.2.1 (2014-10-22)

## :bug: Bug Fixes

- Fix broken providers registration in latest Atom ([25a0648f](https://github.com/abe33/atom-project-palette-finder/commit/25a0648f04fa0e36fd8b90d69649ff27a136660d))

<a name="v2.2.0"></a>
# v2.2.0 (2014-10-16)

## :sparkles: Features

- Implement scope filtering for autocompletion provider ([f29f97e4](https://github.com/abe33/atom-project-palette-finder/commit/f29f97e4fb47a880a92907e0aff3b633df37aebd), [#13](https://github.com/abe33/atom-project-palette-finder/issues/13))

## :bug: Bug Fixes

- Fix empty view when search returns nothing ([099a9b19](https://github.com/abe33/atom-project-palette-finder/commit/099a9b19f8c034e83109beb342e14824a76fe866), [#12](https://github.com/abe33/atom-project-palette-finder/issues/12))

<a name="v2.1.2"></a>
# v2.1.2 (2014-10-15)

## :bug: Bug Fixes

- Fix pigments issue with variable names ([d3729235](https://github.com/abe33/atom-project-palette-finder/commit/d37292359f7600d14289c9370139730eacd9bdc4))

<a name="v2.1.1"></a>
# v2.1.1 (2014-10-15)

## :bug: Bug Fixes

- Fix unused pathwatcher dependency ([667cf0a1](https://github.com/abe33/atom-project-palette-finder/commit/667cf0a1aed24b4ce7b8b156f77b18f9873d840b))

<a name="v2.1.0"></a>
# v2.1.0 (2014-10-15)

## :sparkles: Features

- Add an autocomplete provider for palette colors ([54dbdbf7](https://github.com/abe33/atom-project-palette-finder/commit/54dbdbf75d1ab907422646eb76387f150450cb8f))

## :bug: Bug Fixes

- Fix broken insertion of selected color ([29977978](https://github.com/abe33/atom-project-palette-finder/commit/299779787fe23a87bf84e2344f27f1fad8a0865d))


<a name="v2.0.1"></a>
# v2.0.1 (2014-10-14)

## :bug: Bug Fixes

- Fix engine version in package.json ([4e638644](https://github.com/abe33/atom-project-palette-finder/commit/4e6386447702819b258a603f7118054b33f41360))


<a name="v2.0.0"></a>
# v2.0.0 (2014-10-14)

## :sparkles: Features

- Add a project-wide color search view like find-and-replace ([46d119b6](https://github.com/abe33/atom-project-palette-finder/commit/46d119b6ec62385634753bc73292cdcac995bc02))

## :bug: Bug Fixes

- Fix bad class name in declaration ([899d0b4b](https://github.com/abe33/atom-project-palette-finder/commit/899d0b4bf883a806b426ed1e5a7f37cb472a2e44))
- Fix left margin of code sample in palette view ([ea9409cb](https://github.com/abe33/atom-project-palette-finder/commit/ea9409cb56cea88fc2e1fa0fc1898d34d12a30f9))
- Fix deprecations ([fb65bbfb](https://github.com/abe33/atom-project-palette-finder/commit/fb65bbfba4e970b91d8aba82d4fda086a3cf448e))

<a name="v1.0.4"></a>
# v1.0.4 (2014-09-18)

## :bug: Bug Fixes

- Fix broken palette view due to removed API ([05cc5e49](https://github.com/abe33/atom-project-palette-finder/commit/05cc5e49d60a34ea59a0d204fc9ef461e442061c), [#10](https://github.com/abe33/atom-project-palette-finder/issues/10))

<a name="1.0.2"></a>
# 1.0.2 (2014-08-19)

## :bug: Bug Fixes

- Fix deprecated method call ([c616ab83](https://github.com/abe33/atom-project-palette-finder/commit/c616ab83df274550be2d4377c2c514983e20206c), [#7](https://github.com/abe33/atom-project-palette-finder/issues/7))

<a name="v1.0.0"></a>
# v1.0.0 (2014-08-04)

## :sparkles: Features

- Add support for pigments 2.0.0 and Atom 0.120.0 ([c53df1b5](https://github.com/abe33/atom-project-palette-finder/commit/c53df1b5ec39d6d518cc57f3e9fa651e7b33a289))

<a name="v0.6.2"></a>
# v0.6.2 (2014-07-30)

## :bug: Bug Fixes

- Fix missing match for color followed by a class selector ([cc92621a](https://github.com/abe33/atom-project-palette-finder/commit/cc92621a7aa9d0c718676593d734e5c606fc12d0))

<a name="v0.6.0"></a>
# v0.6.0 (2014-07-10)

## :sparkles: Features

- Implement lazy access to a PaletteItem color ([01793aff](https://github.com/abe33/atom-project-palette-finder/commit/01793aff11558653d7fda5d81789e5c1089694a3))
  <br>It reduces the risk of error when a palette item is defined before another item it references.

<a name="v0.5.2"></a>
# v0.5.2 (2014-05-28)

## :bug: Bug Fixes

- Fix missing native event for copying data from palette ([17e09a2f](https://github.com/abe33/atom-project-palette-finder/commit/17e09a2fe4748046efcd3bfdf08e66830c44d5ef))

<a name="v0.5.0"></a>
# v0.5.0 (2014-05-28)

## :sparkles: Features

- Adds list controls and stats in palette view ([daf99ae2](https://github.com/abe33/atom-project-palette-finder/commit/daf99ae27f9c544ef0fc94709b5441c7c8a84285))


<a name="v0.4.1"></a>
# v0.4.1 (2014-05-28)

## :bug: Bug Fixes

- Fixes screenshot path ([2d36ed20](https://github.com/abe33/atom-project-palette-finder/commit/2d36ed208620b50b902a58740261c2e1b46cf26d))


<a name="v0.4.0"></a>
# v0.4.0 (2014-05-28)

## :sparkles: Features

- Adds a palette view available with palette:view command ([d79884b7](https://github.com/abe33/atom-project-palette-finder/commit/d79884b718535d6c9b7e329ae8041369f439e383))

## :bug: Bug Fixes

- Fixes search failure with lines containing comments ([13578791](https://github.com/abe33/atom-project-palette-finder/commit/13578791448ef6b2767ee92aef4d3aafda61be7f))


<a name="v0.3.1"></a>
# v0.3.1 (2014-05-28)

## :bug: Bug Fixes

- Fixes documentation ([7d83fe56](https://github.com/abe33/atom-project-palette-finder/commit/7d83fe5619b513351e80dd8d131b4c07ffd0059a))


<a name="v0.3.0"></a>
# v0.3.0 (2014-05-28)

## :sparkles: Features

- Adds proper documentation in README ([c2563c4d](https://github.com/abe33/atom-project-palette-finder/commit/c2563c4d5a11ee990cedbcea5da6fc6ecb78e235))


<a name="v0.1.0"></a>
# v0.1.0 (2014-05-28)

## :sparkles: Features

- Implements palette item creation and serialization ([9746a7e0](https://github.com/abe33/atom-project-palette-finder/commit/9746a7e0c71fb76252272d801d5b10bdeddb59e5))
- Adds pigments dependency ([b7e88622](https://github.com/abe33/atom-project-palette-finder/commit/b7e88622c443e685273638ba3caa438bc48dc819))
