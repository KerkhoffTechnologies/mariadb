mariadb-repo:
  pkgrepo.managed:
    - humanname: MariaDB Repository
    - name: deb [arch=amd64,i386,ppc64el] http://ams2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main
    - dist: xenial
    - file: /etc/apt/sources.list.d/mariadb.list
    - keyid: 0xF1656F24C74CD1D8
    - keyserver: keyserver.ubuntu.com

