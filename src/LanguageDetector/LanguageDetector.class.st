Class {
	#name : #LanguageDetector,
	#superclass : #Object,
	#instVars : [
		'languageModels'
	],
	#category : #LanguageDetector
}

{ #category : #'as yet unclassified' }
LanguageDetector class >> languageModelDirectory [

	^ 'pharo-local/iceberg/olekscode/LanguageDetector/language-models/' asFileReference
]

{ #category : #initialization }
LanguageDetector >> availableLanguages [

	^ self class languageModelDirectory files collect: [ :each | each basenameWithoutExtension ]
]

{ #category : #initialization }
LanguageDetector >> initialize [ 
	super initialize.
	languageModels := Dictionary new.
	
	self loadLanguageModels: self availableLanguages.
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageOf: aString [

	^ (self logProbabilitiesOf: aString) keys first
]

{ #category : #'loading language models' }
LanguageDetector >> loadLanguageModel: aLanguageName [

	| file |
	file := self class languageModelDirectory / (aLanguageName, '.ston').
	^ NgramModel readFromFile: file.
]

{ #category : #initialization }
LanguageDetector >> loadLanguageModels: aCollectionOfLanguageNames [

	aCollectionOfLanguageNames do: [ :languageName |
		languageModels at: languageName put: (self loadLanguageModel: languageName) ]
]

{ #category : #'as yet unclassified' }
LanguageDetector >> logProbabilitiesOf: aString [

	| cleanSentence characters logProbabilities |
	cleanSentence := aString asCleanSentence.
	characters := cleanSentence asOrderedCollection.
	
	logProbabilities := OrderedCollection new.
	
	languageModels keysAndValuesDo: [ :languageName :languageModel |
		logProbabilities add: (languageName -> (languageModel logProbabilityOfText: characters)) ].
	
	^ (logProbabilities sorted: [ :a :b | a value > b value ]) asOrderedDictionary.
]
