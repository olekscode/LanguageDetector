Extension { #name : #String }

{ #category : #'*LanguageDetector' }
String >> asCleanSentence [
	"Convert to lowercase, replace all whitespaces with spaces, split identifier names into words, remove all non-alphabetic characters"
	
	| tokens words |

	tokens := self substrings.
	tokens := tokens flatCollect: [ :token | token splitIdentifierName ].
	
	words := tokens
		select: [ :token | token allSatisfy: [ :character | character isLetter ] ]
		thenCollect: [ :word | word asLowercase ].
	
	^ ' ' join: words
	
	
]
