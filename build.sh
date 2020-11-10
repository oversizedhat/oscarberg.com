docker run --rm -it \
  --volume $(pwd):/src \
  klakegg/hugo:0.78.0-alpine \
  -b https://oversizedhat.github.io/oscarberg.com