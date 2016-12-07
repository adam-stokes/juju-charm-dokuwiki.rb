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

## Login

Initial login and password are

    username: admin
    password: password

## Generating a new password

The easiest way to generate a new password is via the `mkpasswd` command which
is provided in the `whois` package:

    $ sudo apt install whois
    $ mkpasswd -m sha-512 my_new_password@@@
    $6$0zZwr8m.$K9kPKN4WpeViQ1F/B4QsBeZIP.4z8i0UNQctXtp8c8ibRIQ6Tn.BUuxI/.tM9NU0yLzLxBPcp7NXTLKkd4f5d1
    $ juju config dokuwiki admin_password='$6$0zZwr8m.$K9kPKN4WpeViQ1F/B4QsBeZIP.4z8i0UNQctXtp8c8ibRIQ6Tn.BUuxI/.tM9NU0yLzLxBPcp7NXTLKkd4f5d1'

# Author

Adam Stokes <adam.stokes@ubuntu.com>

# Copyright

2016 Adam Stokes

# License

MIT
