Start up the whoming server, which does speach to text for the Home Assistant:

```
docker compose -f 'docker-compose.yaml' up -d --build 'wyoming-whisper'
```

Confirm it's running:

```
docker compose logs -f -t
```

## Issues

Probably the best info on installing NVIDIA drivers on Debian, includes the
steps needed to disable the nouveau drivers:

https://docs.kinetica.com/7.2/install/nvidia_deb/