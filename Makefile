# make appropriate changes before running the scripts
# START OF CONFIG =====================================================================================================
IMAGE=azmfaridee/dl:latest
CONTAINER=yourname_projectname
AVAILABLE_GPUS='0'
LOCAL_JUPYTER_PORT=18888
LOCAL_TENSORBOARD_PORT=16006
VSCODE_PORT=18443
# END OF CONFIG  ======================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-run:
	NV_GPU=$(AVAILABLE_GPUS) docker run -it -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -p $(R_STUDIO_PORT):8787 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)

docker-shell:
	docker exec -it $(CONTAINER) bash

docker-clean:
	docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE) .

docker-push:
	docker push $(IMAGE)

docker-tensorboard:
	docker exec -it $(CONTAINER) tensorboard --logdir=logs

docker-vscode:
	docker exec -it $(CONTAINER) code-server -p 8443 --disable-telemetry -d /vscode /notebooks
