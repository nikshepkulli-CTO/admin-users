
PEM_DIR="/home/ec2-user/keys"

# Loop through each PEM file in the directory
for pem_file in "$PEM_DIR"/*.pem; do
    # Extract the username from the PEM file name
    username=$(basename "$pem_file" .pem)

    echo "Processing user: $username"

    # Step 1: Generate the public key from the PEM file
    if ! public_key=$(ssh-keygen -y -f "$pem_file" 2>/dev/null); then
        echo "Error generating public key for $pem_file. Skipping..."
        continue
    fi

    # Step 2: Create the user
    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping user creation."
    else
        sudo adduser "$username"
        echo "User $username created successfully."
    fi

    # Step 3: Switch to the user's home directory and set up SSH
    user_home="/home/$username"
    sudo mkdir -p "$user_home/.ssh"
    sudo chmod 700 "$user_home/.ssh"

    # Step 4: Add the public key to authorized_keys
    sudo bash -c "echo '$public_key' >> $user_home/.ssh/authorized_keys"
    sudo chmod 600 "$user_home/.ssh/authorized_keys"

    # Step 5: Ensure correct ownership of the SSH files
    sudo chown -R "$username:$username" "$user_home/.ssh"

    echo "SSH access configured for $username."
done

echo "All users processed successfully."
