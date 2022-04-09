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

```Smalltalk
detector := LanguageDetector new.

detector languageProbabilitiesFor: 'Hello world!'.
"an OrderedDictionary(
    'english'->0.9486880624525642
    'spanish'->0.01951642632549062
    'german'->0.017971375908055948
    'french'->0.01382413531388919
    'other'->0.0)"

detector languageOf: 'Hello world!'. "'english'"
detector languageOf: 'Bonjour, ça va ?'. "'french'"
detector languageOf: 'Ich heiße Hans'. "'german'"
detector languageOf: 'Yo como los platanos'. "'spanish'"
```
