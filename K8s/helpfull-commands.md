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