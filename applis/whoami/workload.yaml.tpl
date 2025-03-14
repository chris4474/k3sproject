---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: whoami-server
  namespace: ${namespace}

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: whoami-client
  namespace: ${namespace}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami
  namespace: ${namespace}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: whoami
  template:
    metadata:
      labels:
        app: whoami
    spec:
      serviceAccount: whoami-server
      containers:
        - name: whoami
          image: traefik/whoami:v1.7.1
          imagePullPolicy: IfNotPresent

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami-tcp
  namespace: ${namespace}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: whoami-tcp
  template:
    metadata:
      labels:
        app: whoami-tcp
    spec:
      serviceAccount: whoami-server
      containers:
        - name: whoami-tcp
          image: traefik/whoamitcp:v0.2.1
          imagePullPolicy: IfNotPresent

---
apiVersion: v1
kind: Service
metadata:
  name: whoami
  namespace: ${namespace}
  labels:
    app: whoami
spec:
  type: ClusterIP
  ports:
    - port: 80
      name: whoami
  selector:
    app: whoami

---
apiVersion: v1
kind: Service
metadata:
  name: whoami-tcp
  namespace: ${namespace}
  labels:
    app: whoami-tcp
spec:
  type: ClusterIP
  ports:
    - port: 8080
      name: whoami-tcp
  selector:
    app: whoami-tcp

---
apiVersion: v1
kind: Pod
metadata:
  name: whoami-client
  namespace: ${namespace}
spec:
  serviceAccountName: whoami-client
  containers:
    - name: whoami-client
      image: wbitt/network-multitool:minimal
      command:
        - "sleep"
        - "3600"
