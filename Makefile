# make appropriate changes before running the scripts
# START OF CONFIG =====================================================================================================
# use 'azmfaridee/dl' in the image name field if you want to use the pre-built image
# otherwise, assign your own name for the image and build with 'make docker-build' command
IMAGE=azmfaridee/dl

# assign an easily identifiable name for your docker container e.g. faridee_project1
CONTAINER=yourname_projectname

# index starts at 0 and ends at 3. Use comma seperated values if you need more than one gpu
AVAILABLE_GPUS='0'

# modify all the port numbers so that there's no conflict with other users
LOCAL_JUPYTER_PORT=18888
LOCAL_TENSORBOARD_PORT=16006
VSCODE_PORT=18443
R_STUDIO_PORT=18787
# END OF CONFIG  ======================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-run:
	NV_GPU=$(AVAILABLE_GPUS) docker run -it -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -p $(R_STUDIO_PORT):8787 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)

docker-shell:
	docker exec -it $(CONTAINER) bash

docker-tensorboard:
	docker exec -it $(CONTAINER) tensorboard --logdir=logs

docker-clean:
	docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE) .

docker-vscode:
	docker exec -it $(CONTAINER) code-server -p 8443 --disable-telemetry -d /vscode /notebooks

docker-push:
	docker push $(IMAGE)

docker-rstudio:
	docker exec -it $(CONTAINER) rstudio-server start


