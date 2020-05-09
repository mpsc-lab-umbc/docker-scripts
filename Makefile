# make appropriate changes before running the scripts
# START OF CONFIG =====================================================================================================
IMAGE=azmfaridee/dl:latest
CONTAINER=yourname_projectname
AVAILABLE_GPUS='0'
LOCAL_JUPYTER_PORT=48888
LOCAL_TENSORBOARD_PORT=46006
VSCODE_PORT=48443
MATLAB_PORT=46080
PASSWORD=your_vscode_and_jupyter_pass
# END OF CONFIG  ======================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-run:
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -e JUPYTER_TOKEN=$(PASSWORD) -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)

docker-shell:
	docker exec -it $(CONTAINER) bash

docker-clean:
	docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE) .
	
docker-rebuild:
	docker build -t $(IMAGE) --no-cache --pull .

docker-push:
	docker push $(IMAGE)

docker-tensorboard:
	docker exec -it $(CONTAINER) tensorboard --logdir=logs

docker-vscode:
	docker exec -it $(CONTAINER) code-server --port 8443 --auth password --disable-telemetry /notebooks

docker-matlab-run:
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -p $(MATLAB_PORT):6080 --name matlab_test nvcr.io/partners/matlab:r2019b
