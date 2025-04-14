# CPSY302-AdvancedServerInfrastructure
Grade: A+ | Fall 2024 Final Project

A comprehensive proof-of-concept project built entirely in VMware Workstation, simulating enterprise-grade IT infrastructure with Windows and Linux interoperability, secure remote access, domain services, web hosting, and controlled file sharing.

Key Highlights:
- Designed and deployed a full-scale internal network with Active Directory, DNS, DHCP, and IIS web services
- Created a custom domain, provisioning 20+ domain users/groups via PowerShell automation
- Configured a Microsoft VPN server with RADIUS (NPS) authentication and dual-NIC NAT routing to enable secure internal/external communication
- Deployed Windows and CentOS 9 clients, joined to the domain, and validated cross-platform access to services
- Installed and configured Samba and Apache on Linux for both public and restricted web hosting
- Implemented SMB file shares with AGLP permission modeling to align access control with department needs
- Enabled VPN failover and DHCP load-balancing between the Domain Controller and VPN server using a 60/40 scope split
- Simulated external client testing: verified VPN connectivity, web accessibility, and remote server management via RSAT and SSH

This project demonstrates my learned competencies and capability in enterprise network design, virtualization, and secure system administration using real-world tools and practices.
