# Mount Olympus

A landing page for my personal home server *Olympus*, for displaying links to the applications available on the local network. The application simply generates a static `HTML` page which can then be served (see [Dockerfile](./Dockerfile).

Run locally with: `go run .` and open the `index.html` file, or run via Docker/Podman to also serve the page on `8080`.

```sh
podman build -t mount_olympus .
podman run --init -p 8080:8080 localhost/mount_olympus:latest
```

[links.yml](./links.yml) is expected to be available in the directory as the source of links.
