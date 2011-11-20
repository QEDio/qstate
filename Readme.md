Qaram
========================

Qaram (like param but with a q) attempts to provide an easy way to keep all of your applications state information, basically the URL-Parameters, in one place.

It does so by providing different classes for different types of parameters like:
 * Date/DateTime
 * Rails parameters (action, controller)
 * Query parameters (database where parameters)
 * Confidential parameters (user name, pub/priv key)
 * View parameters (similar to Rails, but not specific for rails)

Qaram will serialize/deserialize it's stored information as/from
 * String (URL)
 * Hash or
 * JSON



Overview
----------------

Marbu contains three destinct parts

1. The MapReduceModel which creates the necessary objects for the MapReduceBuilder
2. The map-reduce core functionality: this creates map reduce code for different map reduce systems
3. A Sinatra App which lets you instantly play around with the builder and shows you what you can do.
