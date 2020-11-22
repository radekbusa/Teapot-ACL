# 📜 Teapot-ACL
A minimalistic role-based ACL implementation for Teapot Smalltalk HTTP microframework.

## 🪄 Usage in a nutshell
```smalltalk
acl := TeaACL new
    addRole: #admin;
    addRole: #superadmin;
    addResource: '/documents';
    "it supports good ol' Teapot route globs"
    addResource: '/documents/<id>';
    "privileges could pretty much be anything suiting your needs - it's definitely not limited to HTTP verbs"
    allowRole: #admin toAccess: '/documents' withPrivileges: #(POST GET);
    allowRole: #admin toAccess: '/documents/<id>' withPrivileges: #(GET PUT DELETE);
    "it supports a shortcut to allow everything for a given role"
    allowRole: #superadmin toAccess: '*' withPrivileges: #(GET).

...

"returns true"
acl checkRole: #admin toAccess: '/documents?foo=bar&bar=baz' withPrivilege: #GET.
"superadmin is the god here. returns true"
acl checkRole: #superadmin toAccess: '/foo/bar' withPrivilege: #GET.
"nobody is allowed to access a route not matching to any glob. returns false"
acl checkRole: #admin toAccess: '/xxx' withPrivilege: #GET.
"a user with undeclared role is not allowed to access this. returns false"
acl checkRole: #outsider toAccess: '/documents' withPrivilege: #GET.
```

## 🎁 Installation
```smalltalk
Metacello new
    baseline: 'TeapotACL';
    repository: 'github://radekbusa/Teapot-ACL';
    load.
```

## 🔌 Integration example
1. Add this to application bootstrap by leveraging Teapot filters:
```smalltalk
teapot before: '*' -> [ :req | middleware checkAuthorization: req ];
```
2. Middleware>>checkAuthorization: aRequest
```smalltalk
| token userRole requestUri |
	
token := self getToken: aRequest.
userRole := token payload at: #role. "To be modified. User role is stored in a JSON Web Token in this scenario."
requestUri := aRequest uri asString.

"Config>>ACL contains a preconfigured TeaACL instance."
(config ACL checkRole: userRole toAccess: requestUri withPrivilege: aRequest method) ifFalse: [
	aRequest abort: (TeaResponse code: 403).
].
```

## 🧩 Compatibility
Tested in Pharo 7, 8 and 9.

## 👨‍💻 Author
Radek Busa is the author and maintainer of this project.
* Tech blog: [https://medium.com/@radekbusa](https://medium.com/@radekbusa)
* Hire me for your next Smalltalk project: [www.radekbusa.eu](www.radekbusa.eu)

> "I love building enterprise-grade software products in no time and Pharo greatly contributes to that with its amazing debugger, test-driven environment and other great stuff, such as refactoring tools. *My vision is to build libraries for ultra-productive enterprise microservice development with minimalistic and easy-to-grasp APIs for Smalltalk in 2020s.*"

If you endorse my vision and/or this project helped you, please don't hesitate to donate. Your donations will be welcome!

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate?hosted_button_id=Z5NNZTU7VASJQ)
