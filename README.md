## Custom CodeProject.AI-(v2.9.5) Modules

A collection of optimized third-party microservice modules for CodeProject.AI Server.

---

## 🛠️ How to Install Modules

Follow these steps to manually load these modules into your local CodeProject.AI Server instance:

### First things First! Open the CodeProject.AL dashboard and stop your current Object Detection (Yolo*) module and make sure it stops. You should not run multiple versions of Object Detection modules at the same time.

### Step 1: Download the Modules
1. Click the green **Code** button at the top right of this GitHub page.
2. Select **Download ZIP**.
3. Save and extract the `.zip` file anywhere on your computer.

### Step 2: Copy the Module Folder
1. Open the extracted folder and locate the **`ObjectDetectionYOLO26`** folder.
2. Copy the **`ObjectDetectionYOLO26`** folder entirely.
3. Paste it directly into your local CodeProject.AI modules directory, usually located at:
   `C:\Program Files\CodeProject\AI\modules\`

### Step 3: Initialize and Register the Module
1. Open **Command Prompt** as an **Administrator**.
2. Navigate to your new module folder by running:
   ```cmd
   cd "C:\Program Files\CodeProject\AI\modules\ObjectDetectionYOLO26"
   ```
3. Run the CodeProject setup.bat script to build the virtual environment and fetch the models:
   ```cmd
   ..\..\setup.bat
   ```
4. Restart your **CodeProject.AI Server** service. The new module will initialize inside your local system dashboard and be designated as 'Private' under the Install Modules Tab. If you encounter errors during setup.bat, open Windows Explorer and navigate to the ObjectDetectionYOLO26\logs folder and checkout the log files to help pinpoint and troubleshoot the problem.
   
### Step 4: Verify and Confirm your Module Enviornment
1. Open **Command Prompt** as an **Administrator**.
2. Navigate to the ObjectDetectionYOLO26 Python 3.12 scripts folder by running:
   ```cmd
   cd "C:\Program Files\CodeProject\AI\modules\ObjectDetectionYOLO26\bin\windows\python312\venv\Scripts"
   ```
3. Copy, paste and run this python script from the 'python312\venv\Scripts' folder:
    ```cmd
    python.exe -c "import sys, torch, numpy; print(f'--- ENVIRONMENT STATUS ---\nPython: {sys.version.split()[0]}\nNumPy: {numpy.__version__}\nPyTorch: {torch.__version__}\nCUDA Available: {torch.cuda.is_available()}\nGPU Model: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"None\"}\ncuDNN Version: {torch.backends.cudnn.version()}\n--------------------------')"
 
 You should see something like this that verifies the isolated environment of your ObjectDetectionYOLO26 module including, CUDA 12.4 and cuDNN 9 running inside the module. There's no need to modify or reconfigure your existing CUDA or cuDNN global installations within the Windows environment.
  
#### ENVIRONMENT STATUS: 
##### Python: 3.12.4
##### NumPy: 2.2.3
##### PyTorch: 2.6.0+cu124
##### CUDA Available: True
##### GPU Model: NVIDIA GeForce RTX 2060
##### cuDNN Version: 90100
 

    
