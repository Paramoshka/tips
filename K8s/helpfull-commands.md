#### run debug pod on selected node.

```bash
kubectl debug node/NodeName -it --image=busybox -- chroot /host/
```

#### Attach to Pod with debug container

```bash
kubectl -n demo-namaspace debug demo-pod -it \
  --image=nicolaka/netshoot \
  --target=controller \
  -- bash
```

#### Find snippets in for ingressClass

```bash
kubectl get ing -A -o jsonpath='
{range .items[?(@.spec.ingressClassName=="public")]}
{.metadata.namespace}/{.metadata.name}{"\t"}
{..annotations.nginx\.ingress\.kubernetes\.io/location-snippet}{"\n"}
{end}'
```


#### Get events sorted by time for Pod

```bash
kubectl -n demo-namaspace get events --field-selector involvedObject.name=demo-pod --sort-by=.lastTimestamp
```

#### Check ETCD performance and health

```bash
ETCD_POD=$(kubectl -n kube-system get po -l component=etcd -o name | head -1)
```

```bash
kubectl exec -n kube-system -it -c etcd "$ETCD_POD" -- \
  etcdctl --endpoints=https://10.130.0.20:2379,https://10.130.0.21:2379,https://10.130.0.31:2379 \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  check perf
  ```

```bash
kubectl exec -n kube-system -it -c etcd "$ETCD_POD" -- \
  etcdctl --endpoints=https://10.130.0.20:2379,https://10.130.0.21:2379,https://10.130.0.31:2379 \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key \
  endpoint health
```
