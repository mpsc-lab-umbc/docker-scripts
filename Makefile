# make appropriate changes before running the scripts
# START OF CONFIG ============================================================================================================
IMAGE=azmfaridee/dl               # use 'azmfaridee/dl' if you want to use the pre-built image
                                  # otherwise, assign your own name for the image and build with 'make docker-build' command
CONTAINER=yourname_projectname    # e.g. faridee_project1
AVAILABLE_GPUS='0'                # index starts at 0 and ends at 3. Use comma seperated values if you need more than one gpu
LOCAL_JUPYTER_PORT=18888          # modify this number so that there's no conflict with other users
LOCAL_TENSORBOARD_PORT=16006      # modify this number so that there's no conflict with other users
VSCODE_PORT=18443                 # modify this number so that there's no conflict with other users
R_STUDIO_PORT=18787               # modify this number so that there's no conflict with other users
# END OF CONFIG  =============================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-run:
	NV_GPU=$(AVAILABLE_GPUS) docker run -it -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p $(LOCAL_TENSORBOARD_PORT):6006 -p $(R_STUDIO_PORT):8787 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)

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


