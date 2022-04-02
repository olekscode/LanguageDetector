Class {
	#name : #BaselineOfLanguageDetector,
	#superclass : #BaselineOf,
	#category : #BaselineOfLanguageDetector
}

{ #category : #baselines }
BaselineOfLanguageDetector >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'LanguageDetector';
			package: 'LanguageDetector-Tests' with: [ spec requires: #('LanguageDetector') ] ].
]
