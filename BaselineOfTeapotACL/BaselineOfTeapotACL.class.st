"
Baseline of TeapotACL project.
"
Class {
	#name : #BaselineOfTeapotACL,
	#superclass : #BaselineOf,
	#category : #BaselineOfTeapotACL
}

{ #category : #baselines }
BaselineOfTeapotACL >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"deps"
			spec baseline: 'Teapot' with: [ spec repository: 'github://zeroflag/Teapot:v2.6.0/source' ].
			
			"project packages"
			spec package: 'TeapotACL' with: [ spec requires: #('Teapot') ].
		].

]

{ #category : #accessing }
BaselineOfTeapotACL >> projectClass [
	^ MetacelloCypressBaselineProject.

]
