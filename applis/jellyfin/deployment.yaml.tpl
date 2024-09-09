apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    io.kompose.service: jellyfin
  name: jellyfin
  namespace: ${namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: jellyfin
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        io.kompose.service: jellyfin
    spec:
      containers:
        - env:
            - name: PGID
              value: "${syno_user_gid}"
            - name: PUID
              value: "${syno_user_uid}"
            - name: TZ
              value: Etc/UTC
            - name: JELLYFIN_PublishedServerUrl
              value: ${JellyfinPublishedUrl}
          image: lscr.io/linuxserver/jellyfin:latest
          name: jellyfin
          ports:
            - containerPort: 8096
              protocol: TCP
            - containerPort: 8920
              protocol: TCP
            - containerPort: 7359
              protocol: UDP
            - containerPort: 1900
              protocol: UDP
          volumeMounts:
            - mountPath: /config
              name: jellyfin-config
            - mountPath: /data/tvshows
              name: jellyfin-tvshows
            - mountPath: /data/movies
              name: jellyfin-movies
            - mountPath: /data/music
              name: jellyfin-music
      restartPolicy: Always
      volumes:
        - name: jellyfin-config
          persistentVolumeClaim:
            claimName: jellyfin-config
        - name: jellyfin-tvshows
          persistentVolumeClaim:
            claimName: jellyfin-tvshows
        - name: jellyfin-movies
          persistentVolumeClaim:
            claimName: jellyfin-movies
        - name: jellyfin-music
          persistentVolumeClaim:
            claimName: jellyfin-music

