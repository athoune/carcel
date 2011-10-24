cArCeL
======

Simple ACL for Erlang.

Concept borowed from the Alcatraz ruby project.

## Concept

CarCel provides a matcher between ACL and action. Each are path like : a list of arbitrary values.

A simple example : for the site erlang.net, I can write the article 42 : `["erlang.net", article, 42, write]`.

You can use `'_'` as a joker. A corrector may have `['_', article, '_', write]` for spellchecking every articles.

Each path elements can be any type and *function* can be evaluated before comparing if you provide a *Context*.

If Acl is longer than the action, it always fails, it is too specific. Short Acl means great power:
an editor in chief may have `["erlange.net", article]` and be able to do what he wonts with every articles.

### Roles

The roles pattern is simple, it's a collection of ACLs. User's ACls is the concatenation of the Acls of his roles and his own Acls.

Carcel provides tools too simplify overlaping ACLs and sorting them.

### Relation

It may be boring to explicit each specific right of a user. If an *article* has 3 actions (write/publish/delete), 500 articles mean 1500 Acls?

You may use this Acl :

```erlang
Writer = [["erlang.net", article, '_', write, owner], ["erlang.net", article, '_', delete, owner]].
```

If I own this article, I can write it or delete it. The relation between the object and the user is beyond the scope of Acls management.

Ownership can be dynamicaly tested, with a simple function and a context with two values : the user and the object.

### Persistance

Carcel provides no persistance, just Acl/action checking. You have to store somewhere users, objects and Acls.

## Code

```erlang
true = carcel:can(["erlang.net", article, 42, write], ['_', article, '_', write]).
```

`carcel:can` try to match an *action* with *acl*.

`carcel:check` try to match an *action* with a list of *acls*.

If you provide a *Context* for `carcel:can` or `can:check`, *function* values will be evaluated.

## Licence

BSD.
