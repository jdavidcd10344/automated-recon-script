# automated-recon-script
A Bash script for automated domain reconnaissance that performs subdomain enumeration, active subdomain verification, historical URL extraction, and vulnerability pattern filtering.
# Domain Reconnaissance Toolkit

An automated Bash script for comprehensive domain reconnaissance including:
- Subdomain enumeration
- Active subdomain verification
- Historical URL extraction
- Vulnerability pattern filtering

## Features
- Interactive menu system
- Rate limiting to avoid blocks
- Color-coded output for better visibility
- Modular operations (run full scan or individual steps)
- Results summary and tracking

## Prerequisites
Install these tools before use:
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [httpx](https://github.com/projectdiscovery/httpx)
- [waybackurls](https://github.com/tomnomnom/waybackurls)
- [gf](https://github.com/tomnomnom/gf)

## Installation
```bash
git clone https://github.com/yourusername/domain-recon-toolkit.git
cd domain-recon-toolkit
chmod +x domain_recon.sh
```
Usage

```
./domain_recon.sh
```
Follow the interactive menu to:

Set/change target domain

Run full enumeration

Execute individual steps

Apply gf filters

View results summary

Output Files
subdomains.txt: All found subdomains

active_subdomains.txt: Verified active subdomains

way.txt: Historical URLs

gf_*_results.txt: Filtered results by vulnerability pattern

Rate Limiting
The script defaults to 30 requests per minute (configurable) to avoid rate limiting or blocks.


