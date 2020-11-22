"
I represent an access control list for a resource-oriented web application.
I aim to have a minimalistic API and to declare the access control list in an elegant way.

I know about all the roles and resources in the system I will control access to.

Kindly see the TeapotACLTests class for usage examples.

Author & Maintainer: Radek Busa (www.radekbusa.eu, me@radekbusa.eu)
Pull requests and Issue reports are welcome, file them to https://github.com/radekbusa/Teapot-ACL

-=-=-= Integration example with Teapot before-filter =-=-=-
1. application bootstrap:
before: '*' -> [ :req | middleware checkAuthorization: req ];

2. Middleware>>checkAuthorization: aRequest
| token userRole requestUri |
	
token := self getToken: aRequest. ""To be modified. User role is stored in a JSON Web Token in this scenario.""
											""Can be switched to SESSION storage or by retrieving userRole from a persistent storage...""
userRole := token payload at: #role.
requestUri := aRequest uri asString.

""Config>>ACL contains a preconfigured TeaACL instance.""
(config ACL checkRole: userRole toAccess: requestUri withPrivilege: aRequest method) ifFalse: [
	aRequest abort: (TeaResponse code: 403).
].

"
Class {
	#name : #TeaACL,
	#superclass : #Object,
	#instVars : [
		'roles',
		'resources',
		'acl'
	],
	#category : #'TeapotACL-ACL'
}

{ #category : #adding }
TeaACL >> addResource: aString [
	"Will declare a resource to be used. Each resource must be declared prior to expressing ACL rule.
	Resource '*' does not need to be declared, however, use it with caution!
	Resource can contain Teapot URL glob patterns, such as /documents/<id>, *, etc."
	resources add: aString.

]

{ #category : #adding }
TeaACL >> addRole: aString [
	"Will declare a role to be used. Each role must be declared prior to expressing ACL rule."
	roles add: aString.

]

{ #category : #'access control' }
TeaACL >> allowRole: aRole toAccess: aResource withPrivileges: privileges [
	"Will define ACL rule.
	Resource should be declared using addResource: prior to calling this method.
	Privileges are a collection of symbols - can be used for different scenarios -
	in RESTful APIs with endpoint-defined security a privilege could be HTTP verb - #GET, #POST, etc.
	You could, however, use privileges as you want - they could be capabilities - #create, #maskAsPaid, etc."
	| resourceMatcher |

	(roles includes: aRole) ifFalse: [ Error new messageText: 'Role not defined.'; signal. ].
	
	aResource = '*' ifFalse: [ 
		(resources includes: aResource) ifFalse: [ Error new messageText: 'Resource not defined.'; signal. ].
	].
	
	resourceMatcher := TeaGlobUrlPattern parseString: aResource.
	
	acl at: {aRole. resourceMatcher} put: privileges.

]

{ #category : #'access checks' }
TeaACL >> checkRole: aRole toAccess: aResource withPrivilege: aPrivilege [
	"After having defined the ACL using addResource: addRole: and allowRole:toAccess:withPrivileges: methods,
	this method should be used to check the access for particular role, particular resource and particular privilege.
	Returns a Boolean - true = has access, false = access denied."
	| privileges resourceUrl |
	
	resourceUrl := ZnUrl fromString: aResource.
	
	acl keysDo: [ :key |
		| aclRole aclResource |
		aclRole := key at: 1.
		aclResource := key at: 2.
		
		((aclRole = aRole) & (aclResource matchesUrl: resourceUrl placeholders: Dictionary new)) ifTrue: [
			privileges := acl at: key.
		].
	].
	
	privileges ifNil: [ ^ false ].
	
	^ (privileges includes: aPrivilege).

]

{ #category : #initialization }
TeaACL >> initialize [
	acl := Dictionary new.
	resources := Set new.
	roles := Set new.

]
