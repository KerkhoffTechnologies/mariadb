=====
mariadb
=====

Install the MariaDB client and/or server.
This is based on the SaltStack MySQL formula

.. note::

   See the full `Salt Formulas installation and usage instructions
   <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``mariadb``
---------

Meta-state that includes all server packages in the correct order.

This meta-state does **not** include ``mariadb.remove_test_database``; see
below for details.

``mariadb.client``
----------------

Install the MariaDB client package.

``mariadb.server``
----------------

Install the MariaDB server package and start the service.

Debian OS family supports setting MariaDB root password during install via
debconf.

.. note::

    If no root password is provided in the pillar, a random one will
    be created. Because Hydrogen doesn't have easy access to a random
    function (test.rand_str isn't introduced until Helium), instead,
    we use the not-at-all random ``grains.server_id``. As this is
    cryptographically insecure, future formula versions should use the
    newly available ``random.get_str`` method.

``mariadb.disabled``
------------------

Ensure that the MariaDB service is not running.

``mariadb.database``
------------------

Create and manage MariaDB databases.

``mariadb.python``
----------------

Install mariadb python bindings.

``mariadb.user``
--------------

Create and manage MariaDB database users with definable GRANT privileges.

The state accepts MariaDB hashed passwords or clear text. Hashed password have
priority.

.. note::
    See the `salt.states.mariadb_user
    <http://docs.saltstack.com/en/latest/ref/states/all/salt.states.mariadb_user.html#module-salt.states.mariadb_user>`_
    docs for additional information on configuring hashed passwords.

    Make sure to **quote the passwords** in the pillar so YAML doesn't throw an exception.

``mariadb.remove_test_database``
------------------------------

.. warning::

   Do not use this state if your MariaDB instance has a database in use called ``test``.
   If you do, it will be irrevocably removed!

Remove the database called ``test``, normally created as part of a default
MariaDB installation.  This state is **not** included as part of the meta-state
above as this name may conflict with a real database.

``mariadb.dev``
-------------

Install the MariaDB development libraries and header files.

.. note::
    Note that this state is not installed by the mariadb meta-state unless you set
    your pillar data accordingly.

``mariadb.repo``
--------------

Add the official MariaDB repository.

.. note::
    Note that this state currently only supports MariaDB 5.7 for RHEL systems.
    Debian and Suse support to be added. Also need to add the option to allow
    selection of MariaDB version (5.6 and 5.5 repos are added but disabled) and
    changed enabled repository accordingly.
