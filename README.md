# Overview

DokuWiki is a simple to use and highly versatile Open Source wiki software that
doesn't require a database. It is loved by users for its clean and readable
syntax. The ease of maintenance, backup and integration makes it an
administrator's favorite. Built in access controls and authentication connectors
make DokuWiki especially useful in the enterprise context and the large number
of plugins contributed by its vibrant community allow for a broad range of use
cases beyond a traditional wiki.

# Usage

    $ juju deploy cs:dokuwiki

## Set the admin username

    $ juju config dokuwiki admin_user="my_admin"

## Generate a new password for the admin user

The easiest way to generate a new password is via the `mkpasswd` command which
is provided in the `whois` package:

    $ sudo apt install whois
    $ mkpasswd -m sha-512 my_new_password@@@
    $6$0zZwr8m.$K9kPKN4WpeViQ1F/B4QsBeZIP.4z8i0UNQctXtp8c8ibRIQ6Tn.BUuxI/.tM9NU0yLzLxBPcp7NXTLKkd4f5d1
    $ juju config dokuwiki admin_password='$6$0zZwr8m.$K9kPKN4WpeViQ1F/B4QsBeZIP.4z8i0UNQctXtp8c8ibRIQ6Tn.BUuxI/.tM9NU0yLzLxBPcp7NXTLKkd4f5d1'

# Developers

This charm uses Rake (a make like utility) for defining hooks and can be seen in
the **Rakefile**. It also uses a simple library **Charmkit** for providing some
additional helper methods such as templating.

To learn more visit [Charmkit](https://github.com/charmkit/charmkit).


# Maintainers

## Testing

The tests cover installation and verification that Dokuwiki is installed and
running correctly. It'll also excercise the various `juju config` options along
with automating the login of new user credentials for the admin account.

## Ways to run the tests

### Use bundletester

```
sudo bundletester -F -t cs:~adam-stokes/dokuwiki -l DEBUG -v -r json -o /tmp/results.json
```

### Run tests via Ruby bundler

```
bundle install --local --with development
bundle exec ./tests/verify
```

A few package dependencies are required for testing locally, have a look in **tests/tests.yaml** for those package names.

# Author

Adam Stokes <adam.stokes@ubuntu.com>

# Copyright

2016 Adam Stokes

# License

MIT
