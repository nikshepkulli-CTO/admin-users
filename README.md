### README: Automating User Creation and SSH Key Setup

This script automates the process of creating Linux users on an EC2 instance, configuring SSH access for them, and adding their public keys extracted from `.pem` files. It is particularly useful for managing multiple users with `.pem` private key files.

---

### **How It Works**
1. Reads all `.pem` files in a specified directory.
2. Extracts usernames from the `.pem` file names.
3. Generates the corresponding public key for each `.pem` file.
4. Creates a new Linux user (if not already present) with the extracted username.
5. Configures SSH access for the user by adding their public key to the `authorized_keys` file.

---

### **Prerequisites**
1. A directory containing `.pem` private key files.
   - Example: `/home/ec2-user/keys/`
2. Ensure you have `sudo` access on the EC2 instance.
3. Install necessary tools like `ssh-keygen` (usually available by default).

---

### **Setup and Execution**

#### 1. Place `.pem` Files in the Directory
- Store all `.pem` files in the directory `/home/ec2-user/keys/`.

#### 2. Create the Script
- Save the provided script as `add_users.sh` in your EC2 instance.

#### 3. Set Execute Permission
- Make the script executable:
  ```bash
  chmod +x add_users.sh
  ```

#### 4. Run the Script
- Execute the script with `sudo`:
  ```bash
  sudo ./add_users.sh
  ```

---

### **What the Script Does**
- **Processes `.pem` Files**: Reads all `.pem` files in the `/home/ec2-user/keys/` directory.
- **Generates Public Key**: Extracts the public key from each `.pem` file using `ssh-keygen`.
- **Creates Users**:
  - Adds a new user if the username (derived from the file name) does not already exist.
  - Skips user creation if the user already exists.
- **Configures SSH**:
  - Creates the `.ssh` directory for the user.
  - Sets proper permissions for `.ssh` and `authorized_keys`.
  - Adds the generated public key to the `authorized_keys` file.
  - Ensures correct ownership of the user's `.ssh` directory and files.
- **Logs**: Outputs the progress and skips any `.pem` files with errors.

---

### **Directory and File Structure**
#### Input Directory:
- All `.pem` files should be in `/home/ec2-user/keys/`:
  ```
  /home/ec2-user/keys/
  ├── alice.pem
  ├── bob.pem
  ├── carol.pem
  ```

#### Result:
- After the script runs, new users (`alice`, `bob`, `carol`, etc.) will be created, and their public keys will be added to:
  ```
  /home/<username>/.ssh/authorized_keys
  ```

---

### **Troubleshooting**
1. **Public Key Generation Fails**:
   - Ensure the `.pem` files have the correct permissions:
     ```bash
     chmod 600 /path/to/file.pem
     ```
   - Verify the file is a valid private key by running:
     ```bash
     ssh-keygen -y -f /path/to/file.pem
     ```

2. **User Already Exists**:
   - The script skips creating the user but still configures SSH access for them.

3. **Permissions Issues**:
   - Ensure the script is executed with `sudo`.

4. **Error Messages**:
   - Check the logs output by the script for details.

---

### **Extending the Script**
- Add support for logging to a file:
  ```bash
  ./add_users.sh | tee add_users.log
  ```
- Customize the username extraction logic if file names don't align with desired usernames.
- Integrate with a central user management system.

---

### **Acknowledgments**
This script is based on best practices for user management on Amazon Linux 2023, leveraging SSH for secure authentication.

Let me know if you need further modifications or additional features!
