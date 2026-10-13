import os
from codeproject_ai_sdk import ModuleOptions

class Settings:

    def __init__(self, RESOLUTION, STD_MODEL_NAME, STD_SEG_MODEL_NAME):
        self.RESOLUTION         = RESOLUTION
        self.STD_MODEL_NAME     = STD_MODEL_NAME
        self.STD_SEG_MODEL_NAME = STD_SEG_MODEL_NAME


class Options:

    def __init__(self):
        # -------------------------------------------------------------------------
        # Setup constants

        # see https://github.com/ultralytics/yolo26 for resolution data
        self.MODEL_SETTINGS = {
            "nano":   Settings(STD_MODEL_NAME = "yolo26n", STD_SEG_MODEL_NAME = "yolo26n-seg", RESOLUTION = 640),
            "small":  Settings(STD_MODEL_NAME = "yolo26s", STD_SEG_MODEL_NAME = "yolo26s-seg", RESOLUTION = 640),
            "medium": Settings(STD_MODEL_NAME = "yolo26m", STD_SEG_MODEL_NAME = "yolo26m-seg", RESOLUTION = 640),
            "large":  Settings(STD_MODEL_NAME = "yolo26l", STD_SEG_MODEL_NAME = "yolo26l-seg", RESOLUTION = 640),
            "xlarge": Settings(STD_MODEL_NAME = "yolo26x", STD_SEG_MODEL_NAME = "yolo26x-seg", RESOLUTION = 640)
        }

        # -------------------------------------------------------------------------
        # Setup values

        self._show_env_variables = True

        self.app_dir            = os.path.normpath(ModuleOptions.getEnvVariable("APPDIR", os.getcwd()))
        self.models_dir         = os.path.normpath(ModuleOptions.getEnvVariable("MODELS_DIR", f"{self.app_dir}/assets"))
        self.custom_models_dir  = os.path.normpath(ModuleOptions.getEnvVariable("CUSTOM_MODELS_DIR", f"{self.app_dir}/custom-models"))

        self.sleep_time         = 0.01

        self.model_size         = ModuleOptions.getEnvVariable("MODEL_SIZE", "nano")    # nano, small, medium, large, x-large
        self.use_CUDA           = ModuleOptions.getEnvVariable("USE_CUDA",   "True")    # True / False
        self.use_MPS            = True          # only if available...
        self.use_DirectML       = True          # only if available...

        # Normalise input
        self.model_size         = self.model_size.lower()
        self.use_CUDA           = ModuleOptions.enable_GPU and self.use_CUDA.lower() == "true"

        if self.model_size not in [ "nano", "small", "medium", "large", "xlarge" ]:
            self.model_size = "nano"

        # Get settings
        settings = self.MODEL_SETTINGS[self.model_size]   
        self.resolution_pixels  = settings.RESOLUTION
        self.std_model_name     = settings.STD_MODEL_NAME
        self.std_seg_model_name = settings.STD_SEG_MODEL_NAME

        # -------------------------------------------------------------------------
        # dump the important variables

        if self._show_env_variables:
            print(f"Debug: APPDIR:      {self.app_dir}")
            print(f"Debug: MODEL_SIZE:  {self.model_size}")
            print(f"Debug: MODELS_DIR:  {self.models_dir}")
