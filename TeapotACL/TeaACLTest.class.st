"
An ACLTest is a test class for testing the behavior of ACL
"
Class {
	#name : #TeaACLTest,
	#superclass : #TestCase,
	#instVars : [
		'acl'
	],
	#category : #'TeapotACL-Tests'
}

{ #category : #running }
TeaACLTest >> setUp [
	acl := TeaACL new.

]

{ #category : #tests }
TeaACLTest >> testAllowRoleToAccessWithPrivileges [

	acl := TeaACL new
		addRole: #admin;
		addRole: #superadmin;
		addResource: '/documents';
		addResource: '/documents/<id>';
		addResource: '/documents/_actions/setAllAsNew';
		addResource: '/documents/<id>/_actions/markAsPaid';
		allowRole: #admin toAccess: '/documents' withPrivileges: #(POST GET);
		allowRole: #admin toAccess: '/documents/<id>' withPrivileges: #(GET PUT DELETE);
		allowRole: #admin toAccess: '/documents/_actions/setAllAsNew' withPrivileges: #(POST);
		allowRole: #admin toAccess: '/documents/<id>/_actions/markAsPaid' withPrivileges: #(POST);
		allowRole: #superadmin toAccess: '*' withPrivileges: #(GET).

	self assert: (acl checkRole: #admin toAccess: '/documents' withPrivilege: #GET) equals: true.
	self assert: (acl checkRole: #admin toAccess: '/documents' withPrivilege: #PUT) equals: false.
	self assert: (acl checkRole: #admin toAccess: '/xxx' withPrivilege: #GET) equals: false.
	self assert: (acl checkRole: #outsider toAccess: '/documents' withPrivilege: #GET) equals: false.
	"should work with URIs containing query parameters"
	self assert: (acl checkRole: #admin toAccess: '/documents?foo=bar&bar=baz' withPrivilege: #GET) equals: true.
	"should work with URIs containing fragments"
	self assert: (acl checkRole: #admin toAccess: '/documents#foo' withPrivilege: #GET) equals: true.
	"should match URI path param wildcard"
	self assert: (acl checkRole: #admin toAccess: '/documents/123' withPrivilege: #GET) equals: true.
	"should match * wildcard"
	self assert: (acl checkRole: #superadmin toAccess: 'foo' withPrivilege: #GET) equals: true.
	self assert: (acl checkRole: #superadmin toAccess: 'foo' withPrivilege: #POST) equals: false.

]

{ #category : #tests }
TeaACLTest >> testInitialization [
	acl addRole: #admin.
	acl addResource: '/'.
	
	self should: [
		acl allowRole: #admin toAccess: '/foo' withPrivileges: #().
	] raise: Error description: 'Resource not defined.'.

	self shouldnt: [
		acl allowRole: #admin toAccess: '/' withPrivileges: #().
	] raise: Error.

]
