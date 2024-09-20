# Linux-servers-health-check-automation-script

Automated Health Checks: Enhancing QRadar System Reliability through Automation.

Problem Statement :
The Security Operations Center (SOC) faced a considerable challenge in maintaining the daily health of QRadar systems across 30-40 client Linux servers. The manual process, essential for optimal system performance, was laborious and time-intensive, consuming 2-3 hours daily. This not only strained resources but also introduced a risk of human error, calling for a more efficient solution.

Solution provided by Engineering Team : 
To address this operational inefficiency, the Engineering Team developed an automated solution using a Python script. This script was tailored to conduct thorough health checks, examining disk space and service statuses on all client QRadar Linux servers. The automation aimed to replace the manual effort, enhancing accuracy and efficiency in the daily health assessment routine.

Result : 
The implementation of the Python script transformed the health check process, reducing the assessment time to under a minute per server. This efficiency gain cut down the total daily commitment to less than half an hour, freeing up valuable technical resources and minimizing the margin for error. The automation has not only bolstered operational productivity but also reinforced the reliability of the SOC's monitoring capabilities, ensuring the steadfast performance of QRadar systems.

Find the code below : 
Make Directory scripts_healthcheck , create healthcheck.sh script on linux server and give chmod +x healthcheck.sh (CLI of QRadar , EC / EP) then vi healthcheck.sh
then copy and paste below code : close with Cntrl + ESC wq! And finally run the script using sh cortex.sh

#!/bin/bash

#All server IPs dynamically from /opt/qradar/support/all_servers.sh
SERVER_IPS=$(/opt/qradar/support/all_servers.sh | awk '{print $1}')

# Get current date and time to create the output file
OUTPUT_FILE="$(date +'%Y-%m-%d_%H-%M').txt"

# Create or clear the output file
> "$OUTPUT_FILE"

# Function to fetch /store % value using df -h
fetch_store_info() {
    local HOST=$1

    # Fetch the /store usage percentage and append to the output file
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$HOST" "df -h /store | awk 'NR==2 {print \$5}'" 2>/dev/null | awk -v host="$HOST" '{print host, $0}' >> "$OUTPUT_FILE"
}

# Loop through all the server IPs and fetch /store % value for each
for HOST in $SERVER_IPS; do
    fetch_store_info "$HOST"
done

echo "All /store % values fetched and saved to $OUTPUT_FILE"
