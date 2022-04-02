Class {
	#name : #LanguageDetector,
	#superclass : #Object,
	#instVars : [
		'wordFrequencies'
	],
	#category : #LanguageDetector
}

{ #category : #'as yet unclassified' }
LanguageDetector class >> languagesDirectory [

	^ 'pharo-local/iceberg/olekscode/LanguageDetector/languages/' asFileReference
]

{ #category : #initialization }
LanguageDetector >> availableLanguages [

	^ self class languagesDirectory files collect: [ :each | each basenameWithoutExtension ]
]

{ #category : #initialization }
LanguageDetector >> initialize [ 
	super initialize.
	wordFrequencies := Dictionary new.
	
	self loadLanguages: self availableLanguages.
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageOfWord: aWord [

	^ (self languageProbabilitiesForWord: aWord) keys first
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageProbabilitiesFor: aString [

	| words languageNames average probabilities averageProbabilities |
	
	words := aString validLowercaseWords.
	languageNames := wordFrequencies keys.
	
	words ifEmpty: [
		^ (languageNames collect: [ :languageName | languageName -> 0.0 ]) asOrderedDictionary ].
	
	probabilities := (1 to: words size) collect: [ :word |
		self languageProbabilitiesForWord: word ].
	
	averageProbabilities := (languageNames collect: [ :languageName | 
		average := 1 / words size * 
			((1 to: words size) inject: 0 into: [ :sum :i |
				sum + ((probabilities at: i) at: languageName) ]).
		
		languageName -> average ]) asDictionary.
	
	averageProbabilities at: 'other' put: (1 - averageProbabilities values sum).
	
	^ (averageProbabilities associations sorted: [ :a :b | a value > b value ]) asOrderedDictionary
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageProbabilitiesForWord: aWord [

	| probabilities |
	
	probabilities := wordFrequencies keys collect: [ :languageName |
		languageName -> (self probabilityOfLanguage: languageName forWord: aWord) ].
	
	probabilities sort: [ :a :b | a value > b value ].
	^ probabilities asOrderedDictionary.
]

{ #category : #initialization }
LanguageDetector >> loadLanguages: aCollectionOfLanguageNames [

	aCollectionOfLanguageNames do: [ :languageName |
		wordFrequencies at: languageName put: (self loadWordFrequenciesFor: languageName) ]
]

{ #category : #'loading language models' }
LanguageDetector >> loadWordFrequenciesFor: aLanguageName [

	| file row frequencies |
	file := self class languagesDirectory / (aLanguageName, '.csv').
	
	frequencies := (file contents lines collect: [ :line |
		row := line substrings: ','.
		row first -> row second asInteger ]) asOrderedDictionary.
	
	frequencies := frequencies select: [ :count | count >= 10 ].
	
	^ frequencies
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfLanguage: aLanguageName [

	| languageWords wordsInAllLanguages |
	
	languageWords := (wordFrequencies at: aLanguageName) values sum.
	
	wordsInAllLanguages := wordFrequencies values inject: 0 into: [ :sum :frequencies |
		sum + frequencies values sum ].
	
	^ languageWords / wordsInAllLanguages
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfLanguage: aLanguageName forWord: aWord [

	| probabilityOfWordInLanguage probabilityOfLanguage probabilityOfWord |
	
	probabilityOfWordInLanguage := self probabilityOfWord: aWord inLanguage: aLanguageName.
	probabilityOfLanguage := self probabilityOfLanguage: aLanguageName.
	probabilityOfWord := self probabilityOfWord: aWord.
	
	probabilityOfWord = 0 ifTrue: [ ^ 0 ].
	
	^ probabilityOfWordInLanguage * probabilityOfLanguage / probabilityOfWord asFloat
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfWord: aWord [

	| countInAllLanguages wordsInAllLanguages |
	
	countInAllLanguages := wordFrequencies inject: 0 into: [ :sum :frequencies |
		sum + (frequencies at: aWord ifAbsent: [ 0 ]) ].
	
	wordsInAllLanguages := wordFrequencies values inject: 0 into: [ :sum :frequencies |
		sum + frequencies values sum ].
	
	^ countInAllLanguages / wordsInAllLanguages 
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfWord: aWord inLanguage: aLanguageName [

	| frequencies count total |
	frequencies := wordFrequencies at: aLanguageName.
	
	count := frequencies at: aWord ifAbsent: [ 0 ].
	total := frequencies values sum.
	
	^ count / total
]
