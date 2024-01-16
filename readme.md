### Tasks
- [ ] Install k3s automatically withot any manual configuration (actually, it's not possible to do it automatically, because I need create nodes labels, namespaces manually. K3s ansible role have some limitations)
- [ ] Get kubeconfig from k3s server

### Notes
```sudo ifconfig eth0 mtu 1392 up``` 
Command to fix MTU problem when using VPN and Helm. See [this](https://github.com/helm/helm/issues/10049)





