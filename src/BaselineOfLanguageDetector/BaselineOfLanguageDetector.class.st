Class {
	#name : #BaselineOfLanguageDetector,
	#superclass : #BaselineOf,
	#category : #BaselineOfLanguageDetector
}

{ #category : #baselines }
BaselineOfLanguageDetector >> baseline: spec [
	<baseline>
	spec for: #common do: [
		"External dependencies"
		spec
			baseline: 'WordFrequenciesCounter'
			with: [ spec repository: 'github://olekscode/WordFrequenciesCounter/src' ].
				
		"Packages"
		spec 
			package: 'LanguageDetector' with: [ spec requires: #('WordFrequenciesCounter') ];
			package: 'LanguageDetector-Tests' with: [ spec requires: #('LanguageDetector') ] ].
]
