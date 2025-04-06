#!/bin/bash

"""
Description: A Bash script for automated domain reconnaissance that performs subdomain enumeration, 
active subdomain verification, historical URL extraction, and vulnerability pattern filtering.
Author: jdcd333
Version: 1.0
"""

# Configuration
RATE_LIMIT=30  # Requests per minute to avoid blocks

# Colors for better visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required tools verification
check_tools() {
    echo -e "${BLUE}[*]${NC} Verifying required tools..."
    tools=("subfinder" "httpx" "waybackurls" "gf")
    missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
            echo -e "${RED}[-]${NC} $tool is not installed or not in PATH"
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo -e "${RED}[ERROR]${NC} Missing tools: ${missing_tools[*]}"
        exit 1
    fi
    echo -e "${GREEN}[+]${NC} All tools are installed"
}

# Show options menu
show_menu() {
    echo -e "\n${YELLOW}=== Options Menu ===${NC}"
    echo "1) Change target domain"
    echo "2) Run full enumeration"
    echo "3) Subdomain enumeration only"
    echo "4) Active subdomains verification only"
    echo "5) Historical URLs extraction only"
    echo "6) Apply gf filter to existing results"
    echo "7) Show generated files summary"
    echo "8) Exit"
}

# Function to change target domain
change_domain() {
    echo -e "\n${YELLOW}[*]${NC} Current domain: ${GREEN}$DOMAIN${NC}"
    read -p "Enter new target domain (example.com): " new_domain
    if [[ -n "$new_domain" ]]; then
        DOMAIN="$new_domain"
        echo "$DOMAIN" > target_domain.txt
        echo -e "${GREEN}[+]${NC} Target domain changed to: ${GREEN}$DOMAIN${NC}"
    else
        echo -e "${RED}[-]${NC} No valid domain provided"
    fi
}

# Step 1: Subdomain enumeration
enumerate_subdomains() {
    echo -e "\n${BLUE}[*]${NC} Searching subdomains for ${GREEN}$DOMAIN${NC}..."
    subfinder -d "$DOMAIN" -recursive -silent -o subdomains.txt
    SUBDOMAIN_COUNT=$(wc -l < subdomains.txt)
    echo -e "${GREEN}[+]${NC} Found $SUBDOMAIN_COUNT subdomains. Saved in subdomains.txt"
}

# Step 2: Active subdomains verification
check_active_subdomains() {
    echo -e "\n${BLUE}[*]${NC} Testing active subdomains with rate-limiting..."
    cat subdomains.txt | httpx -silent -rate-limit $RATE_LIMIT -o active_subdomains.txt
    ACTIVE_COUNT=$(wc -l < active_subdomains.txt)
    echo -e "${GREEN}[+]${NC} Found $ACTIVE_COUNT active subdomains. Saved in active_subdomains.txt"
}

# Step 3: Historical URLs extraction
get_historical_urls() {
    echo -e "\n${BLUE}[*]${NC} Extracting historical URLs..."
    cat active_subdomains.txt | waybackurls > way.txt
    URL_COUNT=$(wc -l < way.txt)
    echo -e "${GREEN}[+]${NC} Found $URL_COUNT historical URLs. Saved in way.txt"
}

# Step 4: Apply gf filter
apply_gf_filter() {
    echo -e "\n${YELLOW}Available gf patterns:${NC}"
    gf -list
    read -p "Enter pattern to use (ex: xss, sqli, etc): " gf_pattern
    
    if [[ -n "$gf_pattern" ]]; then
        echo -e "${BLUE}[*]${NC} Applying gf filter with pattern ${GREEN}$gf_pattern${NC}..."
        cat way.txt | gf "$gf_pattern" > "gf_${gf_pattern}_results.txt"
        echo -e "${GREEN}[+]${NC} Results saved in gf_${gf_pattern}_results.txt"
    else
        echo -e "${RED}[-]${NC} No valid pattern provided"
    fi
}

# Show files summary
show_summary() {
    echo -e "\n${YELLOW}=== Generated Files Summary ===${NC}"
    ls -lh subdomains.txt active_subdomains.txt way.txt gf_*_results.txt 2>/dev/null
    echo -e "\n${YELLOW}=== Results Count ===${NC}"
    echo -e "Subdomains found: ${GREEN}$(wc -l < subdomains.txt 2>/dev/null || echo 0)${NC}"
    echo -e "Active subdomains: ${GREEN}$(wc -l < active_subdomains.txt 2>/dev/null || echo 0)${NC}"
    echo -e "Historical URLs: ${GREEN}$(wc -l < way.txt 2>/dev/null || echo 0)${NC}"
}

# Main function
main() {
    # Verify tools first
    check_tools
    
    # Load target domain
    if [ -f "target_domain.txt" ]; then
        DOMAIN=$(cat target_domain.txt)
    else
        read -p "Enter target domain (example.com): " DOMAIN
        echo "$DOMAIN" > target_domain.txt
    fi
    
    echo -e "\n${YELLOW}[*]${NC} Target domain: ${GREEN}$DOMAIN${NC}"
    
    while true; do
        show_menu
        read -p "Select an option (1-8): " choice
        
        case $choice in
            1) change_domain ;;
            2) 
                enumerate_subdomains
                check_active_subdomains
                get_historical_urls
                apply_gf_filter
                ;;
            3) enumerate_subdomains ;;
            4) check_active_subdomains ;;
            5) get_historical_urls ;;
            6) apply_gf_filter ;;
            7) show_summary ;;
            8) 
                echo -e "${GREEN}[+]${NC} Exiting script..."
                exit 0
                ;;
            *) echo -e "${RED}[-]${NC} Invalid option. Try again." ;;
        esac
    done
}

main "$@"
