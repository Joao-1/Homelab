# Homelab
## Overview
This project aims to develop and maintain my own home lab environment, utilizing Kubernetes across all my physical and virtual machines. All here is in the alpha stage, so things still need some polish.
### Hardware
<img src="https://github.com/Joao-1/Homelab/assets/58475277/9fe76063-80db-4d24-bbba-1fd181563271" alt="Imagem Redimensionada" width="500" height="500"> <br >
#### Local
- An old PC that was used for gaming:
    - CPU: `Intel Core i7-7700K @ 4.50GHz`
    - RAM: `16GB`
    - SSD: `240GB`
    - HD: `Seagate BarraCuda, 1TB`
- 2x Respberry Pi `3`
#### Cloud
- 2x Oracle `VM.Standard.A1.Flex` (free tier):
    - VPN Only:
      - CPU: `1 OCPU`
      - RAM: `2GB`
    - Kubernetes node:
      - CPU: `3 OCPU`
      - RAM: `22GB`
- 2x Oracle `VM.Standard.E2.1.Micro` (free tier):
    - CPU: `1 OCPU`
    - RAM: `1GB`
 
### Tasks
- [ ] Install k3s automatically withot any manual configuration (actually, it's not possible to do it automatically, because I need create nodes labels, namespaces manually. K3s ansible role have some limitations)





