docker run --rm -it \
  --user 1000:1000 \
  --volume $(pwd):/src \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro" \
  -p 1313:1313 \
  klakegg/hugo:0.79.0-alpine \
  shell