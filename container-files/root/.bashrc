set -o allexport # Export all variables that are defined in the script

echo '           __________
         .'\''----------'\''.
         | .--------. |
         | |########| |       __________
         | |########| |      /__________\
.--------| '\''--------'\'' |------|    --=-- |-------------.
|        '\''----,-.-----'\''      |o ======  |             |
|       ______|_|_______     |__________|             |
|      /  %%%%%%%%%%%%  \                             |
|     /  %%%%%%%%%%%%%%  \                            |
|     ^^^^^^^^^^^^^^^^^^^^                            |
+-----------------------------------------------------+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'

# If the environment variable GOOGLE_APPLICATION_CREDENTIALS_encoded is not empty, then set new environment variable GOOGLE_APPLICATION_CREDENTIALS with base64 decode command
if [ -n "$GOOGLE_APPLICATION_CREDENTIALS_encoded" ]; then
    echo "Found GOOGLE_APPLICATION_CREDENTIALS encoded variable. Decoding..."
    mkdir -p /root/.gcp
    echo "$GOOGLE_APPLICATION_CREDENTIALS_encoded" | base64 -d >/root/.gcp/credentials.json
    export GOOGLE_APPLICATION_CREDENTIALS=/root/.gcp/credentials.json
    gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"
    gcloud config set project "$GOOGLE_DEFAULT_PROJECT_ID"
    gcloud config set account "$(jq -r .client_email "$GOOGLE_APPLICATION_CREDENTIALS")"
    GOOGLE_APPLICATION_CREDENTIALS=$(readlink -f "$GOOGLE_APPLICATION_CREDENTIALS")
    gcloud auth list
fi

function display_ps1() {
    LAST_COMMAND=$? # Must come first!

    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local BLUE="\033[0;34m"
    local CYAN="\033[0;36m"
    local NOCOLOR="\033[0m"

    MESSAGE="\[$CYAN\]\342\224\214\342\224\200"

    # Show error message
    if [[ $LAST_COMMAND != 0 ]]; then
        MESSAGE+="\[${LIGHTRED}\][Error: \[${LIGHTRED}\]${LAST_COMMAND}]\[$NOCOLOR\]-"
    fi

    # Show date/time
    MESSAGE+="\[$BLUE\][\D{%F %T}]" # Time

    MESSAGE+="\[$NOCOLOR\]-"

    DIR="$(pwd)"

    # Show Terraform - Check if the folder contains the file "backend.tf"
    if [ -f "$DIR/backend.tf" ]; then
        TERRAFORM_WORKSPACE="$(terraform workspace show)"
        if [ "$TERRAFORM_WORKSPACE" == "default" ]; then
            MESSAGE+="\[$CYAN\][Terraform: \[$RED\]${TERRAFORM_WORKSPACE^^}\[$CYAN\]]"
        else
            MESSAGE+="\[$CYAN\][Terraform: \[$GREEN\]${TERRAFORM_WORKSPACE^^}\[$CYAN\]]"
        fi
    else
        MESSAGE+="[Terraform: N/A]"
    fi

    MESSAGE+="\[$NOCOLOR\]\n"

    printf "%s\[$CYAN\]\342\224\224>\[$NOCOLOR\]\w\\$ " "$MESSAGE"
}

export PROMPT_COMMAND='PS1=$(display_ps1)'
