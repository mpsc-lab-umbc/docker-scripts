# make appropriate changes before running the scripts
# START OF CONFIG =====================================================================================================
IMAGE_TF2=azmfaridee/dl:tf2
IMAGE_PT=azmfaridee/dl:pt
CONTAINER=yourname_projectname
AVAILABLE_GPUS='0,1,2,3'
LOCAL_JUPYTER_PORT=48888
LOCAL_TENSORBOARD_PORT=46006
VSCODE_PORT=48443
MATLAB_PORT=46080
PASSWORD=your_vscode_and_jupyter_pass
# END OF CONFIG  ======================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-run:
	docker image pull $(IMAGE_TF2)
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -e JUPYTER_TOKEN=$(PASSWORD) -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE_TF2)

docker-run-pt:
	docker image pull $(IMAGE_PT)
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -e JUPYTER_TOKEN=$(PASSWORD) -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE_PT)
		
docker-stop:
	docker stop $(CONTAINER)

docker-shell:
	docker exec -it $(CONTAINER) bash

docker-clean:
	docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE_TF2) -f Dockerfile .
	docker build -t $(IMAGE_PT) -f Dockerfile.pytorch .
	
docker-rebuild:
	docker build -t $(IMAGE_TF2) -f Dockerfile --no-cache --pull .
	docker build -t $(IMAGE_PT) -f Dockerfile.pytorch --no-cache --pull .

docker-push:
	docker push $(IMAGE_TF2)
	docker push $(IMAGE_PT)

docker-tensorboard:
	docker exec -it $(CONTAINER) tensorboard --logdir=logs

docker-vscode:
	docker exec -it $(CONTAINER) code-server --bind-addr 0.0.0.0:8443 --auth password --disable-telemetry /notebooks

docker-matlab-run:
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -p $(MATLAB_PORT):6080 --shm-size=512M -e MLM_LICENSE_FILE=<port id>@<location> -v $(shell pwd):/notebooks --name matlab_test nvcr.io/partners/matlab:r2020a
# Replace the port and location for network license
