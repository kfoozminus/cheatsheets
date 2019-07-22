export GO111MODULE=on
go get -u=patch

common mistake is thinking go get -u foo solely gets the latest version of foo. In actuality, the -u in go get -u foo or go get -u foo@latest means to also get the latest versions for all of the direct and indirect dependencies of foo. A common starting point when upgrading foo is instead to do go get foo or go get foo@latest without a -u (and after things are working, consider go get -u=patch foo, go get -u=patch, go get -u foo, or go get -u).

go mod vendor
