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
			baseline: 'NgramModel'
			with: [ spec repository: 'github://pharo-ai/NgramModel/src' ].
			
		spec
			baseline: 'IdentifierNameSplitter'
			with: [ spec repository: 'github://olekscode/IdentifierNameSplitter/src' ].
				
		"Packages"
		spec 
			package: 'LanguageDetector' with: [ spec requires: #('NgramModel' 'IdentifierNameSplitter') ];
			package: 'LanguageDetector-Tests' with: [ spec requires: #('LanguageDetector') ] ].
]
