#### run debug pod on selected node.

```bash
kubectl debug node/NodeName -it --image=busybox -- chroot /host/
```