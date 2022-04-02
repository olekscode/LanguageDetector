Class {
	#name : #LanguageDetector,
	#superclass : #Object,
	#instVars : [
		'wordFrequencies',
		'priorLanguageProbabilities',
		'wordsPerLanguage'
	],
	#category : #LanguageDetector
}

{ #category : #'as yet unclassified' }
LanguageDetector class >> languagesDirectory [

	^ 'pharo-local/iceberg/olekscode/LanguageDetector/languages/' asFileReference
]

{ #category : #initialization }
LanguageDetector >> availableLanguages [

	^ self class languagesDirectory files
		select: [ :file | file extension = 'csv' ]
		thenCollect: [ :file | file basenameWithoutExtension ]
]

{ #category : #'as yet unclassified' }
LanguageDetector >> calculateNumberOfWordsInLanguage: aLanguageName [
	"Total number of word occurences, not just the number of words in a dictionary"
	
	^ (wordFrequencies at: aLanguageName) values sum.
]

{ #category : #'as yet unclassified' }
LanguageDetector >> calculateNumberOfWordsInLanguages [
	"Total number of word occurences, not just the number of words in a dictionary"
	
	wordsPerLanguage := (self languageNames collect: [ :languageName |
		languageName -> (self calculateNumberOfWordsInLanguage: languageName) ]) asDictionary
]

{ #category : #'as yet unclassified' }
LanguageDetector >> calculatePriorLanguageProbabilities [

	priorLanguageProbabilities := (self languageNames collect: [ :languageName |
		languageName -> (self calculatePriorLanguageProbabilityOf: languageName) ]) asDictionary
]

{ #category : #'as yet unclassified' }
LanguageDetector >> calculatePriorLanguageProbabilityOf: aLanguageName [

	| languageWords wordsInAllLanguages |
	
	languageWords := (wordFrequencies at: aLanguageName) values sum.
	
	wordsInAllLanguages := wordFrequencies values inject: 0 into: [ :sum :frequencies |
		sum + frequencies values sum ].
	
	^ languageWords / wordsInAllLanguages
]

{ #category : #initialization }
LanguageDetector >> initialize [ 
	super initialize.
	wordFrequencies := Dictionary new.
	
	self loadLanguages: self availableLanguages.
	
	self calculatePriorLanguageProbabilities.
	self calculateNumberOfWordsInLanguages.
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageNames [

	^ wordFrequencies keys
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageOfWord: aWord [

	^ (self languageProbabilitiesForWord: aWord) keys first
]

{ #category : #'as yet unclassified' }
LanguageDetector >> languageProbabilitiesFor: aString [

	| words languageNames average probabilities averageProbabilities |
	
	words := aString validLowercaseWords.
	languageNames := self languageNames.
	
	words ifEmpty: [
		^ (languageNames collect: [ :languageName | languageName -> 0.0 ]) asOrderedDictionary ].
	
	probabilities := words collect: [ :word |
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
	
	probabilities := self languageNames collect: [ :languageName |
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
LanguageDetector >> numberOfWordsInAllLanguages [
	"Total number of word occurences, not just the number of words in a dictionary"

	^ wordsPerLanguage values sum
]

{ #category : #'as yet unclassified' }
LanguageDetector >> numberOfWordsInLanguage: aLanguageName [
	"Total number of word occurences, not just the number of words in a dictionary"

	^ wordsPerLanguage at: aLanguageName
]

{ #category : #'as yet unclassified' }
LanguageDetector >> priorProbabilityOfLanguage: aLanguageName [

	^ priorLanguageProbabilities at: aLanguageName
]

{ #category : #'as yet unclassified' }
LanguageDetector >> priorProbabilityOfWord: aWord [

	| countInAllLanguages |
	
	countInAllLanguages := wordFrequencies inject: 0 into: [ :sum :frequencies |
		sum + (frequencies at: aWord ifAbsent: [ 0 ]) ].
	
	^ countInAllLanguages / self numberOfWordsInAllLanguages 
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfLanguage: aLanguageName forWord: aWord [

	| probabilityOfWordInLanguage probabilityOfLanguage probabilityOfWord |
	
	probabilityOfWordInLanguage := self probabilityOfWord: aWord inLanguage: aLanguageName.
	probabilityOfLanguage := self priorProbabilityOfLanguage: aLanguageName.
	probabilityOfWord := self priorProbabilityOfWord: aWord.
	
	probabilityOfWord = 0 ifTrue: [ ^ 0 ].
	
	^ probabilityOfWordInLanguage * probabilityOfLanguage / probabilityOfWord asFloat
]

{ #category : #'as yet unclassified' }
LanguageDetector >> probabilityOfWord: aWord inLanguage: aLanguageName [

	| frequencies count total |
	frequencies := wordFrequencies at: aLanguageName.
	
	count := frequencies at: aWord ifAbsent: [ 0 ].
	total := self numberOfWordsInLanguage: aLanguageName.
	
	^ count / total
]
