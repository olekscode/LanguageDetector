# LanguageDetector

[![Build status](https://github.com/olekscode/LanguageDetector/workflows/CI/badge.svg)](https://github.com/olekscode/LanguageDetector/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/olekscode/LanguageDetector/badge.svg?branch=master)](https://coveralls.io/github/olekscode/LanguageDetector?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/olekscode/LanguageDetector/master/LICENSE)

Detects the language of a text

## How to install it

To install `LanguageDetector`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'LanguageDetector';
  repository: 'github://olekscode/LanguageDetector/src';
  load.
```

## How to depend on it

If you want to add a dependency on `LanguageDetector` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'LanguageDetector'
  with: [ spec repository: 'github://olekscode/LanguageDetector/src' ].
```

## How to use it
