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
			spec configuration: 'Teapot' with: [ spec versionString: #'stable'; repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main'
		].
	].

]

{ #category : #accessing }
BaselineOfTeapotACL >> projectClass [
	^ MetacelloCypressBaselineProject.

]
