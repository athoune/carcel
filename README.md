cArCeL
======

Simple ACL for Erlang.

Concept borowed from the Alcatraz ruby project.

Concept
-------

CarCel provides a matcher between ACL and action. Each are path like.

A simple example : for the site erlang.net, I can write the article 42 : `["erlang.net", article, 42, write]`.

You can use `'_'` as a joker. A corrector may have `[_, article, _, write]` for spellchecking every articles.

ACL and action don't have to have the same length : an editor in chief may have `["erlange.net", article]`,
connecting the admin page may needs `["erlang.net"]`.

Code
----

```erlang
true = carcel:can(["erlang.net", article, 42, write], ['_', article, '_', write]).
```

`carcel:can` try to match an *action* with *acl*.

`carcel:check` try to match an *action* with a list of *acls*.

Licence
-------

BSD.
