# automated-recon-script
A Bash script for automated domain reconnaissance that performs subdomain enumeration, active subdomain verification, historical URL extraction, and vulnerability pattern filtering.
Usage
bash
Copy
./domain_recon.sh
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

License
MIT License - see LICENSE file

Copy

### Additional GitHub Files

1. **LICENSE** (MIT recommended)
2. **.gitignore** (should include `target_domain.txt` and output files if you want them excluded)
3. **requirements.txt** (list of tools needed)
4. **CONTRIBUTING.md** (optional, for collaboration guidelines)

### Tags
`security` `reconnaissance` `bug-bounty` `subdomains` `web-security` `bash-script`

### Recommended GitHub Topics
- web-security
- recon-tool
- bug-bounty-tools
- subdomain-enumeration
- bash-automation

This setup provides a professional GitHub repository with all necessary documentation for others to use your script effectively.
